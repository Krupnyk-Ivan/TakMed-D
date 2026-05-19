import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/usecases/get_chat_history_use_case.dart';
import '../../domain/usecases/send_chat_message_use_case.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(this._getHistory, this._sendMessage) : super(const ChatState()) {
    on<ChatHistoryRequested>(_onHistoryRequested);
    on<ChatMessageSent>(_onMessageSent);
    on<ChatErrorDismissed>(_onErrorDismissed);
  }

  final GetChatHistoryUseCase _getHistory;
  final SendChatMessageUseCase _sendMessage;

  Future<void> _onHistoryRequested(
    ChatHistoryRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(status: ChatStatus.loading, clearError: true));
    final result = await _getHistory();
    result.fold(
      (failure) => emit(state.copyWith(
        status: ChatStatus.error,
        errorMessage: failure.message,
      )),
      (messages) => emit(state.copyWith(
        status: ChatStatus.ready,
        messages: messages,
      )),
    );
  }

  Future<void> _onMessageSent(
    ChatMessageSent event,
    Emitter<ChatState> emit,
  ) async {
    final trimmed = event.text.trim();
    if (trimmed.isEmpty) return;

    // Зберігаємо оригінальний список ДО optimistic, щоб при failure відкотитись.
    final originalMessages = List<ChatMessageEntity>.from(state.messages);

    final optimisticUser = ChatMessageEntity(
      id: 'local_user_${DateTime.now().microsecondsSinceEpoch}',
      role: 'user',
      content: trimmed,
      createdAt: DateTime.now(),
      isPending: true,
    );

    emit(state.copyWith(
      status: ChatStatus.sending,
      messages: [...originalMessages, optimisticUser],
      clearError: true,
    ));

    final result = await _sendMessage(SendChatMessageParams(
      text: trimmed,
      history: originalMessages,
    ));

    result.fold(
      (failure) {
        final isRateLimit = failure is RateLimitFailure;
        emit(state.copyWith(
          status: isRateLimit ? ChatStatus.rateLimited : ChatStatus.error,
          messages: originalMessages,
          errorMessage: failure.message,
        ));
      },
      (sendResult) {
        final confirmedUser = optimisticUser.copyWith(isPending: false);
        emit(state.copyWith(
          status: ChatStatus.ready,
          messages: [
            ...originalMessages,
            confirmedUser,
            sendResult.assistantMessage,
          ],
          remainingToday: sendResult.remainingToday,
        ));
      },
    );
  }

  void _onErrorDismissed(
    ChatErrorDismissed event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(
      status: ChatStatus.ready,
      clearError: true,
    ));
  }
}
