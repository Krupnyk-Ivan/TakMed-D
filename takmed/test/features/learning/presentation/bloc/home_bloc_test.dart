import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:takmed/features/gamification/data/services/gamification_service.dart';
import 'package:takmed/features/gamification/data/services/streak_service.dart';
import 'package:takmed/features/gamification/domain/models/user_level.dart';
import 'package:takmed/features/learning/domain/entities/course_entity.dart';
import 'package:takmed/features/learning/domain/entities/lesson_entity.dart';
import 'package:takmed/features/learning/domain/repositories/learning_repository.dart';
import 'package:takmed/features/learning/domain/usecases/download_course_offline_usecase.dart';
import 'package:takmed/features/learning/domain/usecases/get_courses_by_track_usecase.dart';
import 'package:takmed/features/learning/domain/usecases/get_next_lesson_usecase.dart';
import 'package:takmed/features/learning/presentation/bloc/home_bloc.dart';
import 'package:takmed/features/onboarding/domain/entities/user_track.dart';
import 'package:takmed/features/onboarding/domain/usecases/get_track_use_case.dart';
import 'package:takmed/core/errors/failures.dart';

class FakeGetCoursesByTrackUseCase implements GetCoursesByTrackUseCase {
  @override
  Stream<List<CourseEntity>> call(String track) => Stream.value([]);
  @override
  LearningRepository get repository => throw UnimplementedError();
}

class FakeGetNextLessonUseCase implements GetNextLessonUseCase {
  @override
  Future<Either<Failure, LessonEntity?>> call() async => const Right(null);
  @override
  LearningRepository get repository => throw UnimplementedError();
}

class FakeGetTrackUseCase implements GetTrackUseCase {
  @override
  Future<Either<Failure, UserTrack?>> call() async => const Right(UserTrack.military);
}

class FakeDownloadCourseOfflineUseCase implements DownloadCourseOfflineUseCase {
  @override
  Future<Either<Failure, Unit>> call(int courseId) async => const Right(unit);
  @override
  LearningRepository get repository => throw UnimplementedError();
}

class FakeGamificationService implements GamificationService {
  @override
  int getTotalXp() => 150;
  @override
  UserLevel getCurrentLevel() => UserLevel.private;
  @override
  Future<bool> awardXp(int xp) async => false;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeStreakService implements StreakService {
  int checkStreakCalls = 0;
  @override
  Future<void> checkStreak() async { checkStreakCalls++; }
  @override
  int getCurrentStreak() => 3;
  @override
  int getBestStreak() => 5;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeLearningRepository implements LearningRepository {
  int syncCalls = 0;
  @override
  Future<Either<Failure, Unit>> syncWithServer() async {
    syncCalls++;
    return const Right(unit);
  }
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeGetCoursesByTrackUseCase getCourses;
  late FakeGetNextLessonUseCase getNextLesson;
  late FakeGetTrackUseCase getTrack;
  late FakeDownloadCourseOfflineUseCase downloadCourse;
  late FakeGamificationService gamification;
  late FakeStreakService streak;
  late FakeLearningRepository learningRepo;

  setUp(() {
    getCourses = FakeGetCoursesByTrackUseCase();
    getNextLesson = FakeGetNextLessonUseCase();
    getTrack = FakeGetTrackUseCase();
    downloadCourse = FakeDownloadCourseOfflineUseCase();
    gamification = FakeGamificationService();
    streak = FakeStreakService();
    learningRepo = FakeLearningRepository();
  });

  HomeBloc buildBloc() => HomeBloc(
        getCourses,
        getNextLesson,
        getTrack,
        downloadCourse,
        gamification,
        streak,
        learningRepo,
      );

  group('HomeBloc', () {
    test('initial state is correct', () {
      expect(buildBloc().state, const HomeState());
    });

    blocTest<HomeBloc, HomeState>(
      'HomeStarted triggers sync and loads initial data',
      build: buildBloc,
      act: (bloc) => bloc.add(const HomeStarted()),
      verify: (_) {
        expect(learningRepo.syncCalls, 1);
        expect(streak.checkStreakCalls, 1);
      },
      expect: () => [
        const HomeState(status: HomeStatus.loading),
        // Intermediate state with stats but still loading status (emitted after stats update)
        isA<HomeState>().having((s) => s.status, 'status', HomeStatus.loading)
                        .having((s) => s.totalXp, 'totalXp', 150)
                        .having((s) => s.streak, 'streak', 3),
        // Final loaded state (emitted from forEach)
        isA<HomeState>().having((s) => s.status, 'status', HomeStatus.loaded)
                        .having((s) => s.totalXp, 'totalXp', 150)
                        .having((s) => s.streak, 'streak', 3),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'HomeRefreshRequested updates state with latest stats',
      build: buildBloc,
      seed: () => const HomeState(status: HomeStatus.loaded),
      act: (bloc) => bloc.add(const HomeRefreshRequested()),
      expect: () => [
        isA<HomeState>().having((s) => s.totalXp, 'totalXp', 150),
      ],
    );
  });
}
