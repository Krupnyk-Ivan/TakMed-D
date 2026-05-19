import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_message_entity.dart';

enum ChatStatus { initial, loading, ready, sending, error, rateLimited }

class ChatState extends Equatable {
  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const [],
    this.remainingToday = 30,
    this.errorMessage,
  });

  final ChatStatus status;
  final List<ChatMessageEntity> messages;
  final int remainingToday;
  final String? errorMessage;

  ChatState copyWith({
    ChatStatus? status,
    List<ChatMessageEntity>? messages,
    int? remainingToday,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      remainingToday: remainingToday ?? this.remainingToday,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, messages, remainingToday, errorMessage];
}
