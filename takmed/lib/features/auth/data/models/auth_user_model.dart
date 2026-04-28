import '../../domain/entities/auth_user.dart';

/// Модель даних користувача авторизації.
class AuthUserModel extends AuthUser {
  /// Створює модель користувача.
  const AuthUserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.token,
  });

  /// Створює модель з JSON.
  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      token: json['token'] as String? ?? '',
    );
  }

  /// Перетворює модель в JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'token': token,
    };
  }
}
