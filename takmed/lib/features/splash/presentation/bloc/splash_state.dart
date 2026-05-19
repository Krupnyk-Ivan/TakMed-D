import 'package:equatable/equatable.dart';

/// Можливі стани splash screen.
enum SplashStatus {
  /// Початковий стан — показується анімація.
  initial,

  /// Перевірка стану.
  checking,

  /// Перенаправлення на онбординг.
  navigateToOnboarding,

  /// Перенаправлення на головну.
  navigateToHome,

  /// Перенаправлення на логін.
  navigateToLogin,

  /// Перенаправлення на адмін-панель.
  navigateToAdmin,
}

/// Стан splash screen.
class SplashState extends Equatable {
  /// Створює стан splash screen.
  const SplashState({this.status = SplashStatus.initial});

  /// Поточний статус.
  final SplashStatus status;

  /// Повертає копію стану зі змінами.
  SplashState copyWith({SplashStatus? status}) {
    return SplashState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => <Object?>[status];
}
