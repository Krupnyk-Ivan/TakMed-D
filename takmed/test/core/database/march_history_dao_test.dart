import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:takmed/core/database/app_database.dart';
import 'package:takmed/core/database/daos/march_history_dao.dart';

AppDatabase _openTestDb() => AppDatabase.forTesting(NativeDatabase.memory());

MarchHistoryCompanion _entry({
  String userId = 'u1',
  DateTime? startedAt,
  int duration = 300,
  int successRate = 80,
  String weakTopics = '[]',
  bool isDirty = true,
}) =>
    MarchHistoryCompanion(
      userId: Value(userId),
      startedAt: Value(startedAt ?? DateTime.now()),
      totalDurationSeconds: Value(duration),
      successRate: Value(successRate),
      weakTopics: Value(weakTopics),
      itemsJson: const Value('[]'),
      isDirty: Value(isDirty),
    );

void main() {
  late AppDatabase db;
  late MarchHistoryDao dao;

  setUp(() {
    db = _openTestDb();
    dao = db.marchHistoryDao;
  });
  tearDown(() => db.close());

  group('insertSession', () {
    test('зберігає сесію з is_dirty=true за замовчуванням', () async {
      final id = await dao.insertSession(_entry());
      expect(id, greaterThan(0));

      final rows = await dao.getByUser('u1');
      expect(rows.length, 1);
      expect(rows.first.isDirty, true);
      expect(rows.first.successRate, 80);
    });
  });

  group('getByUser', () {
    test('сортує від нових до старих', () async {
      await dao.insertSession(_entry(startedAt: DateTime(2026, 1, 1)));
      await dao.insertSession(_entry(startedAt: DateTime(2026, 3, 1)));
      await dao.insertSession(_entry(startedAt: DateTime(2026, 2, 1)));

      final rows = await dao.getByUser('u1');
      expect(rows.first.startedAt, DateTime(2026, 3, 1));
      expect(rows.last.startedAt, DateTime(2026, 1, 1));
    });

    test('фільтрує за userId', () async {
      await dao.insertSession(_entry(userId: 'u1'));
      await dao.insertSession(_entry(userId: 'u2'));

      final rows = await dao.getByUser('u1');
      expect(rows.length, 1);
      expect(rows.first.userId, 'u1');
    });
  });

  group('getDirty', () {
    test('повертає лише dirty-записи користувача', () async {
      await dao.insertSession(_entry(isDirty: true));
      await dao.insertSession(_entry(isDirty: false));

      final dirty = await dao.getDirty('u1');
      expect(dirty.length, 1);
      expect(dirty.first.isDirty, true);
    });
  });

  group('markSynced', () {
    test('очищає isDirty та виставляє syncedAt', () async {
      final id = await dao.insertSession(_entry());

      await dao.markSynced(id, at: DateTime(2026, 5, 17, 12));
      final rows = await dao.getByUser('u1');

      expect(rows.first.isDirty, false);
      expect(rows.first.syncedAt, DateTime(2026, 5, 17, 12));
    });
  });

  group('clearByUser', () {
    test('видаляє всі записи користувача', () async {
      await dao.insertSession(_entry(userId: 'u1'));
      await dao.insertSession(_entry(userId: 'u1'));
      await dao.insertSession(_entry(userId: 'u2'));

      await dao.clearByUser('u1');

      final left = await dao.getByUser('u1');
      expect(left, isEmpty);
      final other = await dao.getByUser('u2');
      expect(other.length, 1);
    });
  });
}
