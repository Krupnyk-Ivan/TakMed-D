import '../../../../core/database/daos/chat_dao.dart';
import '../models/chat_message_model.dart';

abstract class ChatLocalDataSource {
  Future<List<ChatMessageModel>> getMessages(String userId);
  Future<void> upsertMessages(String userId, List<ChatMessageModel> messages);
  Future<void> clear(String userId);
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  ChatLocalDataSourceImpl(this._dao);
  final ChatDao _dao;

  @override
  Future<List<ChatMessageModel>> getMessages(String userId) async {
    final rows = await _dao.getMessagesByUser(userId);
    return rows.map(ChatMessageModel.fromDb).toList();
  }

  @override
  Future<void> upsertMessages(
    String userId,
    List<ChatMessageModel> messages,
  ) async {
    final companions = messages.map((m) => m.toCompanion(userId)).toList();
    await _dao.upsertMessages(companions);
  }

  @override
  Future<void> clear(String userId) => _dao.clearByUser(userId);
}
