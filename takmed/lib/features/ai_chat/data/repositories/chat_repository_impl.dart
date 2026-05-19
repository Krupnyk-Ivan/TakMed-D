import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/chat_send_result.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_data_source.dart';
import '../datasources/chat_remote_data_source.dart';
import '../models/chat_message_model.dart';

/// Failure для перевищення rate-limit (UI може показати окремий banner).
class RateLimitFailure extends Failure {
  const RateLimitFailure(super.message);
}

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(this._remote, this._local, this._supabaseClient);

  final ChatRemoteDataSource _remote;
  final ChatLocalDataSource _local;
  final SupabaseClient _supabaseClient;

  String? _userId() => _supabaseClient.auth.currentUser?.id;

  @override
  Future<Either<Failure, List<ChatMessageEntity>>> getHistory() async {
    final userId = _userId();
    if (userId == null) {
      return const Left(AuthFailure('Користувача не авторизовано'));
    }

    // 1. Беремо локальний кеш
    final cached = await _local.getMessages(userId);

    // 2. Паралельно тягнемо з Supabase і оновлюємо кеш
    try {
      final remote = await _remote.fetchHistory();
      // Кешуємо новіші
      if (remote.isNotEmpty) {
        await _local.upsertMessages(userId, remote);
      }
      return Right(_dedupSort(remote.isEmpty ? cached : remote));
    } catch (_) {
      // Якщо мережі немає — повертаємо кеш
      return Right(_dedupSort(cached));
    }
  }

  @override
  Future<Either<Failure, ChatSendResult>> sendMessage({
    required String text,
    required List<ChatMessageEntity> history,
  }) async {
    final userId = _userId();
    if (userId == null) {
      return const Left(AuthFailure('Користувача не авторизовано'));
    }
    if (text.trim().isEmpty) {
      return const Left(ValidationFailure('Порожнє повідомлення'));
    }

    try {
      final apiResult = await _remote.sendMessage(
        text: text.trim(),
        history: history,
      );

      // Закешуємо обидва повідомлення локально.
      final now = DateTime.now().toUtc();
      final userMsg = ChatMessageModel(
        id: 'local_user_${now.microsecondsSinceEpoch}',
        role: 'user',
        content: text.trim(),
        createdAt: now,
      );
      final assistantMsg = ChatMessageModel(
        id: 'local_asst_${now.microsecondsSinceEpoch + 1}',
        role: 'assistant',
        content: apiResult.reply,
        createdAt: now.add(const Duration(milliseconds: 1)),
      );
      await _local.upsertMessages(userId, [userMsg, assistantMsg]);

      return Right(ChatSendResult(
        assistantMessage: assistantMsg,
        remainingToday: apiResult.remainingToday,
      ));
    } on ChatRateLimitException catch (e) {
      return Left(RateLimitFailure(e.message));
    } on AppAuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(NetworkFailure('Не вдалося надіслати повідомлення: $e'));
    }
  }

  List<ChatMessageEntity> _dedupSort(List<ChatMessageEntity> input) {
    final seen = <String>{};
    final result = <ChatMessageEntity>[];
    for (final m in input) {
      if (seen.add(m.id)) result.add(m);
    }
    result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return result;
  }
}
