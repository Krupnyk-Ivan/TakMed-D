import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  const ChatMessageModel({
    required super.id,
    required super.role,
    required super.content,
    required super.createdAt,
    super.isPending,
  });

  factory ChatMessageModel.fromSupabaseMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      id: map['id'] as String,
      role: map['role'] as String,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['created_at'] as String).toLocal(),
    );
  }

  factory ChatMessageModel.fromDb(ChatMessageDB row) {
    return ChatMessageModel(
      id: row.id,
      role: row.role,
      content: row.content,
      createdAt: row.createdAt,
    );
  }

  ChatMessagesLocalCompanion toCompanion(String userId) {
    return ChatMessagesLocalCompanion(
      id: Value(id),
      userId: Value(userId),
      role: Value(role),
      content: Value(content),
      createdAt: Value(createdAt),
    );
  }
}
