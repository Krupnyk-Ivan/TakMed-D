import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../onboarding/domain/repositories/onboarding_repository.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../learning/domain/repositories/learning_repository.dart';
import 'splash_event.dart';
import 'splash_state.dart';

/// BLoC splash screen — перевіряє стан та визначає маршрут.
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  /// Створює BLoC splash screen.
  SplashBloc(
    this._onboardingRepository,
    this._authRepository,
    this._learningRepository,
  ) : super(const SplashState()) {
    on<SplashStarted>(_onStarted);
  }

  final OnboardingRepository _onboardingRepository;
  final AuthRepository _authRepository;
  final LearningRepository _learningRepository;

  Future<void> _onStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    emit(state.copyWith(status: SplashStatus.checking));

    // Затримка для анімації splash
    await Future<void>.delayed(const Duration(milliseconds: 1500));

    // 1. Перевіряє, чи онбординг пройдений
    final onboardingCompleted =
        await _onboardingRepository.isOnboardingCompleted();

    if (!onboardingCompleted) {
      emit(state.copyWith(status: SplashStatus.navigateToOnboarding));
      return;
    }

    // 2. Перевіряє, чи є валідний токен
    final isAuthenticated = await _authRepository.isAuthenticated();

    if (isAuthenticated) {
      unawaited(_runInitialSync());
      emit(state.copyWith(status: SplashStatus.navigateToHome));
    } else {
      emit(state.copyWith(status: SplashStatus.navigateToLogin));
    }
  }

  Future<void> _runInitialSync() async {
    try {
      await _learningRepository.syncWithServer().timeout(
        const Duration(seconds: 8),
      );
    } catch (_) {
      // Fail-soft: не блокуємо навігацію через проблеми синхронізації.
    }
  }
}
