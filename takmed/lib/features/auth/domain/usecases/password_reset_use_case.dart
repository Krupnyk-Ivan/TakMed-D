import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

/// Сценарій скидання пароля.
class PasswordResetUseCase {
  /// Створює сценарій скидання пароля.
  const PasswordResetUseCase(this._repository);

  final AuthRepository _repository;

  /// Виконує скидання пароля та повертає результат.
  Future<Either<Failure, Unit>> call(PasswordResetParams params) {
    return _repository.resetPassword(email: params.email);
  }
}

/// Параметри сценарію скидання пароля.
class PasswordResetParams extends Equatable {
  /// Створює параметри скидання пароля.
  const PasswordResetParams({required this.email});

  /// Email користувача.
  final String email;

  @override
  List<Object?> get props => <Object?>[email];
}
