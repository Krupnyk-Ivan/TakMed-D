import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workmanager/workmanager.dart';
import '../database/app_database.dart';
import '../database/seed_data.dart';
import '../../features/learning/domain/repositories/learning_repository.dart';

const _kSyncTaskName = 'takmed.sync_dirty';
const _kSyncTaskId = 'sync_dirty_records';

/// Сервіс синхронізації локальних змін із Supabase.
class SyncService {
  const SyncService(this._db, this._learningRepository, this._client);

  final AppDatabase _db;
  final LearningRepository _learningRepository;
  final SupabaseClient _client;

  // ─── Публічний API ──────────────────────────────────────────────────────────

  /// Повна синхронізація курсів / уроків із Supabase.
  Future<void> sync() async {
    await _learningRepository.syncWithServer();
  }

  /// Заповнює локальну БД seed-даними при першому запуску.
  Future<void> seedIfEmpty() async {
    await SeedData.seedIfEmpty(_db);
  }

  /// Відправляє всі dirty-записи на сервер.
  /// Безпечно викликати при відновленні мережі або вручну.
  Future<void> syncDirtyRecords() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null || userId.isEmpty) return;

    await _syncDirtyProgress(userId);
    await _syncDirtyMarchHistory(userId);
  }

  // ─── Фонова синхронізація (Workmanager) ─────────────────────────────────────

  /// Ініціалізує Workmanager і реєструє щогодинну фонову задачу.
  /// Викликати один раз з [main()].
  static Future<void> registerBackgroundSync() async {
    // Workmanager підтримує тільки Android та iOS
    if (kIsWeb) { return; }
    if (defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS) { return; }

    await Workmanager().initialize(
      backgroundSyncCallbackDispatcher,
      isInDebugMode: false,
    );
    await Workmanager().registerPeriodicTask(
      _kSyncTaskId,
      _kSyncTaskName,
      frequency: const Duration(hours: 1),
      existingWorkPolicy: ExistingWorkPolicy.keep,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  // ─── Внутрішня логіка ───────────────────────────────────────────────────────

  Future<void> _syncDirtyProgress(String userId) async {
    final dirty = await _db.progressDao.getDirtyProgress(userId);
    for (final record in dirty) {
      try {
        await _client.from('user_progress').upsert({
          'user_id': record.userId,
          'lesson_remote_id': record.lessonRemoteId,
          'score': record.score,
          'attempts': record.attempts,
          'completed_at': record.completedAt.toIso8601String(),
          'weak_topics': record.weakTopics,
        }, onConflict: 'user_id,lesson_remote_id');
        await _db.progressDao.markProgressSynced(
          userId,
          record.lessonRemoteId,
          syncedAt: DateTime.now().toUtc(),
        );
      } catch (_) {
        // isDirty залишається true — повторимо наступного разу
      }
    }
  }

  Future<void> _syncDirtyMarchHistory(String userId) async {
    final dirty = await _db.marchHistoryDao.getDirty(userId);
    for (final record in dirty) {
      try {
        await _client.from('march_history').upsert({
          'user_id': record.userId,
          'started_at': record.startedAt.toIso8601String(),
          'total_duration_seconds': record.totalDurationSeconds,
          'success_rate': record.successRate,
          'weak_topics': record.weakTopics,
          'items_json': record.itemsJson,
        });
        await _db.marchHistoryDao.markSynced(
          record.id,
          at: DateTime.now().toUtc(),
        );
      } catch (_) {}
    }
  }
}

/// Точка входу для фонового ізоляту Workmanager.
/// Має бути top-level функцією з анотацією @pragma.
@pragma('vm:entry-point')
void backgroundSyncCallbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName != _kSyncTaskName) return true;

    try {
      // У фоновому ізоляті потрібно окремо ініціалізувати залежності.
      // Суpabase.initialize — ідемпотентна, безпечно викликати повторно.
      final supabaseInstance = Supabase.instance;
      final client = supabaseInstance.client;
      final userId = client.auth.currentUser?.id;
      if (userId == null || userId.isEmpty) return true;

      final db = AppDatabase();

      // Синхронізуємо UserProgress
      final dirtyProgress = await db.progressDao.getDirtyProgress(userId);
      for (final record in dirtyProgress) {
        try {
          await client.from('user_progress').upsert({
            'user_id': record.userId,
            'lesson_remote_id': record.lessonRemoteId,
            'score': record.score,
            'attempts': record.attempts,
            'completed_at': record.completedAt.toIso8601String(),
            'weak_topics': record.weakTopics,
          }, onConflict: 'user_id,lesson_remote_id');
          await db.progressDao.markProgressSynced(
            userId,
            record.lessonRemoteId,
            syncedAt: DateTime.now().toUtc(),
          );
        } catch (_) {}
      }

      // Синхронізуємо QuizAttempts
      final dirtyQuiz = await db.quizAttemptDao.getDirty(userId);
      for (final record in dirtyQuiz) {
        try {
          await client.from('quiz_attempts').insert({
            'user_id': record.userId,
            'lesson_remote_id': record.lessonRemoteId,
            'total_questions': record.totalQuestions,
            'correct_answers': record.correctAnswers,
            'score_percent': record.scorePercent,
            'earned_xp': record.earnedXp,
            'weak_topics': record.weakTopics,
            'attempted_at': record.attemptedAt.toIso8601String(),
          });
          await db.quizAttemptDao.markSynced(
            record.id,
            at: DateTime.now().toUtc(),
          );
        } catch (_) {}
      }

      // Синхронізуємо MarchHistory
      final dirtyMarch = await db.marchHistoryDao.getDirty(userId);
      for (final record in dirtyMarch) {
        try {
          await client.from('march_history').upsert({
            'user_id': record.userId,
            'started_at': record.startedAt.toIso8601String(),
            'total_duration_seconds': record.totalDurationSeconds,
            'success_rate': record.successRate,
            'weak_topics': record.weakTopics,
            'items_json': record.itemsJson,
          });
          await db.marchHistoryDao.markSynced(
            record.id,
            at: DateTime.now().toUtc(),
          );
        } catch (_) {}
      }

      await db.close();
    } catch (_) {}

    return true;
  });
}
