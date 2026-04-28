import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/user_progress_table.dart';

part 'progress_dao.g.dart';

/// DAO для роботи з прогресом користувача.
@DriftAccessor(tables: [UserProgress])
class ProgressDao extends DatabaseAccessor<AppDatabase>
    with _$ProgressDaoMixin {
  /// Створює DAO прогресу.
  ProgressDao(super.db);

  /// Зберігає прогрес уроку.
  Future<int> saveProgress(UserProgressCompanion progress) async {
    final now = DateTime.now();
    final localUserId = progress.userId.present ? progress.userId.value : '';
    final lessonRemoteId = progress.lessonRemoteId.value;

    final localProgress = progress.copyWith(
      updatedAt: Value(now),
      isDirty: const Value(true),
      syncedAt: const Value(null),
    );

    final insertedId = await into(userProgress).insert(
      localProgress,
      onConflict: DoUpdate(
        (_) => localProgress,
        target: [userProgress.userId, userProgress.lessonRemoteId],
      ),
    );

    await (update(userProgress)..where(
      (p) =>
          p.userId.equals(localUserId) &
          p.lessonRemoteId.equals(lessonRemoteId),
    )).write(
      UserProgressCompanion(
        updatedAt: Value(now),
        isDirty: const Value(true),
        syncedAt: const Value(null),
      ),
    );

    return insertedId;
  }

  /// Upsert запису, який вже синхронізовано з сервером.
  Future<int> upsertSyncedProgress(UserProgressCompanion progress) {
    final now = DateTime.now();
    final syncedProgress = progress.copyWith(
      updatedAt: progress.updatedAt.present ? progress.updatedAt : Value(now),
      isDirty: const Value(false),
      syncedAt: Value(now),
    );

    return into(userProgress).insert(
      syncedProgress,
      onConflict: DoUpdate(
        (_) => syncedProgress,
        target: [userProgress.userId, userProgress.lessonRemoteId],
      ),
    );
  }

  /// Отримує прогрес за ID уроку.
  Future<UserProgressDB?> getProgressByLesson(String lessonRemoteId) {
    return (select(
      userProgress,
    )..where((p) => p.lessonRemoteId.equals(lessonRemoteId))).getSingleOrNull();
  }

  /// Отримує прогрес уроку конкретного користувача.
  Future<UserProgressDB?> getProgressByUserAndLesson(
    String userId,
    String lessonRemoteId,
  ) {
    return (select(userProgress)..where(
      (p) => p.userId.equals(userId) & p.lessonRemoteId.equals(lessonRemoteId),
    )).getSingleOrNull();
  }

  /// Отримує локальні зміни, які треба відправити на сервер.
  Future<List<UserProgressDB>> getDirtyProgress(String userId) {
    return (select(userProgress)
          ..where((p) => p.userId.equals(userId) & p.isDirty.equals(true))
          ..orderBy([(p) => OrderingTerm.asc(p.updatedAt)]))
        .get();
  }

  /// Позначає запис прогресу як синхронізований.
  Future<int> markProgressSynced(
    String userId,
    String lessonRemoteId, {
    DateTime? syncedAt,
  }) {
    return (update(userProgress)..where(
      (p) => p.userId.equals(userId) & p.lessonRemoteId.equals(lessonRemoteId),
    )).write(
      UserProgressCompanion(
        isDirty: const Value(false),
        syncedAt: Value(syncedAt ?? DateTime.now()),
      ),
    );
  }

  /// Отримує весь прогрес конкретного користувача (для sync).
  Future<List<UserProgressDB>> getAllProgressByUser(String userId) {
    return (select(userProgress)..where((p) => p.userId.equals(userId))).get();
  }

  /// Отримує весь прогрес (для sync).
  Future<List<UserProgressDB>> getAllProgress() {
    return select(userProgress).get();
  }
}
