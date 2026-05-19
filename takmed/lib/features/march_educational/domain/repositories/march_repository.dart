import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/march_session.dart';

/// Контракт репозиторію для збереження тренувальних MARCH-сесій.
abstract class MarchRepository {
  /// Зберігає завершену сесію у локальну БД (Drift) з `is_dirty = true`
  /// для подальшої синхронізації.
  Future<Either<Failure, int>> saveSession(MarchSession session);
}
