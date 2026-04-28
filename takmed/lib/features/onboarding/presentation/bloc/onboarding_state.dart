import 'package:equatable/equatable.dart';
import '../../domain/entities/user_track.dart';

/// Можливі статуси онбордингу.
enum OnboardingStatus {
  /// Початковий стан.
  initial,

  /// Завантаження.
  loading,

  /// Завершено — можна переходити далі.
  completed,

  /// Помилка.
  error,
}

/// Стан онбордингу.
class OnboardingState extends Equatable {
  /// Створює стан онбордингу.
  const OnboardingState({
    this.currentPage = 0,
    this.selectedTrack,
    this.status = OnboardingStatus.initial,
    this.errorMessage,
  });

  /// Поточна сторінка PageView.
  final int currentPage;

  /// Вибраний трек (null якщо не вибрано).
  final UserTrack? selectedTrack;

  /// Статус онбордингу.
  final OnboardingStatus status;

  /// Повідомлення про помилку.
  final String? errorMessage;

  /// Чи остання сторінка.
  bool get isLastPage => currentPage == 2;

  /// Чи можна завершити (трек вибрано).
  bool get canComplete => selectedTrack != null;

  /// Повертає копію стану зі змінами.
  OnboardingState copyWith({
    int? currentPage,
    UserTrack? selectedTrack,
    OnboardingStatus? status,
    String? errorMessage,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      selectedTrack: selectedTrack ?? this.selectedTrack,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    currentPage,
    selectedTrack,
    status,
    errorMessage,
  ];
}
