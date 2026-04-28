import 'package:equatable/equatable.dart';

/// Доменна сутність авторизованого користувача.
class AuthUser extends Equatable {
  /// Створює сутність користувача.
  const AuthUser({
    required this.id,
    required this.email,
    required this.name,
    required this.token,
  });

  /// Ідентифікатор користувача.
  final String id;

  /// Email користувача.
  final String email;

  /// Ім'я користувача.
  final String name;

  /// Маркер доступу (access token).
  final String token;

  @override
  List<Object?> get props => <Object?>[id, email, name, token];
}
