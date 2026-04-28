import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/courses_table.dart';

part 'course_dao.g.dart';

/// DAO для роботи з таблицею курсів.
@DriftAccessor(tables: [Courses])
class CourseDao extends DatabaseAccessor<AppDatabase> with _$CourseDaoMixin {
  /// Створює DAO курсів.
  CourseDao(super.db);

  /// Отримує курси за треком (реактивний стрім).
  Stream<List<CourseDB>> watchCoursesByTrack(String track) {
    return (select(courses)
          ..where((c) => c.track.equals(track))
          ..orderBy([(c) => OrderingTerm.asc(c.orderIndex)]))
        .watch();
  }

  /// Отримує всі курси.
  Future<List<CourseDB>> getAllCourses() {
    return (select(courses)
      ..orderBy([(c) => OrderingTerm.asc(c.orderIndex)])).get();
  }

  /// Отримує курси за треком (одноразовий запит).
  Future<List<CourseDB>> getCoursesByTrack(String track) {
    return (select(courses)
          ..where((c) => c.track.equals(track))
          ..orderBy([(c) => OrderingTerm.asc(c.orderIndex)]))
        .get();
  }

  /// Отримує курс за ID.
  Future<CourseDB?> getCourseById(int id) {
    return (select(courses)..where((c) => c.id.equals(id))).getSingleOrNull();
  }

  /// Отримує курс за remote ID.
  Future<CourseDB?> getCourseByRemoteId(String remoteId) {
    return (select(courses)
      ..where((c) => c.remoteId.equals(remoteId))).getSingleOrNull();
  }

  /// Вставляє або оновлює курс.
  Future<int> upsertCourse(CoursesCompanion course) {
    return into(courses).insert(
      course,
      onConflict: DoUpdate((_) => course, target: [courses.remoteId]),
    );
  }

  /// Позначає курс як завантажений офлайн.
  Future<int> markAsDownloaded(int id) {
    return (update(courses)..where(
      (c) => c.id.equals(id),
    )).write(const CoursesCompanion(isDownloaded: Value(true)));
  }

  /// Оновлює лічильники прогресу курсу.
  Future<int> updateProgress(int id, int completedLessons) {
    return (update(courses)..where(
      (c) => c.id.equals(id),
    )).write(CoursesCompanion(completedLessons: Value(completedLessons)));
  }
}
