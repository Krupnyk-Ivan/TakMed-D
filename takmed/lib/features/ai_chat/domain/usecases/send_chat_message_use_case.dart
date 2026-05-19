import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/chat_message_entity.dart';
import '../entities/chat_send_result.dart';
import '../repositories/chat_repository.dart';

class SendChatMessageParams {
  const SendChatMessageParams({
    required this.text,
    required this.history,
  });
  final String text;
  final List<ChatMessageEntity> history;
}

class SendChatMessageUseCase {
  const SendChatMessageUseCase(this._repository);
  final ChatRepository _repository;

  Future<Either<Failure, ChatSendResult>> call(SendChatMessageParams params) {
    return _repository.sendMessage(
      text: params.text,
      history: params.history,
    );
  }
}
