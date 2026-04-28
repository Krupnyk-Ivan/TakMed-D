import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// Сценарій входу користувача.
class SignInUseCase {
  /// Створює сценарій входу.
  const SignInUseCase(this._repository);

  final AuthRepository _repository;

  /// Виконує вхід та повертає результат.
  Future<Either<Failure, AuthUser>> call(SignInParams params) {
    return _repository.signIn(email: params.email, password: params.password);
  }
}

/// Параметри сценарію входу.
class SignInParams extends Equatable {
  /// Створює параметри входу.
  const SignInParams({required this.email, required this.password});

  /// Email користувача.
  final String email;

  /// Пароль користувача.
  final String password;

  @override
  List<Object?> get props => <Object?>[email, password];
}
