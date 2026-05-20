import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/march_step.dart';
import '../../domain/models/march_step_state.dart';
import '../../domain/repositories/march_checklist_repository.dart';
import 'march_checklist_state.dart';
import 'march_event.dart';

// ─── Internal event ───────────────────────────────────────────────────────────

/// Внутрішня подія — генерується таймером BLoC, недоступна ззовні.
/// Визначена у тому самому файлі щоб не виходити за межі бібліотеки.
final class _MarchStepTimedOut extends MarchEvent {
  final MarchStep step;
  const _MarchStepTimedOut(this.step);

  @override
  List<Object?> get props => [step];
}

// ─── BLoC ─────────────────────────────────────────────────────────────────────

/// BLoC протоколу MARCH.
///
/// Гарантії:
/// • Крок N не може бути розпочатий/завершений поки попередній крок (N-1)
///   не має статус [StepCompleted] або [StepSkipped].
/// • Якщо [maxTimeSeconds] кроку вичерпано — крок автоматично переходить у [StepFailed].
/// • Відкат [MarchRollbackRequested] дозволений тільки коли всі наступні кроки
///   у стані [StepPending] або [StepFailed].
///
/// Для тестів інжектуйте [timerDurationOverride] щоб пришвидшити таймаути.
class MarchBloc extends Bloc<MarchEvent, MarchChecklistState> {
  /// Фабрика тривалості таймера.
  final Duration Function(MarchStep step) timerDurationFor;

  final MarchChecklistRepository? _repository;
  final Map<MarchStep, Timer> _timers = {};

  /// Час запуску поточної сесії — фіксується у [_onStarted].
  DateTime? _sessionStartedAt;

  MarchBloc({
    MarchChecklistRepository? repository,
    Duration Function(MarchStep)? timerDurationOverride,
  })  : _repository = repository,
        timerDurationFor = timerDurationOverride ??
            ((step) => Duration(seconds: step.defaultMaxTimeSeconds)),
        super(MarchChecklistState.initial()) {
    on<MarchStarted>(_onStarted);
    on<MarchReset>(_onReset);
    on<MarchStepStartRequested>(_onStepStartRequested);
    on<MarchStepCompletionRequested>(_onStepCompletionRequested);
    on<MarchStepFailureReported>(_onStepFailureReported);
    on<MarchStepSkipRequested>(_onStepSkipRequested);
    on<MarchRollbackRequested>(_onRollbackRequested);
    on<_MarchStepTimedOut>(_onTimedOut);
  }

  // ─── Handlers ─────────────────────────────────────────────────────────────

  void _onStarted(MarchStarted event, Emitter<MarchChecklistState> emit) {
    _cancelAllTimers();
    _sessionStartedAt = DateTime.now();
    emit(MarchChecklistState.initial(maxTimeOverrides: event.maxTimeOverrides)
        .copyWith(overallStatus: MarchOverallStatus.inProgress));

    // Автоматично стартуємо перший крок M
    add(const MarchStepStartRequested(MarchStep.massiveHemorrhage));
  }

  void _onReset(MarchReset event, Emitter<MarchChecklistState> emit) {
    _cancelAllTimers();
    emit(MarchChecklistState.initial());
  }

  void _onStepStartRequested(
    MarchStepStartRequested event,
    Emitter<MarchChecklistState> emit,
  ) {
    final step = event.step;

    if (!state.canActivate(step)) {
      final prereq = step.prerequisite;
      emit(state.copyWith(
        validationError: prereq != null
            ? 'Неможливо розпочати "${step.label}": '
                'спочатку завершіть "${prereq.label}" (${prereq.code})'
            : 'Крок "${step.label}" вже виконується або завершено',
      ));
      return;
    }

    _startTimer(step, state[step].maxTimeSeconds);

    emit(state
        .withStep(
          step,
          StepInProgress(
            maxTimeSeconds: state[step].maxTimeSeconds,
            startedAt: DateTime.now(),
          ),
        )
        .copyWith(
          overallStatus: MarchOverallStatus.inProgress,
          clearError: true,
        ));
  }

  void _onStepCompletionRequested(
    MarchStepCompletionRequested event,
    Emitter<MarchChecklistState> emit,
  ) {
    final step = event.step;

    // ── Правило 1: крок має бути InProgress ──
    if (state[step] is! StepInProgress) {
      emit(state.copyWith(
        validationError: 'Крок "${step.label}" не є активним',
      ));
      return;
    }

    // ── Правило 2: попередній крок має бути успішним ──
    if (!state.canComplete(step)) {
      final prereq = step.prerequisite!;
      emit(state.copyWith(
        validationError: 'Неможливо завершити "${step.label}": '
            '"${prereq.label}" (${prereq.code}) не виконано',
      ));
      return;
    }

    _cancelTimer(step);

    final inProgress = state[step] as StepInProgress;
    final elapsed = DateTime.now().difference(inProgress.startedAt).inSeconds;

    var newState = state.withStep(
      step,
      StepCompleted(
        maxTimeSeconds: inProgress.maxTimeSeconds,
        completedAt: DateTime.now(),
        elapsedSeconds: elapsed,
        notes: event.notes,
      ),
    ).copyWith(clearError: true);

    emit(_computeOverallStatus(newState));
  }

  void _onStepFailureReported(
    MarchStepFailureReported event,
    Emitter<MarchChecklistState> emit,
  ) {
    final step = event.step;
    _cancelTimer(step);

    var newState = state.withStep(
      step,
      StepFailed(
        maxTimeSeconds: state[step].maxTimeSeconds,
        reason: event.reason,
        failedAt: DateTime.now(),
      ),
    ).copyWith(clearError: true);

    emit(_computeOverallStatus(newState));
  }

  void _onStepSkipRequested(
    MarchStepSkipRequested event,
    Emitter<MarchChecklistState> emit,
  ) {
    final step = event.step;

    if (!state.canActivate(step)) {
      final prereq = step.prerequisite;
      emit(state.copyWith(
        validationError: prereq != null
            ? 'Неможливо пропустити "${step.label}": '
                '"${prereq.label}" (${prereq.code}) ще не виконано'
            : 'Крок "${step.label}" вже виконується або завершено',
      ));
      return;
    }

    _cancelTimer(step);

    var newState = state.withStep(
      step,
      StepSkipped(
        maxTimeSeconds: state[step].maxTimeSeconds,
        reason: event.reason,
        skippedAt: DateTime.now(),
      ),
    ).copyWith(clearError: true);

    emit(_computeOverallStatus(newState));
  }

  void _onRollbackRequested(
    MarchRollbackRequested event,
    Emitter<MarchChecklistState> emit,
  ) {
    final step = event.step;

    if (!state.canRollback(step)) {
      emit(state.copyWith(
        validationError: 'Неможливо відкотити "${step.label}": '
            'наступні кроки вже розпочато або завершено',
      ));
      return;
    }

    // Скасовуємо таймери поточного та всіх наступних кроків
    _cancelTimer(step);
    for (final s in step.subsequentSteps) {
      _cancelTimer(s);
    }

    // Скидаємо поточний крок і всі наступні до Pending
    var updatedSteps = Map<MarchStep, MarchStepState>.from(state.steps);
    updatedSteps[step] =
        StepPending(maxTimeSeconds: state[step].maxTimeSeconds);
    for (final s in step.subsequentSteps) {
      updatedSteps[s] = StepPending(maxTimeSeconds: state[s].maxTimeSeconds);
    }

    emit(state.copyWith(
      steps: updatedSteps,
      overallStatus: MarchOverallStatus.inProgress,
      clearError: true,
    ));
  }

  void _onTimedOut(
    _MarchStepTimedOut event,
    Emitter<MarchChecklistState> emit,
  ) {
    final step = event.step;

    // Guard: крок вже міг завершитись до спрацювання таймера
    if (state[step] is! StepInProgress) return;

    _timers.remove(step);

    var newState = state.withStep(
      step,
      StepFailed(
        maxTimeSeconds: state[step].maxTimeSeconds,
        reason: 'Таймаут: ${state[step].maxTimeSeconds} сек вичерпано',
        failedAt: DateTime.now(),
      ),
    ).copyWith(clearError: true);

    emit(_computeOverallStatus(newState));
  }

  // ─── Timer management ─────────────────────────────────────────────────────

  void _startTimer(MarchStep step, int maxTimeSeconds) {
    _cancelTimer(step);
    _timers[step] = Timer(
      timerDurationFor(step),
      () => add(_MarchStepTimedOut(step)),
    );
  }

  void _cancelTimer(MarchStep step) {
    _timers[step]?.cancel();
    _timers.remove(step);
  }

  void _cancelAllTimers() {
    for (final t in _timers.values) {
      t.cancel();
    }
    _timers.clear();
  }

  // ─── Status computation ───────────────────────────────────────────────────

  MarchChecklistState _computeOverallStatus(MarchChecklistState s) {
    if (s.isComplete) {
      _persistSession(s);
      return s.copyWith(overallStatus: MarchOverallStatus.completed);
    }
    if (s.hasCriticalFailure) {
      return s.copyWith(overallStatus: MarchOverallStatus.partiallyFailed);
    }
    return s.copyWith(overallStatus: MarchOverallStatus.inProgress);
  }

  /// Зберігає результати сесії у БД (fire-and-forget).
  void _persistSession(MarchChecklistState s) {
    final repo = _repository;
    if (repo == null) return;

    final startedAt = _sessionStartedAt ?? DateTime.now();

    var totalSeconds = 0;
    final weakTopics = <String>[];
    final items = <Map<String, dynamic>>[];

    for (final step in MarchStep.values) {
      final stepState = s[step];
      final elapsed = switch (stepState) {
        StepCompleted(:final elapsedSeconds) => elapsedSeconds,
        StepFailed() => step.defaultMaxTimeSeconds,
        StepSkipped() => 0,
        _ => 0,
      };
      totalSeconds += elapsed;
      if (stepState is StepFailed) weakTopics.add(step.code);

      items.add({
        'step': step.code,
        'status': switch (stepState) {
          StepCompleted() => 'completed',
          StepFailed() => 'failed',
          StepSkipped() => 'skipped',
          _ => 'pending',
        },
        'elapsedSeconds': elapsed,
      });
    }

    final total = MarchStep.values.length;
    final failed = weakTopics.length;
    final successRate = ((total - failed) / total * 100).round();

    repo.saveSession(
      startedAt: startedAt,
      totalDurationSeconds: totalSeconds,
      successRatePercent: successRate,
      weakTopics: weakTopics,
      itemsJson: jsonEncode(items),
    );
  }

  @override
  Future<void> close() {
    _cancelAllTimers();
    return super.close();
  }
}
