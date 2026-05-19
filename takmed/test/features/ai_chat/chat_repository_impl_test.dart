import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:takmed/features/ai_chat/data/datasources/chat_local_data_source.dart';
import 'package:takmed/features/ai_chat/data/datasources/chat_remote_data_source.dart';
import 'package:takmed/features/ai_chat/data/models/chat_message_model.dart';
import 'package:takmed/features/ai_chat/data/repositories/chat_repository_impl.dart';

import 'chat_repository_impl_test.mocks.dart';

@GenerateMocks([
  ChatRemoteDataSource,
  ChatLocalDataSource,
  SupabaseClient,
  GoTrueClient,
  User,
])
void main() {
  late MockChatRemoteDataSource mockRemote;
  late MockChatLocalDataSource mockLocal;
  late MockSupabaseClient mockClient;
  late MockGoTrueClient mockAuth;
  late MockUser mockUser;

  setUp(() {
    mockRemote = MockChatRemoteDataSource();
    mockLocal = MockChatLocalDataSource();
    mockClient = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    mockUser = MockUser();
    when(mockClient.auth).thenReturn(mockAuth);
    when(mockAuth.currentUser).thenReturn(mockUser);
    when(mockUser.id).thenReturn('user_1');
  });

  ChatRepositoryImpl buildRepo() =>
      ChatRepositoryImpl(mockRemote, mockLocal, mockClient);

  final cached = [
    ChatMessageModel(
      id: 'cache_1',
      role: 'user',
      content: 'old q',
      createdAt: DateTime(2026, 5, 15),
    ),
  ];
  final remote = [
    ChatMessageModel(
      id: 'remote_1',
      role: 'user',
      content: 'new q',
      createdAt: DateTime(2026, 5, 16),
    ),
    ChatMessageModel(
      id: 'remote_2',
      role: 'assistant',
      content: 'answer',
      createdAt: DateTime(2026, 5, 16, 0, 1),
    ),
  ];

  group('getHistory', () {
    test('віддає remote якщо він непорожній, кеш оновлено', () async {
      when(mockLocal.getMessages('user_1')).thenAnswer((_) async => cached);
      when(mockRemote.fetchHistory()).thenAnswer((_) async => remote);
      when(mockLocal.upsertMessages(any, any)).thenAnswer((_) async => {});

      final result = await buildRepo().getHistory();
      result.fold(
        (f) => fail('expected Right, got $f'),
        (list) => expect(list.map((m) => m.id), ['remote_1', 'remote_2']),
      );
      verify(mockLocal.upsertMessages('user_1', remote)).called(1);
    });

    test('падіння remote → fallback на кеш', () async {
      when(mockLocal.getMessages('user_1')).thenAnswer((_) async => cached);
      when(mockRemote.fetchHistory()).thenThrow(Exception('no net'));

      final result = await buildRepo().getHistory();
      result.fold(
        (f) => fail('expected Right, got $f'),
        (list) => expect(list.length, 1),
      );
    });

    test('немає сесії → AuthFailure', () async {
      when(mockAuth.currentUser).thenReturn(null);
      final result = await buildRepo().getHistory();
      expect(result.isLeft(), true);
    });

    test('remote порожній → повертаємо кеш', () async {
      when(mockLocal.getMessages('user_1')).thenAnswer((_) async => cached);
      when(mockRemote.fetchHistory())
          .thenAnswer((_) async => <ChatMessageModel>[]);

      final result = await buildRepo().getHistory();
      result.fold(
        (_) => fail('expected Right'),
        (list) => expect(list.first.id, 'cache_1'),
      );
    });
  });

  group('sendMessage', () {
    test('rate-limit → RateLimitFailure', () async {
      when(mockRemote.sendMessage(text: anyNamed('text'), history: anyNamed('history')))
          .thenThrow(ChatRateLimitException('Ліміт'));

      final result = await buildRepo().sendMessage(text: 'q', history: []);
      result.fold(
        (f) => expect(f, isA<RateLimitFailure>()),
        (_) => fail('expected Left'),
      );
    });

    test('успіх → кешуємо user + assistant локально', () async {
      when(mockRemote.sendMessage(text: anyNamed('text'), history: anyNamed('history')))
          .thenAnswer((_) async => const ChatSendApiResult(
                reply: 'Відповідь',
                remainingToday: 29,
              ));
      when(mockLocal.upsertMessages(any, any)).thenAnswer((_) async => {});

      final result = await buildRepo().sendMessage(text: 'Що таке MARCH?', history: []);
      result.fold(
        (f) => fail('expected Right, got $f'),
        (r) {
          expect(r.assistantMessage.content, 'Відповідь');
          expect(r.remainingToday, 29);
        },
      );
      verify(mockLocal.upsertMessages('user_1', argThat(hasLength(2)))).called(1);
    });

    test('порожній text → ValidationFailure', () async {
      final result = await buildRepo().sendMessage(text: '   ', history: []);
      expect(result.isLeft(), true);
      verifyNever(mockRemote.sendMessage(
        text: anyNamed('text'),
        history: anyNamed('history'),
      ));
    });
  });
}
