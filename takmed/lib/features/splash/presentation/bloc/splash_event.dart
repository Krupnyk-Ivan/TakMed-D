import 'package:equatable/equatable.dart';

/// Базова подія splash screen.
abstract class SplashEvent extends Equatable {
  /// Створює базову подію.
  const SplashEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Подія запуску splash screen.
class SplashStarted extends SplashEvent {
  /// Створює подію запуску.
  const SplashStarted();
}
