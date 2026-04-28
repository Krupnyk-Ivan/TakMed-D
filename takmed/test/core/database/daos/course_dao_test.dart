import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:takmed/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  group('CourseDao', () {
    test('insert та query по треку', () async {
      await db.courseDao.upsertCourse(CoursesCompanion.insert(
        remoteId: 'mil-1', title: 'MARCH', description: 'Тест',
        track: 'military', orderIndex: 0, updatedAt: DateTime.now(),
      ));
      await db.courseDao.upsertCourse(CoursesCompanion.insert(
        remoteId: 'civ-1', title: 'Перша допомога', description: 'Тест',
        track: 'civilian', orderIndex: 0, updatedAt: DateTime.now(),
      ));

      final military = await db.courseDao.getCoursesByTrack('military');
      final civilian = await db.courseDao.getCoursesByTrack('civilian');

      expect(military.length, 1);
      expect(military.first.title, 'MARCH');
      expect(civilian.length, 1);
      expect(civilian.first.title, 'Перша допомога');
    });

    test('getAllCourses повертає всі курси', () async {
      await db.courseDao.upsertCourse(CoursesCompanion.insert(
        remoteId: 'mil-1', title: 'C1', description: 'd',
        track: 'military', orderIndex: 0, updatedAt: DateTime.now(),
      ));
      await db.courseDao.upsertCourse(CoursesCompanion.insert(
        remoteId: 'civ-1', title: 'C2', description: 'd',
        track: 'civilian', orderIndex: 1, updatedAt: DateTime.now(),
      ));

      final all = await db.courseDao.getAllCourses();
      expect(all.length, 2);
    });

    test('markAsDownloaded оновлює isDownloaded', () async {
      final id = await db.courseDao.upsertCourse(CoursesCompanion.insert(
        remoteId: 'mil-1', title: 'C1', description: 'd',
        track: 'military', orderIndex: 0, updatedAt: DateTime.now(),
      ));

      var course = await db.courseDao.getCourseById(id);
      expect(course!.isDownloaded, false);

      await db.courseDao.markAsDownloaded(id);

      course = await db.courseDao.getCourseById(id);
      expect(course!.isDownloaded, true);
    });

    test('updateProgress оновлює completedLessons', () async {
      final id = await db.courseDao.upsertCourse(CoursesCompanion.insert(
        remoteId: 'mil-1', title: 'C1', description: 'd',
        track: 'military', orderIndex: 0, updatedAt: DateTime.now(),
        totalLessons: const Value(5),
      ));

      await db.courseDao.updateProgress(id, 3);

      final course = await db.courseDao.getCourseById(id);
      expect(course!.completedLessons, 3);
    });

    test('watchCoursesByTrack реактивний стрім', () async {
      final stream = db.courseDao.watchCoursesByTrack('military');

      expectLater(stream, emitsInOrder([
        hasLength(0), // initial
        hasLength(1), // after insert
      ]));

      await pumpEventQueue();
      await db.courseDao.upsertCourse(CoursesCompanion.insert(
        remoteId: 'mil-1', title: 'C1', description: 'd',
        track: 'military', orderIndex: 0, updatedAt: DateTime.now(),
      ));
    });

    test('сортування за orderIndex', () async {
      await db.courseDao.upsertCourse(CoursesCompanion.insert(
        remoteId: 'mil-2', title: 'Другий', description: 'd',
        track: 'military', orderIndex: 1, updatedAt: DateTime.now(),
      ));
      await db.courseDao.upsertCourse(CoursesCompanion.insert(
        remoteId: 'mil-1', title: 'Перший', description: 'd',
        track: 'military', orderIndex: 0, updatedAt: DateTime.now(),
      ));

      final courses = await db.courseDao.getCoursesByTrack('military');
      expect(courses[0].title, 'Перший');
      expect(courses[1].title, 'Другий');
    });
  });
}
