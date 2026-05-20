import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/quiz_attempts_table.dart';

part 'quiz_attempt_dao.g.dart';

@DriftAccessor(tables: [QuizAttempts])
class QuizAttemptDao extends DatabaseAccessor<AppDatabase>
    with _$QuizAttemptDaoMixin {
  QuizAttemptDao(super.db);

  /// Зберігає нову спробу.
  Future<int> saveAttempt(QuizAttemptsCompanion attempt) =>
      into(quizAttempts).insert(attempt);

  /// Отримує всі спроби користувача, відсортовані від нових до старих.
  Future<List<QuizAttemptDB>> getAttemptsByUser(String userId) =>
      (select(quizAttempts)
            ..where((a) => a.userId.equals(userId))
            ..orderBy([(a) => OrderingTerm.desc(a.attemptedAt)]))
          .get();

  /// Отримує спроби для конкретного уроку.
  Future<List<QuizAttemptDB>> getAttemptsByLesson(
    String userId,
    String lessonRemoteId,
  ) =>
      (select(quizAttempts)
            ..where(
              (a) =>
                  a.userId.equals(userId) &
                  a.lessonRemoteId.equals(lessonRemoteId),
            )
            ..orderBy([(a) => OrderingTerm.desc(a.attemptedAt)]))
          .get();

  /// Реактивний стрім всіх спроб користувача.
  Stream<List<QuizAttemptDB>> watchAttemptsByUser(String userId) =>
      (select(quizAttempts)
            ..where((a) => a.userId.equals(userId))
            ..orderBy([(a) => OrderingTerm.desc(a.attemptedAt)]))
          .watch();

  /// Кількість спроб користувача.
  Future<int> countAttemptsByUser(String userId) async {
    final count = countAll();
    final query = selectOnly(quizAttempts)
      ..addColumns([count])
      ..where(quizAttempts.userId.equals(userId));
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Найкращий результат по уроку.
  Future<QuizAttemptDB?> getBestAttemptForLesson(
    String userId,
    String lessonRemoteId,
  ) async {
    final attempts = await getAttemptsByLesson(userId, lessonRemoteId);
    if (attempts.isEmpty) return null;
    return attempts.reduce(
      (best, a) => a.scorePercent > best.scorePercent ? a : best,
    );
  }

  /// Видаляє всі спроби користувача (для logout/cleanup).
  Future<int> deleteAttemptsByUser(String userId) =>
      (delete(quizAttempts)..where((a) => a.userId.equals(userId))).go();

  /// Отримує спроби, які потребують синхронізації.
  Future<List<QuizAttemptDB>> getDirty(String userId) =>
      (select(quizAttempts)
            ..where((a) => a.userId.equals(userId) & a.isDirty.equals(true)))
          .get();

  /// Позначає спробу як синхронізовану.
  Future<void> markSynced(int id, {DateTime? at}) =>
      (update(quizAttempts)..where((a) => a.id.equals(id))).write(
        QuizAttemptsCompanion(
          isDirty: const Value(false),
          syncedAt: Value(at ?? DateTime.now()),
        ),
      );

  /// Повертає спроби за останні 30 днів, відсортовані від старих до нових.
  Future<List<QuizAttemptDB>> getAttemptsLast30Days(String userId) {
    final since = DateTime.now().subtract(const Duration(days: 30));
    return (select(quizAttempts)
          ..where(
            (a) =>
                a.userId.equals(userId) &
                a.attemptedAt.isBiggerThanValue(since),
          )
          ..orderBy([(a) => OrderingTerm.asc(a.attemptedAt)]))
        .get();
  }
}
