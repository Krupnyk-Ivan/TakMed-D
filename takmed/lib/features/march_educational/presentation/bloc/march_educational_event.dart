import 'package:equatable/equatable.dart';

abstract class MarchEducationalEvent extends Equatable {
  const MarchEducationalEvent();
  @override
  List<Object?> get props => [];
}

/// Розпочати нову сесію.
class MarchSessionStarted extends MarchEducationalEvent {
  const MarchSessionStarted();
}

/// Toggle "шпаргалки" для активного кроку.
class MarchHintToggled extends MarchEducationalEvent {
  const MarchHintToggled();
}

/// Користувач натиснув "Завершити крок" — відкривається мікро-квіз.
class MarchStepCompleteRequested extends MarchEducationalEvent {
  const MarchStepCompleteRequested();
}

/// Відповідь у мікро-квізі.
class MarchQuizAnswered extends MarchEducationalEvent {
  const MarchQuizAnswered(this.selectedIndex);
  final int selectedIndex;
  @override
  List<Object?> get props => [selectedIndex];
}

/// Закрити пояснення після неправильної відповіді та продовжити —
/// поточний крок лишається з позначкою `failedQuiz`, активується наступний.
class MarchQuizDismissAfterFailure extends MarchEducationalEvent {
  const MarchQuizDismissAfterFailure();
}

/// Tick таймера (1 секунда) — інкрементує elapsedSeconds активного кроку.
class MarchTimerTicked extends MarchEducationalEvent {
  const MarchTimerTicked();
}

/// Скинути сесію (з результатного екрану — пройти ще раз).
class MarchSessionReset extends MarchEducationalEvent {
  const MarchSessionReset();
}
