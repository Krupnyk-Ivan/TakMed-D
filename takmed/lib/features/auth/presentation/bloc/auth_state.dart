import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_user.dart';

/// Можливі статуси авторизації.
enum AuthStatus {
  /// Початковий статус.
  initial,

  /// Виконується операція.
  loading,

  /// Операція успішна.
  success,

  /// Помилка операції.
  failure,

  /// Користувач авторизований.
  authenticated,

  /// Користувач не авторизований.
  unauthenticated,

  /// Гостьовий (локальний) режим.
  guest,
}

/// Стан авторизації.
class AuthState extends Equatable {
  /// Створює стан авторизації.
  const AuthState({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.name = '',
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.user,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.nameError,
  });

  /// Введений email.
  final String email;

  /// Введений пароль.
  final String password;

  /// Підтвердження пароля.
  final String confirmPassword;

  /// Ім'я користувача.
  final String name;

  /// Статус авторизації.
  final AuthStatus status;

  /// Текст помилки.
  final String? errorMessage;

  /// Інформація про користувача.
  final AuthUser? user;

  /// Помилка валідації email.
  final String? emailError;

  /// Помилка валідації пароля.
  final String? passwordError;

  /// Помилка валідації підтвердження пароля.
  final String? confirmPasswordError;

  /// Помилка валідації імені.
  final String? nameError;

  /// Повертає копію стану зі змінами.
  AuthState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    String? name,
    AuthStatus? status,
    String? errorMessage,
    AuthUser? user,
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
    String? nameError,
    bool clearEmailError = false,
    bool clearPasswordError = false,
    bool clearConfirmPasswordError = false,
    bool clearNameError = false,
  }) {
    return AuthState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      name: name ?? this.name,
      status: status ?? this.status,
      errorMessage: errorMessage,
      user: user ?? this.user,
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      passwordError:
          clearPasswordError ? null : (passwordError ?? this.passwordError),
      confirmPasswordError: clearConfirmPasswordError
          ? null
          : (confirmPasswordError ?? this.confirmPasswordError),
      nameError: clearNameError ? null : (nameError ?? this.nameError),
    );
  }

  @override
  List<Object?> get props => <Object?>[
    email,
    password,
    confirmPassword,
    name,
    status,
    errorMessage,
    user,
    emailError,
    passwordError,
    confirmPasswordError,
    nameError,
  ];
}
