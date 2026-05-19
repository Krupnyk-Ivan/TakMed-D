import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class GetChatHistoryUseCase {
  const GetChatHistoryUseCase(this._repository);
  final ChatRepository _repository;

  Future<Either<Failure, List<ChatMessageEntity>>> call() =>
      _repository.getHistory();
}
