import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// Сценарій реєстрації нового користувача.
class SignUpUseCase {
  /// Створює сценарій реєстрації.
  const SignUpUseCase(this._repository);

  final AuthRepository _repository;

  /// Виконує реєстрацію та повертає результат.
  Future<Either<Failure, AuthUser>> call(SignUpParams params) {
    return _repository.signUp(
      email: params.email,
      password: params.password,
      name: params.name,
    );
  }
}

/// Параметри сценарію реєстрації.
class SignUpParams extends Equatable {
  /// Створює параметри реєстрації.
  const SignUpParams({
    required this.email,
    required this.password,
    required this.name,
  });

  /// Email користувача.
  final String email;

  /// Пароль користувача.
  final String password;

  /// Ім'я користувача.
  final String name;

  @override
  List<Object?> get props => <Object?>[email, password, name];
}
