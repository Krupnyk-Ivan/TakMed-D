import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../gamification/data/services/gamification_service.dart';
import '../../../learning/domain/repositories/learning_repository.dart';
import '../../domain/entities/march_item.dart';
import '../../domain/entities/march_quiz_question.dart';
import '../../domain/entities/march_session.dart';
import '../../domain/repositories/march_repository.dart';
import 'march_educational_event.dart';
import 'march_educational_state.dart';

/// XP за правильну відповідь на крок.
const int _xpPerCorrectStep = 20;

class MarchEducationalBloc
    extends Bloc<MarchEducationalEvent, MarchEducationalState> {
  MarchEducationalBloc(
    this._repository,
    this._gamification,
    this._learningRepository, {
    this.lessonId,
  }) : super(const MarchEducationalState()) {
    on<MarchSessionStarted>(_onStarted);
    on<MarchHintToggled>(_onHintToggled);
    on<MarchStepCompleteRequested>(_onCompleteRequested);
    on<MarchQuizAnswered>(_onQuizAnswered);
    on<MarchQuizDismissAfterFailure>(_onQuizDismissAfterFailure);
    on<MarchTimerTicked>(_onTimerTick);
    on<MarchSessionReset>(_onReset);
  }

  final MarchRepository _repository;
  final GamificationService _gamification;
  final LearningRepository _learningRepository;
  final int? lessonId;
  Timer? _timer;

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => add(const MarchTimerTicked()),
    );
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> close() {
    _stopTimer();
    return super.close();
  }

  // ─── Handlers ────────────────────────────────────────────────────

  Future<void> _onStarted(
    MarchSessionStarted event,
    Emitter<MarchEducationalState> emit,
  ) async {
    final session = MarchSession.fresh();
    emit(MarchEducationalState(
      status: MarchEducationalStatus.running,
      session: session,
    ));
    _startTimer();
  }

  void _onHintToggled(
    MarchHintToggled event,
    Emitter<MarchEducationalState> emit,
  ) {
    emit(state.copyWith(hintExpanded: !state.hintExpanded));
  }

  void _onCompleteRequested(
    MarchStepCompleteRequested event,
    Emitter<MarchEducationalState> emit,
  ) {
    final session = state.session;
    if (session == null) return;
    final active = session.activeItem;
    if (active == null) return;

    // Зупиняємо таймер під час квізу — час не повинен капати поки користувач думає.
    _stopTimer();
    emit(state.copyWith(
      status: MarchEducationalStatus.quizActive,
      activeQuiz: MarchQuizQuestion.forStep(active.step),
      hintExpanded: false,
      clearSelected: true,
      clearError: true,
    ));
  }

  Future<void> _onQuizAnswered(
    MarchQuizAnswered event,
    Emitter<MarchEducationalState> emit,
  ) async {
    final session = state.session;
    final quiz = state.activeQuiz;
    if (session == null || quiz == null) return;

    final isCorrect = event.selectedIndex == quiz.correctIndex;
    final activeIdx = session.activeIndex;
    if (activeIdx == -1) return;

    final items = [...session.items];
    final current = items[activeIdx];
    final updatedCurrent = current.copyWith(
      quizAttempts: current.quizAttempts + 1,
      quizAnsweredCorrectly: isCorrect ? true : false,
      status: isCorrect
          ? MarchItemStatus.completed
          : MarchItemStatus.failedQuiz,
    );
    items[activeIdx] = updatedCurrent;

    if (isCorrect) {
      // Розблоковуємо наступний крок (якщо є).
      final nextIdx = activeIdx + 1;
      if (nextIdx < items.length) {
        items[nextIdx] = items[nextIdx].copyWith(status: MarchItemStatus.active);
      }
      // Нараховуємо XP.
      await _gamification.awardXp(_xpPerCorrectStep);

      final newSession = session.copyWith(items: items);
      final allDone = newSession.activeIndex == -1;

      if (allDone) {
        final finished = newSession.copyWith(endedAt: DateTime.now());
        emit(state.copyWith(
          status: MarchEducationalStatus.finished,
          session: finished,
          totalXpAwarded: state.totalXpAwarded + _xpPerCorrectStep,
          clearQuiz: true,
          clearSelected: true,
        ));
        await _persistSession(emit, finished);
      } else {
        emit(state.copyWith(
          status: MarchEducationalStatus.running,
          session: newSession,
          totalXpAwarded: state.totalXpAwarded + _xpPerCorrectStep,
          clearQuiz: true,
          clearSelected: true,
        ));
        _startTimer();
      }
    } else {
      // Невірно — лишаємось у quizFailed, дозволяємо retry.
      emit(state.copyWith(
        status: MarchEducationalStatus.quizFailed,
        session: session.copyWith(items: items),
        selectedQuizIndex: event.selectedIndex,
      ));
    }
  }

  Future<void> _onQuizDismissAfterFailure(
    MarchQuizDismissAfterFailure event,
    Emitter<MarchEducationalState> emit,
  ) async {
    final session = state.session;
    if (session == null) return;
    if (state.status != MarchEducationalStatus.quizFailed) return;

    // Активного кроку вже немає (поточний помічено як failedQuiz).
    // Шукаємо останній failed/completed і активуємо наступний.
    int lastResolvedIdx = -1;
    for (var i = 0; i < session.items.length; i++) {
      final s = session.items[i].status;
      if (s == MarchItemStatus.completed ||
          s == MarchItemStatus.failedQuiz) {
        lastResolvedIdx = i;
      }
    }
    if (lastResolvedIdx == -1) return;

    final items = [...session.items];
    final nextIdx = lastResolvedIdx + 1;
    if (nextIdx < items.length) {
      items[nextIdx] =
          items[nextIdx].copyWith(status: MarchItemStatus.active);
    }
    final newSession = session.copyWith(items: items);
    final allDone = newSession.activeIndex == -1;

    if (allDone) {
      final finished = newSession.copyWith(endedAt: DateTime.now());
      emit(state.copyWith(
        status: MarchEducationalStatus.finished,
        session: finished,
        clearQuiz: true,
        clearSelected: true,
      ));
      await _persistSession(emit, finished);
    } else {
      emit(state.copyWith(
        status: MarchEducationalStatus.running,
        session: newSession,
        clearQuiz: true,
        clearSelected: true,
      ));
      _startTimer();
    }
  }

  void _onTimerTick(
    MarchTimerTicked event,
    Emitter<MarchEducationalState> emit,
  ) {
    final session = state.session;
    if (session == null) return;
    if (state.status != MarchEducationalStatus.running) return;

    final activeIdx = session.activeIndex;
    if (activeIdx == -1) return;

    final items = [...session.items];
    items[activeIdx] = items[activeIdx].copyWith(
      elapsedSeconds: items[activeIdx].elapsedSeconds + 1,
    );
    emit(state.copyWith(session: session.copyWith(items: items)));
  }

  Future<void> _onReset(
    MarchSessionReset event,
    Emitter<MarchEducationalState> emit,
  ) async {
    _stopTimer();
    emit(const MarchEducationalState());
    add(const MarchSessionStarted());
  }

  // ─── Persistence ─────────────────────────────────────────────────

  Future<void> _persistSession(
    Emitter<MarchEducationalState> emit,
    MarchSession session,
  ) async {
    emit(state.copyWith(status: MarchEducationalStatus.saving));

    // 1. Зберігаємо детальну історію MARCH
    final result = await _repository.saveSession(session);

    // 2. Якщо це урок, позначаємо його як завершений з реальним відсотком
    if (lessonId != null) {
      await _learningRepository.completeLesson(
        lessonId!,
        session.successRatePercent,
      );
    }

    result.fold(
      (failure) => emit(state.copyWith(
        status: MarchEducationalStatus.finished,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: MarchEducationalStatus.saved)),
    );
  }
}
