import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/database/daos/march_history_dao.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/march_checklist_repository.dart';

class MarchChecklistRepositoryImpl implements MarchChecklistRepository {
  MarchChecklistRepositoryImpl(this._dao, this._client);

  final MarchHistoryDao _dao;
  final SupabaseClient _client;

  @override
  Future<Either<Failure, void>> saveSession({
    required DateTime startedAt,
    required int totalDurationSeconds,
    required int successRatePercent,
    required List<String> weakTopics,
    required String itemsJson,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id ?? '';
      await _dao.insertSession(
        MarchHistoryCompanion(
          userId: Value(userId),
          startedAt: Value(startedAt),
          totalDurationSeconds: Value(totalDurationSeconds),
          successRate: Value(successRatePercent),
          weakTopics: Value(jsonEncode(weakTopics)),
          itemsJson: Value(itemsJson),
        ),
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Не вдалося зберегти MARCH-сесію: $e'));
    }
  }
}
