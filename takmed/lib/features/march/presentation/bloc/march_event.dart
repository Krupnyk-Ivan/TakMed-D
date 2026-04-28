import 'package:equatable/equatable.dart';
import '../../domain/models/march_step.dart';

/// Базовий клас подій протоколу MARCH.
abstract class MarchEvent extends Equatable {
  const MarchEvent();

  @override
  List<Object?> get props => [];
}

// ─── Lifecycle ───────────────────────────────────────────────────────────────

/// Запуск протоколу — автоматично розпочинає крок M.
final class MarchStarted extends MarchEvent {
  /// Опціональне перевизначення лімітів часу для кожного кроку (секунди).
  /// Якщо не вказано, використовуються значення за замовчуванням з [MarchStep].
  final Map<MarchStep, int>? maxTimeOverrides;

  const MarchStarted({this.maxTimeOverrides});

  @override
  List<Object?> get props => [maxTimeOverrides];
}

/// Скидання чекліста до початкового стану (очищає всі таймери).
final class MarchReset extends MarchEvent {
  const MarchReset();
}

// ─── Step transitions ─────────────────────────────────────────────────────────

/// Запит на початок виконання кроку.
///
/// Блокується BLoC-ом якщо попередній крок не [StepCompleted]/[StepSkipped].
final class MarchStepStartRequested extends MarchEvent {
  final MarchStep step;
  const MarchStepStartRequested(this.step);

  @override
  List<Object?> get props => [step];
}

/// Запит на позначення кроку як виконаного.
///
/// Вимагає: крок у стані [StepInProgress] ТА попередній крок [StepCompleted]/[StepSkipped].
final class MarchStepCompletionRequested extends MarchEvent {
  final MarchStep step;

  /// Клінічні нотатки медика (необов'язково).
  final String? notes;

  const MarchStepCompletionRequested({required this.step, this.notes});

  @override
  List<Object?> get props => [step, notes];
}

/// Медик повідомляє про невдачу виконання кроку (наприклад, кровотечу зупинити неможливо).
final class MarchStepFailureReported extends MarchEvent {
  final MarchStep step;
  final String reason;

  const MarchStepFailureReported({required this.step, required this.reason});

  @override
  List<Object?> get props => [step, reason];
}

/// Клінічне рішення пропустити крок (наприклад, пацієнт без свідомості, A не потрібен).
///
/// Вимагає виконаний попередній крок.
final class MarchStepSkipRequested extends MarchEvent {
  final MarchStep step;
  final String reason;

  const MarchStepSkipRequested({required this.step, required this.reason});

  @override
  List<Object?> get props => [step, reason];
}

/// Запит на відкат кроку до [StepPending].
///
/// Дозволено тільки якщо всі наступні кроки у стані [StepPending] або [StepFailed].
final class MarchRollbackRequested extends MarchEvent {
  final MarchStep step;
  const MarchRollbackRequested(this.step);

  @override
  List<Object?> get props => [step];
}
