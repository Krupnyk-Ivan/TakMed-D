import 'package:equatable/equatable.dart';
import '../../domain/models/march_step.dart';
import '../../domain/models/march_step_state.dart';

/// Загальний статус виконання протоколу.
enum MarchOverallStatus {
  /// Протокол не розпочато.
  idle,

  /// Виконується (хоча б один крок InProgress або Completed).
  inProgress,

  /// Всі кроки завершені (Completed або Skipped).
  completed,

  /// Є хоча б один Failed крок, але протокол продовжується.
  partiallyFailed,
}

/// Незмінний стан чекліста MARCH — зберігає стани всіх 5 кроків.
final class MarchChecklistState extends Equatable {
  /// Стани кроків. Ключ — [MarchStep], значення — [MarchStepState] (sealed).
  final Map<MarchStep, MarchStepState> steps;

  /// Загальний статус виконання протоколу.
  final MarchOverallStatus overallStatus;

  /// Повідомлення про порушення бізнес-правила (очищається після наступного
  /// успішного переходу). `null` — помилки немає.
  final String? validationError;

  const MarchChecklistState({
    required this.steps,
    this.overallStatus = MarchOverallStatus.idle,
    this.validationError,
  });

  // ─── Factory ────────────────────────────────────────────────────────────────

  /// Початковий стан: всі кроки [StepPending] з лімітами часу за замовчуванням.
  factory MarchChecklistState.initial({Map<MarchStep, int>? maxTimeOverrides}) {
    return MarchChecklistState(
      steps: {
        for (final step in MarchStep.values)
          step: StepPending(
            maxTimeSeconds:
                maxTimeOverrides?[step] ?? step.defaultMaxTimeSeconds,
          ),
      },
      overallStatus: MarchOverallStatus.idle,
    );
  }

  // ─── Accessors ───────────────────────────────────────────────────────────────

  /// Оператор індексу для зручного доступу: `state[MarchStep.airway]`.
  MarchStepState operator [](MarchStep step) => steps[step]!;

  /// Поточний активний крок (InProgress), або `null`.
  MarchStep? get activeStep {
    for (final step in MarchStep.values) {
      if (steps[step] is StepInProgress) return step;
    }
    return null;
  }

  // ─── Computed flags ──────────────────────────────────────────────────────────

  /// Всі кроки завершено (Completed або Skipped).
  bool get isComplete =>
      steps.values.every((s) => s is StepCompleted || s is StepSkipped);

  /// Є хоча б один Failed крок.
  bool get hasCriticalFailure =>
      steps.values.any((s) => s is StepFailed);

  /// % успішності — частка успішних кроків (не Failed) від загальної кількості.
  int get successRate {
    final total = MarchStep.values.length;
    if (total == 0) return 0;
    final failed = steps.values.where((s) => s is StepFailed).length;
    return ((total - failed) / total * 100).round();
  }

  // ─── Validation helpers ──────────────────────────────────────────────────────

  /// Повертає `true` якщо крок можна розпочати або пропустити:
  /// • поточний стан [StepPending] або [StepFailed]
  /// • попередній крок [StepCompleted] або [StepSkipped]
  bool canActivate(MarchStep step) {
    final current = steps[step];
    if (current is! StepPending && current is! StepFailed) return false;

    final prereq = step.prerequisite;
    if (prereq == null) return true;

    return steps[prereq]!.isSuccessful;
  }

  /// Повертає `true` якщо крок можна завершити або відзвітувати про відмову:
  /// • поточний стан [StepInProgress]
  /// • попередній крок [StepCompleted] або [StepSkipped]
  bool canComplete(MarchStep step) {
    if (steps[step] is! StepInProgress) return false;

    final prereq = step.prerequisite;
    if (prereq == null) return true;

    return steps[prereq]!.isSuccessful;
  }

  /// Повертає `true` якщо крок можна відкотити до [StepPending]:
  /// всі наступні кроки мають бути [StepPending] або [StepFailed].
  bool canRollback(MarchStep step) {
    return step.subsequentSteps.every(
      (s) => steps[s] is StepPending || steps[s] is StepFailed,
    );
  }

  // ─── Immutable updates ───────────────────────────────────────────────────────

  /// Повертає нову копію з оновленим станом одного кроку.
  MarchChecklistState withStep(MarchStep step, MarchStepState newState) {
    return copyWith(steps: {...steps, step: newState});
  }

  MarchChecklistState copyWith({
    Map<MarchStep, MarchStepState>? steps,
    MarchOverallStatus? overallStatus,
    String? validationError,
    bool clearError = false,
  }) {
    return MarchChecklistState(
      steps: steps ?? this.steps,
      overallStatus: overallStatus ?? this.overallStatus,
      validationError:
          clearError ? null : (validationError ?? this.validationError),
    );
  }

  @override
  List<Object?> get props => [steps, overallStatus, validationError];

  @override
  String toString() =>
      'MarchChecklistState(status: $overallStatus, active: $activeStep, '
      'error: $validationError)';
}
