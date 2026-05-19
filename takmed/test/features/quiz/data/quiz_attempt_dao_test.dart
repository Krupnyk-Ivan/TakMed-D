import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:takmed/core/database/app_database.dart';
import 'package:takmed/core/database/daos/quiz_attempt_dao.dart';

AppDatabase _openTestDb() =>
    AppDatabase.forTesting(NativeDatabase.memory());

QuizAttemptsCompanion _makeAttempt({
  String userId = 'user_1',
  String? lessonRemoteId,
  int total = 10,
  int correct = 8,
  int percent = 80,
  int xp = 80,
  DateTime? at,
}) =>
    QuizAttemptsCompanion(
      userId: Value(userId),
      lessonRemoteId: Value(lessonRemoteId),
      totalQuestions: Value(total),
      correctAnswers: Value(correct),
      scorePercent: Value(percent),
      earnedXp: Value(xp),
      weakTopics: const Value('[]'),
      attemptedAt: Value(at ?? DateTime.now()),
    );

void main() {
  late AppDatabase db;
  late QuizAttemptDao dao;

  setUp(() {
    db = _openTestDb();
    dao = db.quizAttemptDao;
  });

  tearDown(() => db.close());

  group('saveAttempt', () {
    test('зберігає спробу і повертає id > 0', () async {
      final id = await dao.saveAttempt(_makeAttempt());
      expect(id, greaterThan(0));
    });

    test('кожна спроба зберігається окремо (не перезаписується)', () async {
      await dao.saveAttempt(_makeAttempt(percent: 60));
      await dao.saveAttempt(_makeAttempt(percent: 80));
      await dao.saveAttempt(_makeAttempt(percent: 100));

      final all = await dao.getAttemptsByUser('user_1');
      expect(all.length, 3);
    });
  });

  group('getAttemptsByUser', () {
    test('повертає порожній список якщо немає спроб', () async {
      final list = await dao.getAttemptsByUser('unknown_user');
      expect(list, isEmpty);
    });

    test('повертає тільки спроби конкретного користувача', () async {
      await dao.saveAttempt(_makeAttempt(userId: 'user_1'));
      await dao.saveAttempt(_makeAttempt(userId: 'user_2'));

      final list = await dao.getAttemptsByUser('user_1');
      expect(list.length, 1);
      expect(list.first.userId, 'user_1');
    });

    test('сортує від нових до старих', () async {
      final old = DateTime(2026, 1, 1);
      final recent = DateTime(2026, 6, 1);
      await dao.saveAttempt(_makeAttempt(at: old, percent: 60));
      await dao.saveAttempt(_makeAttempt(at: recent, percent: 90));

      final list = await dao.getAttemptsByUser('user_1');
      expect(list.first.attemptedAt, recent);
      expect(list.last.attemptedAt, old);
    });
  });

  group('getAttemptsByLesson', () {
    test('повертає тільки спроби конкретного уроку', () async {
      await dao.saveAttempt(_makeAttempt(lessonRemoteId: 'lesson_1', percent: 70));
      await dao.saveAttempt(_makeAttempt(lessonRemoteId: 'lesson_2', percent: 90));

      final list = await dao.getAttemptsByLesson('user_1', 'lesson_1');
      expect(list.length, 1);
      expect(list.first.scorePercent, 70);
    });
  });

  group('countAttemptsByUser', () {
    test('повертає 0 якщо немає спроб', () async {
      final count = await dao.countAttemptsByUser('nobody');
      expect(count, 0);
    });

    test('рахує всі спроби користувача', () async {
      await dao.saveAttempt(_makeAttempt());
      await dao.saveAttempt(_makeAttempt());
      await dao.saveAttempt(_makeAttempt());

      final count = await dao.countAttemptsByUser('user_1');
      expect(count, 3);
    });
  });

  group('getBestAttemptForLesson', () {
    test('повертає null якщо немає спроб', () async {
      final best = await dao.getBestAttemptForLesson('user_1', 'lesson_1');
      expect(best, isNull);
    });

    test('повертає спробу з найвищим відсотком', () async {
      await dao.saveAttempt(_makeAttempt(lessonRemoteId: 'lesson_1', percent: 50));
      await dao.saveAttempt(_makeAttempt(lessonRemoteId: 'lesson_1', percent: 90));
      await dao.saveAttempt(_makeAttempt(lessonRemoteId: 'lesson_1', percent: 70));

      final best = await dao.getBestAttemptForLesson('user_1', 'lesson_1');
      expect(best?.scorePercent, 90);
    });
  });

  group('deleteAttemptsByUser', () {
    test('видаляє всі спроби користувача', () async {
      await dao.saveAttempt(_makeAttempt(userId: 'user_1'));
      await dao.saveAttempt(_makeAttempt(userId: 'user_1'));
      await dao.saveAttempt(_makeAttempt(userId: 'user_2'));

      await dao.deleteAttemptsByUser('user_1');

      final remaining = await dao.getAttemptsByUser('user_1');
      expect(remaining, isEmpty);

      final other = await dao.getAttemptsByUser('user_2');
      expect(other.length, 1);
    });
  });

  group('watchAttemptsByUser', () {
    test('емітує список при підписці', () async {
      await dao.saveAttempt(_makeAttempt(percent: 75));

      final stream = dao.watchAttemptsByUser('user_1');
      final first = await stream.first;
      expect(first.length, 1);
      expect(first.first.scorePercent, 75);
    });
  });

  group('getAttemptsLast30Days', () {
    test('повертає тільки спроби молодші за 30 днів', () async {
      final now = DateTime.now();
      await dao.saveAttempt(_makeAttempt(at: now, percent: 90));
      await dao.saveAttempt(_makeAttempt(
        at: now.subtract(const Duration(days: 5)),
        percent: 70,
      ));
      // Старіше 30 днів — не має потрапити
      await dao.saveAttempt(_makeAttempt(
        at: now.subtract(const Duration(days: 35)),
        percent: 50,
      ));

      final list = await dao.getAttemptsLast30Days('user_1');
      expect(list.length, 2);
      // Сортування зростаюче (від старих до нових)
      expect(list.first.scorePercent, 70);
      expect(list.last.scorePercent, 90);
    });

    test('повертає порожній список якщо немає недавніх спроб', () async {
      final now = DateTime.now();
      await dao.saveAttempt(_makeAttempt(
        at: now.subtract(const Duration(days: 60)),
      ));

      final list = await dao.getAttemptsLast30Days('user_1');
      expect(list, isEmpty);
    });

    test('фільтрує за userId', () async {
      final now = DateTime.now();
      await dao.saveAttempt(_makeAttempt(userId: 'user_1', at: now));
      await dao.saveAttempt(_makeAttempt(userId: 'user_2', at: now));

      final list = await dao.getAttemptsLast30Days('user_1');
      expect(list.length, 1);
      expect(list.first.userId, 'user_1');
    });
  });
}
