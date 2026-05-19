import 'package:drift/drift.dart';

/// Локальна історія тренувальних MARCH-сесій.
@DataClassName('MarchHistoryDB')
class MarchHistory extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// ID користувача (порожній для гостя).
  TextColumn get userId => text().withDefault(const Constant(''))();

  /// Час старту сесії.
  DateTimeColumn get startedAt => dateTime()();

  /// Загальна тривалість у секундах.
  IntColumn get totalDurationSeconds => integer()();

  /// % правильних відповідей у мікро-квізах (0–100).
  IntColumn get successRate => integer()();

  /// JSON-масив кодів кроків зі слабкими результатами (наприклад ["M","R"]).
  TextColumn get weakTopics => text().withDefault(const Constant('[]'))();

  /// JSON з покроковою аналітикою (elapsedSeconds, quizAnsweredCorrectly).
  TextColumn get itemsJson => text().withDefault(const Constant('[]'))();

  /// Чи синхронізовано з сервером.
  BoolColumn get isDirty => boolean().withDefault(const Constant(true))();

  DateTimeColumn get syncedAt => dateTime().nullable()();
}
