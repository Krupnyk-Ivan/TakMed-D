import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

/// Сценарій виходу користувача.
class LogoutUseCase {
  /// Створює сценарій виходу.
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  /// Виконує вихід та повертає результат.
  Future<Either<Failure, Unit>> call() {
    return _repository.logout();
  }
}
