import 'package:drift/drift.dart';

/// Таблиця курсів.
@DataClassName('CourseDB')
class Courses extends Table {
  /// Локальний автоінкрементний ID.
  IntColumn get id => integer().autoIncrement()();

  /// Віддалений ID для синхронізації.
  TextColumn get remoteId => text()();

  /// Назва курсу.
  TextColumn get title => text()();

  /// Опис курсу.
  TextColumn get description => text()();

  /// Трек: 'military' або 'civilian'.
  TextColumn get track => text()();

  /// Порядковий номер для сортування.
  IntColumn get orderIndex => integer()();

  /// Чи завантажений для офлайн.
  BoolColumn get isDownloaded => boolean().withDefault(const Constant(false))();

  /// Загальна кількість уроків.
  IntColumn get totalLessons => integer().withDefault(const Constant(0))();

  /// Кількість завершених уроків.
  IntColumn get completedLessons => integer().withDefault(const Constant(0))();

  /// Час останнього оновлення.
  DateTimeColumn get updatedAt => dateTime()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {remoteId},
  ];
}
