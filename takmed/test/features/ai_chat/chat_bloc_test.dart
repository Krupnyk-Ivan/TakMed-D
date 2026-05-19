import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:takmed/core/errors/failures.dart';
import 'package:takmed/features/ai_chat/data/repositories/chat_repository_impl.dart';
import 'package:takmed/features/ai_chat/domain/entities/chat_message_entity.dart';
import 'package:takmed/features/ai_chat/domain/entities/chat_send_result.dart';
import 'package:takmed/features/ai_chat/domain/usecases/get_chat_history_use_case.dart';
import 'package:takmed/features/ai_chat/domain/usecases/send_chat_message_use_case.dart';
import 'package:takmed/features/ai_chat/presentation/bloc/chat_bloc.dart';
import 'package:takmed/features/ai_chat/presentation/bloc/chat_event.dart';
import 'package:takmed/features/ai_chat/presentation/bloc/chat_state.dart';

import 'chat_bloc_test.mocks.dart';

@GenerateMocks([GetChatHistoryUseCase, SendChatMessageUseCase])
void main() {
  late MockGetChatHistoryUseCase mockGetHistory;
  late MockSendChatMessageUseCase mockSendMessage;

  setUp(() {
    mockGetHistory = MockGetChatHistoryUseCase();
    mockSendMessage = MockSendChatMessageUseCase();
  });

  ChatBloc buildBloc() => ChatBloc(mockGetHistory, mockSendMessage);

  final assistantMsg = ChatMessageEntity(
    id: 'remote_asst_1',
    role: 'assistant',
    content: 'Відповідь',
    createdAt: DateTime(2026, 5, 16, 10, 0),
  );

  group('ChatHistoryRequested', () {
    blocTest<ChatBloc, ChatState>(
      'успіх → ready з повідомленнями',
      build: () {
        when(mockGetHistory()).thenAnswer(
          (_) async => const Right(<ChatMessageEntity>[]),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(const ChatHistoryRequested()),
      expect: () => [
        isA<ChatState>().having((s) => s.status, 'status', ChatStatus.loading),
        isA<ChatState>().having((s) => s.status, 'status', ChatStatus.ready),
      ],
    );

    blocTest<ChatBloc, ChatState>(
      'failure → error',
      build: () {
        when(mockGetHistory()).thenAnswer(
          (_) async => const Left(AuthFailure('no session')),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(const ChatHistoryRequested()),
      expect: () => [
        isA<ChatState>().having((s) => s.status, 'status', ChatStatus.loading),
        isA<ChatState>()
            .having((s) => s.status, 'status', ChatStatus.error)
            .having((s) => s.errorMessage, 'errorMessage', 'no session'),
      ],
    );
  });

  group('ChatMessageSent', () {
    blocTest<ChatBloc, ChatState>(
      'успіх → sending з optimistic user-msg → ready з assistant-msg',
      build: () {
        when(mockSendMessage(any)).thenAnswer(
          (_) async => Right(ChatSendResult(
            assistantMessage: assistantMsg,
            remainingToday: 29,
          )),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(const ChatMessageSent('Що таке MARCH?')),
      expect: () => [
        // 1. sending з optimistic-user (pending=true)
        isA<ChatState>()
            .having((s) => s.status, 'status', ChatStatus.sending)
            .having((s) => s.messages.length, 'messages count', 1)
            .having((s) => s.messages.first.isPending, 'isPending', true)
            .having((s) => s.messages.first.role, 'role', 'user'),
        // 2. ready з user (confirmed) + assistant + лічильник 29
        isA<ChatState>()
            .having((s) => s.status, 'status', ChatStatus.ready)
            .having((s) => s.messages.length, 'messages count', 2)
            .having((s) => s.messages.last.role, 'last.role', 'assistant')
            .having((s) => s.messages.last.content, 'reply', 'Відповідь')
            .having((s) => s.remainingToday, 'remainingToday', 29),
      ],
    );

    blocTest<ChatBloc, ChatState>(
      'порожній text → не викликає usecase і не міняє стан',
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const ChatMessageSent('   ')),
      expect: () => <ChatState>[],
      verify: (_) {
        verifyNever(mockSendMessage(any));
      },
    );

    blocTest<ChatBloc, ChatState>(
      'rate-limit failure → rateLimited статус + повідомлення',
      build: () {
        when(mockSendMessage(any)).thenAnswer(
          (_) async => const Left(RateLimitFailure('Денний ліміт вичерпано')),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(const ChatMessageSent('test')),
      expect: () => [
        isA<ChatState>().having((s) => s.status, 'status', ChatStatus.sending),
        isA<ChatState>()
            .having((s) => s.status, 'status', ChatStatus.rateLimited)
            .having((s) => s.errorMessage, 'errorMessage', 'Денний ліміт вичерпано')
            // optimistic user був прибраний
            .having((s) => s.messages, 'messages reverted', isEmpty),
      ],
    );

    blocTest<ChatBloc, ChatState>(
      'мережева failure → error статус, повідомлення прибрано',
      build: () {
        when(mockSendMessage(any)).thenAnswer(
          (_) async => const Left(NetworkFailure('no internet')),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(const ChatMessageSent('test')),
      expect: () => [
        isA<ChatState>().having((s) => s.status, 'status', ChatStatus.sending),
        isA<ChatState>()
            .having((s) => s.status, 'status', ChatStatus.error)
            .having((s) => s.errorMessage, 'errorMessage', 'no internet')
            .having((s) => s.messages, 'messages reverted', isEmpty),
      ],
    );
  });

  group('ChatErrorDismissed', () {
    blocTest<ChatBloc, ChatState>(
      'переводить error → ready без повідомлення',
      build: buildBloc,
      seed: () => const ChatState(
        status: ChatStatus.error,
        errorMessage: 'oops',
      ),
      act: (bloc) => bloc.add(const ChatErrorDismissed()),
      expect: () => [
        isA<ChatState>()
            .having((s) => s.status, 'status', ChatStatus.ready)
            .having((s) => s.errorMessage, 'errorMessage', isNull),
      ],
    );
  });
}
