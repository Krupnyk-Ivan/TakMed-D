import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/database/daos/march_history_dao.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/march_session.dart';
import '../../domain/repositories/march_repository.dart';

class MarchRepositoryImpl implements MarchRepository {
  MarchRepositoryImpl(this._dao, this._client);
  final MarchHistoryDao _dao;
  final SupabaseClient _client;

  @override
  Future<Either<Failure, int>> saveSession(MarchSession session) async {
    try {
      final userId = _client.auth.currentUser?.id ?? '';

      final weakTopics = session.weakSpots.map((s) => s.code).toList();
      final itemsPayload = session.items
          .map((it) => {
                'step': it.step.code,
                'status': it.status.name,
                'elapsedSeconds': it.elapsedSeconds,
                'quizAttempts': it.quizAttempts,
                'quizAnsweredCorrectly': it.quizAnsweredCorrectly,
              })
          .toList();

      final id = await _dao.insertSession(
        MarchHistoryCompanion(
          userId: Value(userId),
          startedAt: Value(session.startedAt),
          totalDurationSeconds: Value(session.totalDurationSeconds),
          successRate: Value(session.successRatePercent),
          weakTopics: Value(jsonEncode(weakTopics)),
          itemsJson: Value(jsonEncode(itemsPayload)),
        ),
      );
      return Right(id);
    } catch (e) {
      return Left(CacheFailure('Не вдалося зберегти MARCH-сесію: $e'));
    }
  }
}
