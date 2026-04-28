import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:takmed/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  group('ProgressDao', () {
    test('saveProgress та getProgressByLesson', () async {
      await db.progressDao.saveProgress(UserProgressCompanion.insert(
        lessonRemoteId: 'l-1',
        score: 85,
        attempts: 2,
        completedAt: DateTime(2024, 1, 1),
        weakTopics: '["Турнікети"]',
      ));

      final progress = await db.progressDao.getProgressByLesson('l-1');
      expect(progress, isNotNull);
      expect(progress!.score, 85);
      expect(progress.attempts, 2);
      expect(progress.weakTopics, '["Турнікети"]');
    });

    test('getProgressByLesson повертає null якщо немає', () async {
      final progress = await db.progressDao.getProgressByLesson('nonexistent');
      expect(progress, isNull);
    });

    test('getAllProgress повертає все', () async {
      await db.progressDao.saveProgress(UserProgressCompanion.insert(
        lessonRemoteId: 'l-1', score: 90, attempts: 1,
        completedAt: DateTime.now(), weakTopics: '[]',
      ));
      await db.progressDao.saveProgress(UserProgressCompanion.insert(
        lessonRemoteId: 'l-2', score: 70, attempts: 3,
        completedAt: DateTime.now(), weakTopics: '["СЛР"]',
      ));

      final all = await db.progressDao.getAllProgress();
      expect(all.length, 2);
    });
  });
}
