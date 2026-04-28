import 'package:drift/drift.dart';

/// Таблиця прогресу користувача.
@DataClassName('UserProgressDB')
class UserProgress extends Table {
  /// Локальний автоінкрементний ID.
  IntColumn get id => integer().autoIncrement()();

  /// ID користувача (Supabase auth.users.id).
  TextColumn get userId => text().withDefault(const Constant(''))();

  /// Віддалений ID уроку.
  TextColumn get lessonRemoteId => text()();

  /// Оцінка (0-100).
  IntColumn get score => integer()();

  /// Кількість спроб.
  IntColumn get attempts => integer()();

  /// Час завершення.
  DateTimeColumn get completedAt => dateTime()();

  /// Час останнього оновлення запису прогресу.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  /// Чи має локальні зміни, які треба відправити на сервер.
  BoolColumn get isDirty => boolean().withDefault(const Constant(true))();

  /// Час останньої успішної синхронізації цього запису.
  DateTimeColumn get syncedAt => dateTime().nullable()();

  /// JSON масив слабких тем.
  TextColumn get weakTopics => text()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {userId, lessonRemoteId},
  ];
}
