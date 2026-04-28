import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/lessons_table.dart';

part 'lesson_dao.g.dart';

/// DAO для роботи з таблицею уроків.
@DriftAccessor(tables: [Lessons])
class LessonDao extends DatabaseAccessor<AppDatabase> with _$LessonDaoMixin {
  /// Створює DAO уроків.
  LessonDao(super.db);

  /// Отримує уроки курсу (реактивний стрім).
  Stream<List<LessonDB>> watchLessonsByCourse(int courseId) {
    return (select(lessons)
          ..where((l) => l.courseId.equals(courseId))
          ..orderBy([(l) => OrderingTerm.asc(l.orderIndex)]))
        .watch();
  }

  /// Отримує уроки курсу (одноразовий).
  Future<List<LessonDB>> getLessonsByCourse(int courseId) {
    return (select(lessons)
          ..where((l) => l.courseId.equals(courseId))
          ..orderBy([(l) => OrderingTerm.asc(l.orderIndex)]))
        .get();
  }

  /// Отримує урок за ID.
  Future<LessonDB?> getLessonById(int id) {
    return (select(lessons)..where((l) => l.id.equals(id))).getSingleOrNull();
  }

  /// Отримує урок за remote ID.
  Future<LessonDB?> getLessonByRemoteId(String remoteId) {
    return (select(lessons)
      ..where((l) => l.remoteId.equals(remoteId))).getSingleOrNull();
  }

  /// Позначає урок як завершений.
  Future<int> markLessonCompleted(int id) {
    return (update(lessons)..where(
      (l) => l.id.equals(id),
    )).write(const LessonsCompanion(isCompleted: Value(true)));
  }

  /// Позначає урок як завершений за remote ID.
  Future<int> markLessonCompletedByRemoteId(String remoteId) {
    return (update(lessons)..where(
      (l) => l.remoteId.equals(remoteId),
    )).write(const LessonsCompanion(isCompleted: Value(true)));
  }

  /// Отримує наступний незавершений урок у курсі.
  Future<LessonDB?> getNextUncompletedLesson(int courseId) {
    return (select(lessons)
          ..where(
            (l) => l.courseId.equals(courseId) & l.isCompleted.equals(false),
          )
          ..orderBy([(l) => OrderingTerm.asc(l.orderIndex)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Отримує наступний незавершений урок серед усіх курсів.
  Future<LessonDB?> getGlobalNextLesson() {
    return (select(lessons)
          ..where((l) => l.isCompleted.equals(false))
          ..orderBy([
            (l) => OrderingTerm.asc(l.courseId),
            (l) => OrderingTerm.asc(l.orderIndex),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Вставляє або оновлює урок.
  Future<int> upsertLesson(LessonsCompanion lesson) {
    return into(lessons).insert(
      lesson,
      onConflict: DoUpdate((_) => lesson, target: [lessons.remoteId]),
    );
  }

  /// Підраховує завершені уроки курсу.
  Future<int> countCompletedLessons(int courseId) async {
    final result =
        await (select(lessons)..where(
          (l) => l.courseId.equals(courseId) & l.isCompleted.equals(true),
        )).get();
    return result.length;
  }

  /// Підраховує всі завершені уроки в усіх курсах (для досягнення knowledge_seeker).
  Future<int> countAllCompletedLessons() async {
    final result =
        await (select(lessons)..where((l) => l.isCompleted.equals(true))).get();
    return result.length;
  }
}
