import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/chat_message_entity.dart';
import '../entities/chat_send_result.dart';

/// Контракт репозиторію AI-чату.
abstract class ChatRepository {
  /// Отримує історію — спочатку з локального кешу,
  /// потім (якщо є мережа) оновлює його з Supabase.
  Future<Either<Failure, List<ChatMessageEntity>>> getHistory();

  /// Надсилає повідомлення через Edge Function `chat-tcc`,
  /// зберігає user+assistant у локальний кеш.
  Future<Either<Failure, ChatSendResult>> sendMessage({
    required String text,
    required List<ChatMessageEntity> history,
  });
}
