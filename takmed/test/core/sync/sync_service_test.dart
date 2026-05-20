import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:takmed/core/database/app_database.dart';
import 'package:takmed/core/sync/sync_service.dart';
import 'package:takmed/features/learning/domain/repositories/learning_repository.dart';

import 'sync_service_test.mocks.dart';

@GenerateMocks([SupabaseClient, GoTrueClient, LearningRepository])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  MockSupabaseClient buildClient({required String? userId}) {
    final client = MockSupabaseClient();
    final auth = MockGoTrueClient();
    when(client.auth).thenReturn(auth);
    when(auth.currentUser)
        .thenReturn(userId != null ? _fakeUser(userId) : null);
    return client;
  }

  SyncService buildService(SupabaseClient client) =>
      SyncService(db, MockLearningRepository(), client);

  // ─── syncDirtyRecords ───────────────────────────────────────────────────────

  group('syncDirtyRecords', () {
    test('повертає одразу якщо userId = null (не змінює dirty-записи)', () async {
      final client = buildClient(userId: null);

      await db.progressDao.saveProgress(UserProgressCompanion.insert(
        userId: const Value('user-1'),
        lessonRemoteId: 'lesson-a',
        score: 90,
        attempts: 1,
        completedAt: DateTime.now(),
        weakTopics: '[]',
      ));

      await buildService(client).syncDirtyRecords();

      // Запис залишається dirty — sync не відбувся
      expect(await db.progressDao.getDirtyProgress('user-1'), hasLength(1));
    });

    test('позначає progress як synced після успішного upsert', () async {
      const uid = 'user-sync';
      final client = buildClient(userId: uid);
      when(client.from(any)).thenAnswer((_) => _SuccessQueryBuilder());

      await db.progressDao.saveProgress(UserProgressCompanion.insert(
        userId: const Value(uid),
        lessonRemoteId: 'lesson-1',
        score: 80,
        attempts: 2,
        completedAt: DateTime(2026, 1, 1),
        weakTopics: '["СЛР"]',
      ));
      await db.progressDao.saveProgress(UserProgressCompanion.insert(
        userId: const Value(uid),
        lessonRemoteId: 'lesson-2',
        score: 100,
        attempts: 1,
        completedAt: DateTime(2026, 1, 2),
        weakTopics: '[]',
      ));

      await buildService(client).syncDirtyRecords();

      expect(await db.progressDao.getDirtyProgress(uid), isEmpty);
    });

    test('залишає record dirty якщо upsert кидає виняток', () async {
      const uid = 'user-fail';
      final client = buildClient(userId: uid);
      when(client.from(any)).thenAnswer((_) => _ThrowingQueryBuilder());

      await db.progressDao.saveProgress(UserProgressCompanion.insert(
        userId: const Value(uid),
        lessonRemoteId: 'lesson-fail',
        score: 50,
        attempts: 1,
        completedAt: DateTime.now(),
        weakTopics: '[]',
      ));

      await buildService(client).syncDirtyRecords();

      // Record залишається dirty — помилка була перехоплена, повторимо пізніше
      expect(await db.progressDao.getDirtyProgress(uid), hasLength(1));
    });

    test('коли немає dirty-записів — завершується без викидання', () async {
      const uid = 'user-clean';
      final client = buildClient(userId: uid);
      when(client.from(any)).thenAnswer((_) => _SuccessQueryBuilder());

      // Жодних записів — нічого не відправляємо
      await expectLater(buildService(client).syncDirtyRecords(), completes);
    });
  });

  // ─── ProgressDao dirty tracking ─────────────────────────────────────────────

  group('ProgressDao — брудне відстеження', () {
    test('saveProgress встановлює isDirty=true', () async {
      await db.progressDao.saveProgress(UserProgressCompanion.insert(
        userId: const Value('u1'),
        lessonRemoteId: 'lx',
        score: 70,
        attempts: 1,
        completedAt: DateTime.now(),
        weakTopics: '[]',
      ));

      final dirty = await db.progressDao.getDirtyProgress('u1');
      expect(dirty, hasLength(1));
      expect(dirty.first.isDirty, isTrue);
    });

    test('markProgressSynced встановлює isDirty=false', () async {
      await db.progressDao.saveProgress(UserProgressCompanion.insert(
        userId: const Value('u1'),
        lessonRemoteId: 'lx',
        score: 70,
        attempts: 1,
        completedAt: DateTime.now(),
        weakTopics: '[]',
      ));

      await db.progressDao.markProgressSynced('u1', 'lx',
          syncedAt: DateTime.now());

      expect(await db.progressDao.getDirtyProgress('u1'), isEmpty);
    });

    test('upsertSyncedProgress зберігає isDirty=false', () async {
      await db.progressDao.upsertSyncedProgress(UserProgressCompanion.insert(
        userId: const Value('u1'),
        lessonRemoteId: 'remote-l',
        score: 90,
        attempts: 1,
        completedAt: DateTime.now(),
        weakTopics: '[]',
      ));

      expect(await db.progressDao.getDirtyProgress('u1'), isEmpty);
    });

    test('getDirtyProgress не повертає записи інших користувачів', () async {
      await db.progressDao.saveProgress(UserProgressCompanion.insert(
        userId: const Value('user-A'),
        lessonRemoteId: 'la',
        score: 80,
        attempts: 1,
        completedAt: DateTime.now(),
        weakTopics: '[]',
      ));

      expect(await db.progressDao.getDirtyProgress('user-B'), isEmpty);
    });
  });

  // ─── QuizAttemptDao dirty tracking ─────────────────────────────────────────

  group('QuizAttemptDao — брудне відстеження', () {
    test('saveAttempt встановлює isDirty=true', () async {
      await db.quizAttemptDao.saveAttempt(QuizAttemptsCompanion(
        userId: const Value('u2'),
        lessonRemoteId: const Value('lq'),
        totalQuestions: const Value(5),
        correctAnswers: const Value(4),
        scorePercent: const Value(80),
        earnedXp: const Value(80),
        weakTopics: const Value('[]'),
        attemptedAt: Value(DateTime.now()),
      ));

      final dirty = await db.quizAttemptDao.getDirty('u2');
      expect(dirty, hasLength(1));
      expect(dirty.first.isDirty, isTrue);
    });

    test('markSynced встановлює isDirty=false', () async {
      final id = await db.quizAttemptDao.saveAttempt(QuizAttemptsCompanion(
        userId: const Value('u2'),
        lessonRemoteId: const Value('lq'),
        totalQuestions: const Value(5),
        correctAnswers: const Value(4),
        scorePercent: const Value(80),
        earnedXp: const Value(80),
        weakTopics: const Value('[]'),
        attemptedAt: Value(DateTime.now()),
      ));

      await db.quizAttemptDao.markSynced(id, at: DateTime.now());

      expect(await db.quizAttemptDao.getDirty('u2'), isEmpty);
    });
  });
}

// ─── Helpers ────────────────────────────────────────────────────────────────

User _fakeUser(String id) => User(
      id: id,
      appMetadata: const {},
      userMetadata: const {},
      aud: 'authenticated',
      createdAt: '2026-01-01T00:00:00.000Z',
    );

// ─── Fake Supabase builders ─────────────────────────────────────────────────

/// Fake SupabaseQueryBuilder — успішно завершує будь-який запит.
class _SuccessQueryBuilder extends Fake implements SupabaseQueryBuilder {
  @override
  dynamic noSuchMethod(Invocation invocation) => _SuccessFilterBuilder();
}

/// Fake PostgrestFilterBuilder<dynamic> — завершується без помилок.
class _SuccessFilterBuilder extends Fake
    implements PostgrestFilterBuilder<dynamic> {
  @override
  Future<U> then<U>(
    FutureOr<U> Function(dynamic) onValue, {
    Function? onError,
  }) =>
      Future<dynamic>.value(null).then(onValue, onError: onError);

  @override
  dynamic noSuchMethod(Invocation invocation) => this;
}

/// Fake SupabaseQueryBuilder — кидає виняток при будь-якому запиті.
class _ThrowingQueryBuilder extends Fake implements SupabaseQueryBuilder {
  @override
  dynamic noSuchMethod(Invocation invocation) => _ThrowingFilterBuilder();
}

/// Fake PostgrestFilterBuilder<dynamic> — завершується з помилкою.
class _ThrowingFilterBuilder extends Fake
    implements PostgrestFilterBuilder<dynamic> {
  @override
  Future<U> then<U>(
    FutureOr<U> Function(dynamic) onValue, {
    Function? onError,
  }) =>
      Future<dynamic>.error(Exception('Network error'))
          .then(onValue, onError: onError);

  @override
  dynamic noSuchMethod(Invocation invocation) => this;
}
