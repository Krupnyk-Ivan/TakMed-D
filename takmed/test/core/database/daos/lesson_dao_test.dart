import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:takmed/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    // Insert a course first
    await db.courseDao.upsertCourse(CoursesCompanion.insert(
      remoteId: 'c-1', title: 'Course 1', description: 'd',
      track: 'military', orderIndex: 0, updatedAt: DateTime.now(),
      totalLessons: const Value(3),
    ));
  });

  tearDown(() => db.close());

  group('LessonDao', () {
    test('getLessonsByCourse повертає уроки курсу', () async {
      await db.lessonDao.upsertLesson(LessonsCompanion.insert(
        remoteId: 'l-1', courseId: 1, type: 'theory', title: 'Урок 1',
        contentJson: '{}', durationSeconds: 300, orderIndex: 0,
      ));
      await db.lessonDao.upsertLesson(LessonsCompanion.insert(
        remoteId: 'l-2', courseId: 1, type: 'quiz', title: 'Урок 2',
        contentJson: '{}', durationSeconds: 180, orderIndex: 1,
      ));

      final lessons = await db.lessonDao.getLessonsByCourse(1);
      expect(lessons.length, 2);
      expect(lessons[0].title, 'Урок 1');
      expect(lessons[1].title, 'Урок 2');
    });

    test('markLessonCompleted', () async {
      final id = await db.lessonDao.upsertLesson(LessonsCompanion.insert(
        remoteId: 'l-1', courseId: 1, type: 'theory', title: 'Урок 1',
        contentJson: '{}', durationSeconds: 300, orderIndex: 0,
      ));

      var lesson = await db.lessonDao.getLessonById(id);
      expect(lesson!.isCompleted, false);

      await db.lessonDao.markLessonCompleted(id);

      lesson = await db.lessonDao.getLessonById(id);
      expect(lesson!.isCompleted, true);
    });

    test('getNextUncompletedLesson', () async {
      await db.lessonDao.upsertLesson(LessonsCompanion.insert(
        remoteId: 'l-1', courseId: 1, type: 'theory', title: 'Урок 1',
        contentJson: '{}', durationSeconds: 300, orderIndex: 0,
        isCompleted: const Value(true),
      ));
      await db.lessonDao.upsertLesson(LessonsCompanion.insert(
        remoteId: 'l-2', courseId: 1, type: 'quiz', title: 'Урок 2',
        contentJson: '{}', durationSeconds: 180, orderIndex: 1,
      ));

      final next = await db.lessonDao.getNextUncompletedLesson(1);
      expect(next, isNotNull);
      expect(next!.title, 'Урок 2');
    });

    test('getNextUncompletedLesson повертає null якщо всі завершені', () async {
      await db.lessonDao.upsertLesson(LessonsCompanion.insert(
        remoteId: 'l-1', courseId: 1, type: 'theory', title: 'Урок 1',
        contentJson: '{}', durationSeconds: 300, orderIndex: 0,
        isCompleted: const Value(true),
      ));

      final next = await db.lessonDao.getNextUncompletedLesson(1);
      expect(next, isNull);
    });

    test('countCompletedLessons', () async {
      await db.lessonDao.upsertLesson(LessonsCompanion.insert(
        remoteId: 'l-1', courseId: 1, type: 'theory', title: 'Урок 1',
        contentJson: '{}', durationSeconds: 300, orderIndex: 0,
        isCompleted: const Value(true),
      ));
      await db.lessonDao.upsertLesson(LessonsCompanion.insert(
        remoteId: 'l-2', courseId: 1, type: 'quiz', title: 'Урок 2',
        contentJson: '{}', durationSeconds: 180, orderIndex: 1,
      ));
      await db.lessonDao.upsertLesson(LessonsCompanion.insert(
        remoteId: 'l-3', courseId: 1, type: 'checklist', title: 'Урок 3',
        contentJson: '{}', durationSeconds: 240, orderIndex: 2,
        isCompleted: const Value(true),
      ));

      final count = await db.lessonDao.countCompletedLessons(1);
      expect(count, 2);
    });

    test('getGlobalNextLesson', () async {
      await db.lessonDao.upsertLesson(LessonsCompanion.insert(
        remoteId: 'l-1', courseId: 1, type: 'theory', title: 'Перший',
        contentJson: '{}', durationSeconds: 300, orderIndex: 0,
      ));

      final next = await db.lessonDao.getGlobalNextLesson();
      expect(next, isNotNull);
      expect(next!.title, 'Перший');
    });
  });
}
