import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// Сценарій оновлення маркера доступу.
class TokenRefreshUseCase {
  /// Створює сценарій оновлення маркера.
  const TokenRefreshUseCase(this._repository);

  final AuthRepository _repository;

  /// Виконує оновлення маркера та повертає результат.
  Future<Either<Failure, AuthUser>> call() {
    return _repository.refreshToken();
  }
}
