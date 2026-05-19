import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../models/chat_message_model.dart';

/// Виняток для перевищеного денного ліміту запитів.
class ChatRateLimitException implements Exception {
  ChatRateLimitException(this.message);
  final String message;
  @override
  String toString() => 'ChatRateLimitException: $message';
}

/// Контракт remote data source.
abstract class ChatRemoteDataSource {
  Future<List<ChatMessageModel>> fetchHistory({int limit = 50});

  Future<ChatSendApiResult> sendMessage({
    required String text,
    required List<ChatMessageEntity> history,
  });
}

/// Сирий результат Edge Function — текст + залишок ліміту.
class ChatSendApiResult {
  const ChatSendApiResult({
    required this.reply,
    required this.remainingToday,
  });
  final String reply;
  final int remainingToday;
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  ChatRemoteDataSourceImpl(this._client);
  final SupabaseClient _client;

  @override
  Future<List<ChatMessageModel>> fetchHistory({int limit = 50}) async {
    final user = _client.auth.currentUser;
    if (user == null) throw AppAuthException(message: 'Не авторизовано');

    try {
      final data = await _client
          .from('chat_messages')
          .select('id, role, content, created_at')
          .eq('user_id', user.id)
          .order('created_at', ascending: true)
          .limit(limit);

      return (data as List)
          .map((r) => ChatMessageModel.fromSupabaseMap(
                Map<String, dynamic>.from(r as Map),
              ))
          .toList();
    } on PostgrestException catch (e) {
      throw AppAuthException(message: e.message, originalError: e);
    }
  }

  @override
  Future<ChatSendApiResult> sendMessage({
    required String text,
    required List<ChatMessageEntity> history,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw AppAuthException(message: 'Не авторизовано');

    final payloadMessages = [
      ...history.map((m) => {'role': m.role, 'content': m.content}),
      {'role': 'user', 'content': text},
    ];

    final response = await _client.functions.invoke(
      'chat-tcc',
      body: {'messages': payloadMessages},
    );

    final status = response.status;
    final data = response.data;

    if (status == 429) {
      final msg = (data is Map && data['error'] is String)
          ? data['error'] as String
          : 'Денний ліміт запитів вичерпано.';
      throw ChatRateLimitException(msg);
    }

    if (status < 200 || status >= 300) {
      final msg = (data is Map && data['error'] is String)
          ? data['error'] as String
          : 'Помилка сервера (HTTP $status)';
      throw AppAuthException(message: msg);
    }

    if (data is! Map) {
      throw AppAuthException(message: 'Невалідна відповідь сервера');
    }

    final reply = data['reply'] as String? ?? '';
    final remaining = (data['remainingToday'] as num?)?.toInt() ?? 0;

    if (reply.isEmpty) {
      throw AppAuthException(message: 'Порожня відповідь ШІ');
    }

    return ChatSendApiResult(reply: reply, remainingToday: remaining);
  }
}
