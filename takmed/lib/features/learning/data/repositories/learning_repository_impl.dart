import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart' show Value;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../../core/database/app_database.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/learning_remote_data_source.dart';
import '../models/learning_sync_models.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../domain/repositories/learning_repository.dart';

/// Реалізація репозиторія навчання (offline-first).
class LearningRepositoryImpl implements LearningRepository {
  /// Створює репозиторій.
  LearningRepositoryImpl(
    this._db,
    this._remoteDataSource,
    this._networkInfo,
    this._prefs,
    this._supabaseClient, {
    String? Function()? currentUserIdResolver,
  }) : _currentUserIdResolver = currentUserIdResolver;

  final AppDatabase _db;
  final LearningRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;
  final SharedPreferences _prefs;
  final supabase.SupabaseClient _supabaseClient;
  final String? Function()? _currentUserIdResolver;

  static const String _lastSyncKeyPrefix = 'learning_last_sync_';
  static const String _legacyLocalUserId = '';

  @override
  Stream<List<CourseEntity>> watchCoursesByTrack(String track) {
    return _db.courseDao
        .watchCoursesByTrack(track)
        .map((rows) => rows.map(_courseFromDB).toList());
  }

  @override
  Stream<List<LessonEntity>> watchLessonsByCourse(int courseId) {
    return _db.lessonDao
        .watchLessonsByCourse(courseId)
        .map((rows) => rows.map(_lessonFromDB).toList());
  }

  @override
  Future<Either<Failure, Unit>> completeLesson(int lessonId, int score) async {
    try {
      await _db.lessonDao.markLessonCompleted(lessonId);

      // Оновити лічильник курсу
      final lesson = await _db.lessonDao.getLessonById(lessonId);
      if (lesson != null) {
        final userId = _currentUserId() ?? _legacyLocalUserId;
        final now = DateTime.now().toUtc();

        final completed = await _db.lessonDao.countCompletedLessons(
          lesson.courseId,
        );
        await _db.courseDao.updateProgress(lesson.courseId, completed);

        // Зберегти прогрес
        await _db.progressDao.saveProgress(
          UserProgressCompanion.insert(
            userId: Value(userId),
            lessonRemoteId: lesson.remoteId,
            score: score,
            attempts: 1,
            completedAt: now,
            updatedAt: Value(now),
            isDirty: const Value(true),
            syncedAt: const Value(null),
            weakTopics: '[]',
          ),
        );
      }

      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('Помилка збереження прогресу: $e'));
    }
  }

  @override
  Future<Either<Failure, LessonEntity?>> getNextLesson() async {
    try {
      final lesson = await _db.lessonDao.getGlobalNextLesson();
      return Right(lesson != null ? _lessonFromDB(lesson) : null);
    } catch (e) {
      return Left(CacheFailure('Помилка отримання уроку: $e'));
    }
  }

  @override
  Future<Either<Failure, LessonEntity?>> getNextLessonInCourse(
    int courseId,
  ) async {
    try {
      final lesson = await _db.lessonDao.getNextUncompletedLesson(courseId);
      return Right(lesson != null ? _lessonFromDB(lesson) : null);
    } catch (e) {
      return Left(CacheFailure('Помилка: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> downloadCourseOffline(int courseId) async {
    try {
      // Зараз всі дані вже у Drift — просто позначаємо як downloaded
      await _db.courseDao.markAsDownloaded(courseId);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('Помилка завантаження: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> syncWithServer() async {
    try {
      final connected = await _networkInfo.isConnected;
      if (!connected) {
        return const Right(unit);
      }

      final userId = _currentUserId();
      if (userId == null || userId.isEmpty) {
        return const Right(unit);
      }

      final lastSync = _readLastSync(userId);

      await _pullCoursesAndLessons(lastSync);
      await _adoptLegacyProgress(userId);
      await _pushDirtyProgress(userId);
      await _pushDirtyQuizAttempts(userId);
      await _pullRemoteProgress(userId, lastSync);
      await _pullQuizAttempts(userId, lastSync);
      await _recalculateCompletedLessons();

      await _saveLastSync(userId, DateTime.now().toUtc());

      return const Right(unit);
    } on supabase.AuthException catch (e) {
      return Left(
        AuthFailure('Помилка авторизації під час sync: ${e.message}'),
      );
    } on supabase.PostgrestException catch (e) {
      return Left(ServerFailure('Помилка сервера під час sync: ${e.message}'));
    } on FormatException catch (e) {
      return Left(ParseFailure('Помилка обробки sync-даних: $e'));
    } on CacheFailure {
      rethrow;
    } catch (e) {
      return Left(UnknownFailure('Невідома помилка синхронізації: $e'));
    }
  }

  @override
  Future<Either<Failure, CourseEntity?>> getCourseById(int id) async {
    try {
      final course = await _db.courseDao.getCourseById(id);
      return Right(course != null ? _courseFromDB(course) : null);
    } catch (e) {
      return Left(CacheFailure('Помилка: $e'));
    }
  }

  @override
  Future<void> seedIfEmpty() async {
    await _db.seedIfEmpty();
  }

  Future<void> _pullCoursesAndLessons(DateTime? lastSync) async {
    final remoteCourses = await _remoteDataSource.fetchCoursesUpdatedAfter(
      lastSync,
    );

    if (remoteCourses.isNotEmpty) {
      await _db.transaction(() async {
        for (final remoteCourse in remoteCourses) {
          final existing = await _db.courseDao.getCourseByRemoteId(
            remoteCourse.remoteId,
          );

          await _db.courseDao.upsertCourse(
            CoursesCompanion.insert(
              remoteId: remoteCourse.remoteId,
              title: remoteCourse.title,
              description: remoteCourse.description,
              track: remoteCourse.track,
              orderIndex: remoteCourse.orderIndex,
              isDownloaded: Value(existing?.isDownloaded ?? false),
              totalLessons: Value(remoteCourse.totalLessons),
              completedLessons: Value(existing?.completedLessons ?? 0),
              updatedAt: remoteCourse.updatedAt,
            ),
          );
        }
      });
    }

    final remoteLessons = await _remoteDataSource.fetchLessonsUpdatedAfter(
      lastSync,
    );

    if (remoteLessons.isNotEmpty) {
      final courseIdCache = <String, int>{};

      await _db.transaction(() async {
        for (final remoteLesson in remoteLessons) {
          final localCourseId = await _resolveLocalCourseId(
            remoteLesson.courseRemoteId,
            courseIdCache,
          );
          if (localCourseId == null) {
            continue;
          }

          final existingLesson = await _db.lessonDao.getLessonByRemoteId(
            remoteLesson.remoteId,
          );

          await _db.lessonDao.upsertLesson(
            LessonsCompanion.insert(
              remoteId: remoteLesson.remoteId,
              courseId: localCourseId,
              type: remoteLesson.type,
              title: remoteLesson.title,
              contentJson: remoteLesson.contentJson,
              durationSeconds: remoteLesson.durationSeconds,
              orderIndex: remoteLesson.orderIndex,
              isCompleted: Value(existingLesson?.isCompleted ?? false),
              xpReward: Value(remoteLesson.xpReward),
              updatedAt: Value(remoteLesson.updatedAt),
            ),
          );
        }
      });
    }
  }

  Future<int?> _resolveLocalCourseId(
    String courseRemoteId,
    Map<String, int> cache,
  ) async {
    final cached = cache[courseRemoteId];
    if (cached != null) {
      return cached;
    }

    final course = await _db.courseDao.getCourseByRemoteId(courseRemoteId);
    if (course == null) {
      return null;
    }

    cache[courseRemoteId] = course.id;
    return course.id;
  }

  Future<void> _adoptLegacyProgress(String userId) async {
    final legacyRows = await _db.progressDao.getDirtyProgress(
      _legacyLocalUserId,
    );
    if (legacyRows.isEmpty) {
      return;
    }

    await _db.transaction(() async {
      for (final row in legacyRows) {
        await _db.progressDao.saveProgress(
          UserProgressCompanion.insert(
            userId: Value(userId),
            lessonRemoteId: row.lessonRemoteId,
            score: row.score,
            attempts: row.attempts,
            completedAt: row.completedAt,
            updatedAt: Value(row.updatedAt),
            isDirty: Value(row.isDirty),
            syncedAt: Value(row.syncedAt),
            weakTopics: row.weakTopics,
          ),
        );

        await _db.progressDao.markProgressSynced(
          _legacyLocalUserId,
          row.lessonRemoteId,
          syncedAt: DateTime.now().toUtc(),
        );
      }
    });
  }

  Future<void> _pushDirtyProgress(String userId) async {
    final dirtyRows = await _db.progressDao.getDirtyProgress(userId);
    if (dirtyRows.isEmpty) {
      return;
    }

    final remoteRows =
        dirtyRows
            .map(
              (row) => RemoteUserProgressDto(
                userId: userId,
                lessonRemoteId: row.lessonRemoteId,
                score: row.score,
                attempts: row.attempts,
                completedAt: row.completedAt.toUtc(),
                weakTopics: _decodeWeakTopics(row.weakTopics),
                updatedAt: row.updatedAt.toUtc(),
              ),
            )
            .toList();

    await _remoteDataSource.upsertUserProgress(remoteRows);

    final syncedAt = DateTime.now().toUtc();
    await _db.transaction(() async {
      for (final row in dirtyRows) {
        await _db.progressDao.markProgressSynced(
          userId,
          row.lessonRemoteId,
          syncedAt: syncedAt,
        );
      }
    });
  }

  Future<void> _pushDirtyQuizAttempts(String userId) async {
    final dirtyRows = await _db.quizAttemptDao.getDirty(userId);
    if (dirtyRows.isEmpty) {
      return;
    }

    final payload = dirtyRows.map((row) => {
      'user_id': userId,
      'lesson_remote_id': row.lessonRemoteId,
      'total_questions': row.totalQuestions,
      'correct_answers': row.correctAnswers,
      'score_percent': row.scorePercent,
      'earned_xp': row.earnedXp,
      'weak_topics': _decodeWeakTopics(row.weakTopics),
      'attempted_at': row.attemptedAt.toUtc().toIso8601String(),
    }).toList();

    // Використовуємо прямий виклик клієнта для спрощення, 
    // або можна додати метод у remoteDataSource.
    await _supabaseClient.from('quiz_attempts').upsert(payload);

    final syncedAt = DateTime.now().toUtc();
    await _db.transaction(() async {
      for (final row in dirtyRows) {
        await _db.quizAttemptDao.markSynced(row.id, at: syncedAt);
      }
    });
  }

  Future<void> _pullQuizAttempts(String userId, DateTime? lastSync) async {
    try {
      var baseQuery = _supabaseClient
          .from('quiz_attempts')
          .select()
          .eq('user_id', userId);

      if (lastSync != null) {
        baseQuery = baseQuery.gt(
          'attempted_at',
          lastSync.toUtc().toIso8601String(),
        );
      }

      final rows = await baseQuery.order('attempted_at', ascending: true)
          as List<dynamic>;

      for (final raw in rows) {
        final map = Map<String, dynamic>.from(raw as Map);
        final attemptedAt = DateTime.tryParse(
              map['attempted_at']?.toString() ?? '',
            )?.toLocal() ??
            DateTime.now();

        try {
          await _db.quizAttemptDao.saveAttempt(
            QuizAttemptsCompanion.insert(
              userId: userId,
              lessonRemoteId: Value(map['lesson_remote_id'] as String?),
              totalQuestions: (map['total_questions'] as num?)?.toInt() ?? 0,
              correctAnswers: (map['correct_answers'] as num?)?.toInt() ?? 0,
              scorePercent: (map['score_percent'] as num?)?.toInt() ?? 0,
              earnedXp: (map['earned_xp'] as num?)?.toInt() ?? 0,
              weakTopics: Value(map['weak_topics']?.toString() ?? '[]'),
              attemptedAt: attemptedAt,
              isDirty: const Value(false),
              syncedAt: Value(DateTime.now().toUtc()),
            ),
          );
        } catch (_) {}
      }
    } catch (_) {}
  }

  Future<void> _pullRemoteProgress(String userId, DateTime? lastSync) async {
    final remoteRows = await _remoteDataSource.fetchUserProgressUpdatedAfter(
      userId,
      lastSync,
    );

    if (remoteRows.isEmpty) {
      return;
    }

    await _db.transaction(() async {
      for (final remote in remoteRows) {
        final local = await _db.progressDao.getProgressByUserAndLesson(
          userId,
          remote.lessonRemoteId,
        );

        if (!_shouldApplyRemoteProgress(local, remote)) {
          continue;
        }

        await _db.progressDao.upsertSyncedProgress(
          UserProgressCompanion.insert(
            userId: Value(userId),
            lessonRemoteId: remote.lessonRemoteId,
            score: remote.score,
            attempts: remote.attempts,
            completedAt: remote.completedAt.toUtc(),
            weakTopics: jsonEncode(remote.weakTopics),
            updatedAt: Value(remote.effectiveUpdatedAt.toUtc()),
            isDirty: const Value(false),
            syncedAt: Value(DateTime.now().toUtc()),
          ),
        );

        await _db.lessonDao.markLessonCompletedByRemoteId(
          remote.lessonRemoteId,
        );
      }
    });
  }

  bool _shouldApplyRemoteProgress(
    UserProgressDB? local,
    RemoteUserProgressDto remote,
  ) {
    if (local == null) {
      return true;
    }

    final localTimestamp = local.updatedAt.toUtc();
    final remoteTimestamp = remote.effectiveUpdatedAt.toUtc();

    if (remoteTimestamp.isAfter(localTimestamp)) {
      return true;
    }
    if (remoteTimestamp.isBefore(localTimestamp)) {
      return false;
    }

    // При однаковому timestamp не перезаписуємо локальні unsynced зміни.
    return !local.isDirty;
  }

  Future<void> _recalculateCompletedLessons() async {
    final courses = await _db.courseDao.getAllCourses();
    await _db.transaction(() async {
      for (final course in courses) {
        final completed = await _db.lessonDao.countCompletedLessons(course.id);
        await _db.courseDao.updateProgress(course.id, completed);
      }
    });
  }

  DateTime? _readLastSync(String userId) {
    final raw = _prefs.getString('$_lastSyncKeyPrefix$userId');
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }
    return DateTime.tryParse(raw)?.toUtc();
  }

  Future<void> _saveLastSync(String userId, DateTime timestamp) async {
    await _prefs.setString(
      '$_lastSyncKeyPrefix$userId',
      timestamp.toUtc().toIso8601String(),
    );
  }

  List<String> _decodeWeakTopics(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
      return const <String>[];
    } catch (_) {
      return const <String>[];
    }
  }

  String? _currentUserId() {
    final resolver = _currentUserIdResolver;
    if (resolver != null) {
      return resolver();
    }
    return _supabaseClient.auth.currentUser?.id;
  }

  // — Mappers —

  CourseEntity _courseFromDB(CourseDB row) {
    return CourseEntity(
      id: row.id,
      remoteId: row.remoteId,
      title: row.title,
      description: row.description,
      track: row.track,
      orderIndex: row.orderIndex,
      totalLessons: row.totalLessons,
      completedLessons: row.completedLessons,
      isDownloaded: row.isDownloaded,
      updatedAt: row.updatedAt,
    );
  }

  LessonEntity _lessonFromDB(LessonDB row) {
    return LessonEntity(
      id: row.id,
      remoteId: row.remoteId,
      courseId: row.courseId,
      type: row.type,
      title: row.title,
      contentJson: row.contentJson,
      durationSeconds: row.durationSeconds,
      orderIndex: row.orderIndex,
      isCompleted: row.isCompleted,
      xpReward: row.xpReward,
    );
  }
}
