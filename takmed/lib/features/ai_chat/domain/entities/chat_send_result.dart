import 'package:equatable/equatable.dart';
import 'chat_message_entity.dart';

/// Результат успішного відправлення повідомлення:
/// нова відповідь асистента + залишок денного ліміту.
class ChatSendResult extends Equatable {
  const ChatSendResult({
    required this.assistantMessage,
    required this.remainingToday,
  });

  final ChatMessageEntity assistantMessage;
  final int remainingToday;

  @override
  List<Object?> get props => [assistantMessage, remainingToday];
}
