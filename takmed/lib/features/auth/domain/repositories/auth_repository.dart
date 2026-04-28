import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_user.dart';

/// Контракт репозиторія авторизації.
abstract class AuthRepository {
  /// Виконує вхід за email та паролем.
  Future<Either<Failure, AuthUser>> signIn({
    required String email,
    required String password,
  });

  /// Виконує реєстрацію нового користувача.
  Future<Either<Failure, AuthUser>> signUp({
    required String email,
    required String password,
    required String name,
  });

  /// Відправляє лист скидання пароля на email.
  Future<Either<Failure, Unit>> resetPassword({required String email});

  /// Виконує вихід користувача.
  Future<Either<Failure, Unit>> logout();

  /// Оновлює маркер доступу.
  Future<Either<Failure, AuthUser>> refreshToken();

  /// Перевіряє, чи користувач авторизований.
  Future<bool> isAuthenticated();

  /// Отримує збережену інформацію про користувача.
  Future<AuthUser?> getCurrentUser();
}
