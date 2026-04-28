import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:takmed/core/database/app_database.dart';
import 'package:takmed/core/network/network_info.dart';
import 'package:takmed/features/learning/data/datasources/learning_remote_data_source.dart';
import 'package:takmed/features/learning/data/models/learning_sync_models.dart';
import 'package:takmed/features/learning/data/repositories/learning_repository_impl.dart';

class MockSupabaseClient extends Mock implements supabase.SupabaseClient {}

class FakeNetworkInfo implements NetworkInfo {
  FakeNetworkInfo({required this.connected});

  bool connected;

  @override
  Future<bool> get isConnected async => connected;
}

class FakeLearningRemoteDataSource implements LearningRemoteDataSource {
  final List<RemoteCourseDto> courses = <RemoteCourseDto>[];
  final List<RemoteLessonDto> lessons = <RemoteLessonDto>[];
  final List<RemoteUserProgressDto> remoteProgress = <RemoteUserProgressDto>[];
  final List<RemoteUserProgressDto> upsertedProgress =
      <RemoteUserProgressDto>[];

  int coursesCalls = 0;
  int lessonsCalls = 0;
  int progressCalls = 0;

  @override
  Future<List<RemoteCourseDto>> fetchCoursesUpdatedAfter(
    DateTime? updatedAfter,
  ) async {
    coursesCalls++;
    return courses
        .where(
          (c) =>
              updatedAfter == null || c.updatedAt.toUtc().isAfter(updatedAfter),
        )
        .toList();
  }

  @override
  Future<List<RemoteLessonDto>> fetchLessonsUpdatedAfter(
    DateTime? updatedAfter,
  ) async {
    lessonsCalls++;
    return lessons
        .where(
          (l) =>
              updatedAfter == null || l.updatedAt.toUtc().isAfter(updatedAfter),
        )
        .toList();
  }

  @override
  Future<List<RemoteUserProgressDto>> fetchUserProgressUpdatedAfter(
    String userId,
    DateTime? updatedAfter,
  ) async {
    progressCalls++;
    return remoteProgress
        .where((p) => p.userId == userId)
        .where(
          (p) =>
              updatedAfter == null ||
              p.effectiveUpdatedAt.toUtc().isAfter(updatedAfter),
        )
        .toList();
  }

  @override
  Future<void> upsertUserProgress(List<RemoteUserProgressDto> rows) async {
    upsertedProgress.addAll(rows);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late FakeLearningRemoteDataSource remoteDataSource;
  late FakeNetworkInfo networkInfo;
  late SharedPreferences prefs;
  late MockSupabaseClient supabaseClient;
  late LearningRepositoryImpl repository;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    remoteDataSource = FakeLearningRemoteDataSource();
    networkInfo = FakeNetworkInfo(connected: true);

    SharedPreferences.setMockInitialValues(<String, Object>{});
    prefs = await SharedPreferences.getInstance();

    supabaseClient = MockSupabaseClient();

    repository = LearningRepositoryImpl(
      db,
      remoteDataSource,
      networkInfo,
      prefs,
      supabaseClient,
      currentUserIdResolver: () => 'user-1',
    );
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> seedCourseAndLesson() async {
    await db.courseDao.upsertCourse(
      CoursesCompanion.insert(
        remoteId: 'course-1',
        title: 'Course',
        description: 'desc',
        track: 'military',
        orderIndex: 0,
        totalLessons: const Value(1),
        updatedAt: DateTime.utc(2026, 1, 1),
      ),
    );

    final course = await db.courseDao.getCourseByRemoteId('course-1');
    await db.lessonDao.upsertLesson(
      LessonsCompanion.insert(
        remoteId: 'lesson-1',
        courseId: course!.id,
        type: 'quiz',
        title: 'Lesson',
        contentJson: '{}',
        durationSeconds: 60,
        orderIndex: 0,
        updatedAt: Value(DateTime.utc(2026, 1, 1)),
      ),
    );
  }

  group('LearningRepositoryImpl syncWithServer', () {
    test('returns success and skips remote calls when offline', () async {
      networkInfo.connected = false;

      final result = await repository.syncWithServer();

      expect(result.isRight(), isTrue);
      expect(remoteDataSource.coursesCalls, 0);
      expect(remoteDataSource.lessonsCalls, 0);
      expect(remoteDataSource.progressCalls, 0);
      expect(remoteDataSource.upsertedProgress, isEmpty);
    });

    test(
      'applies newer remote progress and recalculates course progress',
      () async {
        await seedCourseAndLesson();

        await db.progressDao.upsertSyncedProgress(
          UserProgressCompanion.insert(
            userId: const Value('user-1'),
            lessonRemoteId: 'lesson-1',
            score: 40,
            attempts: 1,
            completedAt: DateTime.utc(2026, 1, 1),
            weakTopics: '[]',
            updatedAt: Value(DateTime.utc(2026, 1, 1)),
          ),
        );

        remoteDataSource.remoteProgress.add(
          RemoteUserProgressDto(
            userId: 'user-1',
            lessonRemoteId: 'lesson-1',
            score: 90,
            attempts: 2,
            completedAt: DateTime.utc(2026, 1, 2),
            weakTopics: const <String>['MARCH'],
            updatedAt: DateTime.utc(2026, 1, 3),
          ),
        );

        final result = await repository.syncWithServer();

        expect(result.isRight(), isTrue);
        expect(remoteDataSource.upsertedProgress, isEmpty);

        final progress = await db.progressDao.getProgressByUserAndLesson(
          'user-1',
          'lesson-1',
        );
        expect(progress, isNotNull);
        expect(progress!.score, 90);
        expect(progress.attempts, 2);
        expect(progress.isDirty, isFalse);

        final lesson = await db.lessonDao.getLessonByRemoteId('lesson-1');
        expect(lesson, isNotNull);
        expect(lesson!.isCompleted, isTrue);

        final course = await db.courseDao.getCourseByRemoteId('course-1');
        expect(course, isNotNull);
        expect(course!.completedLessons, 1);
      },
    );

    test('keeps newer local progress when remote is older', () async {
      await seedCourseAndLesson();

      await db.progressDao.saveProgress(
        UserProgressCompanion.insert(
          userId: const Value('user-1'),
          lessonRemoteId: 'lesson-1',
          score: 95,
          attempts: 1,
          completedAt: DateTime.utc(2026, 2, 10),
          weakTopics: '[]',
        ),
      );

      remoteDataSource.remoteProgress.add(
        RemoteUserProgressDto(
          userId: 'user-1',
          lessonRemoteId: 'lesson-1',
          score: 50,
          attempts: 1,
          completedAt: DateTime.utc(2026, 1, 1),
          weakTopics: const <String>[],
          updatedAt: DateTime.utc(2026, 1, 1),
        ),
      );

      final result = await repository.syncWithServer();

      expect(result.isRight(), isTrue);
      expect(remoteDataSource.upsertedProgress.length, 1);
      expect(remoteDataSource.upsertedProgress.first.score, 95);

      final progress = await db.progressDao.getProgressByUserAndLesson(
        'user-1',
        'lesson-1',
      );
      expect(progress, isNotNull);
      expect(progress!.score, 95);
      expect(progress.isDirty, isFalse);
    });
  });
}
