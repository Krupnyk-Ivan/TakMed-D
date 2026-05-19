import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/chat_messages_table.dart';

part 'chat_dao.g.dart';

@DriftAccessor(tables: [ChatMessagesLocal])
class ChatDao extends DatabaseAccessor<AppDatabase> with _$ChatDaoMixin {
  ChatDao(super.db);

  Future<List<ChatMessageDB>> getMessagesByUser(String userId) {
    return (select(chatMessagesLocal)
          ..where((m) => m.userId.equals(userId))
          ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
        .get();
  }

  /// Upsert батчу повідомлень. Конфлікт по `id` оновлює запис.
  Future<void> upsertMessages(List<ChatMessagesLocalCompanion> rows) async {
    if (rows.isEmpty) return;
    await batch((b) {
      for (final r in rows) {
        b.insert(chatMessagesLocal, r, mode: InsertMode.insertOrReplace);
      }
    });
  }

  /// Видаляє всі повідомлення користувача (logout/cleanup).
  Future<int> clearByUser(String userId) {
    return (delete(chatMessagesLocal)..where((m) => m.userId.equals(userId)))
        .go();
  }
}
