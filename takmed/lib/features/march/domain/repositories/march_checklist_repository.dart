import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

/// Контракт репозиторію операційного чекліста MARCH.
abstract class MarchChecklistRepository {
  /// Зберігає результати завершеної MARCH-сесії у локальну БД (is_dirty = true).
  Future<Either<Failure, void>> saveSession({
    required DateTime startedAt,
    required int totalDurationSeconds,
    required int successRatePercent,
    required List<String> weakTopics,
    required String itemsJson,
  });
}
