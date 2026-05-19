import 'package:drift/drift.dart';

/// Таблиця історії спроб проходження тестів.
@DataClassName('QuizAttemptDB')
class QuizAttempts extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// ID користувача.
  TextColumn get userId => text()();

  /// Remote ID уроку-тесту (nullable — для standalone quiz).
  TextColumn get lessonRemoteId => text().nullable()();

  /// Кількість питань.
  IntColumn get totalQuestions => integer()();

  /// Кількість правильних відповідей.
  IntColumn get correctAnswers => integer()();

  /// Відсоток правильних (0-100).
  IntColumn get scorePercent => integer()();

  /// Зароблені XP.
  IntColumn get earnedXp => integer()();

  /// JSON-масив слабких тем.
  TextColumn get weakTopics => text().withDefault(const Constant('[]'))();

  /// Час проходження.
  DateTimeColumn get attemptedAt => dateTime()();
}
