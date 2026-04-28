import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/save_track_use_case.dart';
import '../../domain/usecases/get_track_use_case.dart';
import '../../domain/usecases/complete_onboarding_use_case.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

/// BLoC онбордингу.
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  /// Створює BLoC онбордингу.
  OnboardingBloc(
    this._saveTrackUseCase,
    this._getTrackUseCase,
    this._completeOnboardingUseCase,
  ) : super(const OnboardingState()) {
    on<OnboardingStarted>(_onStarted);
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingTrackSelected>(_onTrackSelected);
    on<OnboardingCompleted>(_onCompleted);
  }

  final SaveTrackUseCase _saveTrackUseCase;
  final GetTrackUseCase _getTrackUseCase;
  final CompleteOnboardingUseCase _completeOnboardingUseCase;

  Future<void> _onStarted(
    OnboardingStarted event,
    Emitter<OnboardingState> emit,
  ) async {
    // Відновлює раніше збережений трек (якщо є)
    final result = await _getTrackUseCase();
    result.fold(
      (_) => null, // ігноруємо помилку — просто не відновлюємо
      (track) {
        if (track != null) {
          emit(state.copyWith(selectedTrack: track));
        }
      },
    );
  }

  void _onPageChanged(
    OnboardingPageChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(currentPage: event.page));
  }

  Future<void> _onTrackSelected(
    OnboardingTrackSelected event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(state.copyWith(
      selectedTrack: event.track,
      status: OnboardingStatus.loading,
    ));

    // Зберігає трек у SharedPreferences
    final result = await _saveTrackUseCase(event.track);

    result.fold(
      (failure) => emit(state.copyWith(
        status: OnboardingStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: OnboardingStatus.initial)),
    );
  }

  Future<void> _onCompleted(
    OnboardingCompleted event,
    Emitter<OnboardingState> emit,
  ) async {
    if (!state.canComplete) return;

    emit(state.copyWith(status: OnboardingStatus.loading));

    final result = await _completeOnboardingUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: OnboardingStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: OnboardingStatus.completed)),
    );
  }
}
