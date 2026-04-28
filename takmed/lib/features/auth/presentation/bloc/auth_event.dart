import 'package:equatable/equatable.dart';

/// Базова подія авторизації.
abstract class AuthEvent extends Equatable {
  /// Створює базову подію.
  const AuthEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Подія зміни email.
class AuthEmailChanged extends AuthEvent {
  /// Створює подію зміни email.
  const AuthEmailChanged(this.email);

  /// Нове значення email.
  final String email;

  @override
  List<Object?> get props => <Object?>[email];
}

/// Подія зміни пароля.
class AuthPasswordChanged extends AuthEvent {
  /// Створює подію зміни пароля.
  const AuthPasswordChanged(this.password);

  /// Нове значення пароля.
  final String password;

  @override
  List<Object?> get props => <Object?>[password];
}

/// Подія зміни підтвердження пароля.
class AuthConfirmPasswordChanged extends AuthEvent {
  /// Створює подію зміни підтвердження пароля.
  const AuthConfirmPasswordChanged(this.confirmPassword);

  /// Нове значення підтвердження пароля.
  final String confirmPassword;

  @override
  List<Object?> get props => <Object?>[confirmPassword];
}

/// Подія зміни імені користувача.
class AuthNameChanged extends AuthEvent {
  /// Створює подію зміни імені.
  const AuthNameChanged(this.name);

  /// Нове значення імені.
  final String name;

  @override
  List<Object?> get props => <Object?>[name];
}

/// Подія відправки форми входу.
class AuthSignInSubmitted extends AuthEvent {
  /// Створює подію відправки форми.
  const AuthSignInSubmitted();
}

/// Подія відправки форми реєстрації.
class AuthSignUpSubmitted extends AuthEvent {
  /// Створює подію відправки форми реєстрації.
  const AuthSignUpSubmitted();
}

/// Подія скидання пароля.
class AuthPasswordResetSubmitted extends AuthEvent {
  /// Створює подію скидання пароля.
  const AuthPasswordResetSubmitted();
}

/// Подія виходу користувача.
class AuthLogoutSubmitted extends AuthEvent {
  /// Створює подію виходу.
  const AuthLogoutSubmitted();
}

/// Подія перевірки авторизації.
class AuthCheckRequested extends AuthEvent {
  /// Створює подію перевірки авторизації.
  const AuthCheckRequested();
}

/// Подія скидання полів форми.
class AuthResetFormFields extends AuthEvent {
  /// Створює подію скидання полів форми.
  const AuthResetFormFields();
}

/// Подія запиту гостьового (локального) режиму.
class AuthGuestModeRequested extends AuthEvent {
  /// Створює подію гостьового режиму.
  const AuthGuestModeRequested();
}
