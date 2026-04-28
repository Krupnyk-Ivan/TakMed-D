import 'package:equatable/equatable.dart';
import '../../domain/entities/user_track.dart';

/// Базова подія онбордингу.
abstract class OnboardingEvent extends Equatable {
  /// Створює базову подію.
  const OnboardingEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Подія запуску онбордингу.
class OnboardingStarted extends OnboardingEvent {
  /// Створює подію запуску.
  const OnboardingStarted();
}

/// Подія зміни сторінки онбордингу.
class OnboardingPageChanged extends OnboardingEvent {
  /// Створює подію зміни сторінки.
  const OnboardingPageChanged(this.page);

  /// Номер поточної сторінки.
  final int page;

  @override
  List<Object?> get props => <Object?>[page];
}

/// Подія вибору треку.
class OnboardingTrackSelected extends OnboardingEvent {
  /// Створює подію вибору треку.
  const OnboardingTrackSelected(this.track);

  /// Вибраний трек.
  final UserTrack track;

  @override
  List<Object?> get props => <Object?>[track];
}

/// Подія завершення онбордингу.
class OnboardingCompleted extends OnboardingEvent {
  /// Створює подію завершення.
  const OnboardingCompleted();
}
