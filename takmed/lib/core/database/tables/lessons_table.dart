import 'package:drift/drift.dart';
import 'courses_table.dart';

/// Таблиця уроків.
@DataClassName('LessonDB')
class Lessons extends Table {
  /// Локальний автоінкрементний ID.
  IntColumn get id => integer().autoIncrement()();

  /// Віддалений ID для синхронізації.
  TextColumn get remoteId => text()();

  /// ID курсу (зовнішній ключ).
  IntColumn get courseId => integer().references(Courses, #id)();

  /// Тип уроку: 'theory', 'video', 'quiz', 'checklist'.
  TextColumn get type => text()();

  /// Назва уроку.
  TextColumn get title => text()();

  /// Серіалізований JSON контент.
  TextColumn get contentJson => text()();

  /// Тривалість у секундах.
  IntColumn get durationSeconds => integer()();

  /// Порядковий номер для сортування.
  IntColumn get orderIndex => integer()();

  /// Чи завершений урок.
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  /// XP нагорода за завершення.
  IntColumn get xpReward => integer().withDefault(const Constant(10))();

  /// Час останнього оновлення.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {remoteId},
  ];
}
