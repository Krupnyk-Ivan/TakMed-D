import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:takmed/core/database/app_database.dart';
import 'package:takmed/core/database/daos/chat_dao.dart';

AppDatabase _openTestDb() => AppDatabase.forTesting(NativeDatabase.memory());

ChatMessagesLocalCompanion _msg({
  String id = 'm1',
  String userId = 'user_1',
  String role = 'user',
  String content = 'hello',
  DateTime? at,
}) =>
    ChatMessagesLocalCompanion(
      id: Value(id),
      userId: Value(userId),
      role: Value(role),
      content: Value(content),
      createdAt: Value(at ?? DateTime.now()),
    );

void main() {
  late AppDatabase db;
  late ChatDao dao;

  setUp(() {
    db = _openTestDb();
    dao = db.chatDao;
  });
  tearDown(() => db.close());

  group('upsertMessages', () {
    test('зберігає повідомлення', () async {
      await dao.upsertMessages([_msg(id: 'a')]);
      final list = await dao.getMessagesByUser('user_1');
      expect(list.length, 1);
      expect(list.first.id, 'a');
    });

    test('конфлікт по id оновлює запис (insertOrReplace)', () async {
      await dao.upsertMessages([_msg(id: 'a', content: 'v1')]);
      await dao.upsertMessages([_msg(id: 'a', content: 'v2')]);
      final list = await dao.getMessagesByUser('user_1');
      expect(list.length, 1);
      expect(list.first.content, 'v2');
    });

    test('порожній батч — no-op', () async {
      await dao.upsertMessages([]);
      final list = await dao.getMessagesByUser('user_1');
      expect(list, isEmpty);
    });

    test('зберігає батч кількох повідомлень', () async {
      await dao.upsertMessages([
        _msg(id: 'a', content: 'first'),
        _msg(id: 'b', content: 'second'),
      ]);
      final list = await dao.getMessagesByUser('user_1');
      expect(list.length, 2);
    });
  });

  group('getMessagesByUser', () {
    test('повертає порожній список якщо немає повідомлень', () async {
      final list = await dao.getMessagesByUser('nobody');
      expect(list, isEmpty);
    });

    test('фільтрує за userId', () async {
      await dao.upsertMessages([
        _msg(id: 'a', userId: 'user_1'),
        _msg(id: 'b', userId: 'user_2'),
      ]);
      final list = await dao.getMessagesByUser('user_1');
      expect(list.length, 1);
      expect(list.first.userId, 'user_1');
    });

    test('сортує за createdAt по зростанню', () async {
      final t1 = DateTime(2026, 1, 1);
      final t2 = DateTime(2026, 1, 2);
      final t3 = DateTime(2026, 1, 3);
      await dao.upsertMessages([
        _msg(id: 'c', at: t3),
        _msg(id: 'a', at: t1),
        _msg(id: 'b', at: t2),
      ]);
      final list = await dao.getMessagesByUser('user_1');
      expect(list.map((m) => m.id).toList(), ['a', 'b', 'c']);
    });
  });

  group('clearByUser', () {
    test('видаляє всі повідомлення користувача', () async {
      await dao.upsertMessages([
        _msg(id: 'a', userId: 'user_1'),
        _msg(id: 'b', userId: 'user_1'),
        _msg(id: 'c', userId: 'user_2'),
      ]);
      final deleted = await dao.clearByUser('user_1');
      expect(deleted, 2);

      final list1 = await dao.getMessagesByUser('user_1');
      expect(list1, isEmpty);

      final list2 = await dao.getMessagesByUser('user_2');
      expect(list2.length, 1);
    });
  });
}
