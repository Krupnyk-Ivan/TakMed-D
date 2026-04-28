/// Ієрархія станів одного кроку MARCH.
///
/// Sealed class гарантує вичерпний switch без default.
/// Dart 3 exhaustiveness checker перевіряє всі гілки на етапі компіляції.
sealed class MarchStepState {
  final int maxTimeSeconds;
  const MarchStepState({required this.maxTimeSeconds});
}

// ─── Конкретні стани ────────────────────────────────────────────────────────

/// Крок ще не розпочато. Очікує на дозвіл (попередній крок не завершено).
final class StepPending extends MarchStepState {
  const StepPending({required super.maxTimeSeconds});

  @override
  String toString() => 'StepPending(max: ${maxTimeSeconds}s)';
}

/// Крок активний — медик виконує дію.
final class StepInProgress extends MarchStepState {
  final DateTime startedAt;

  const StepInProgress({
    required super.maxTimeSeconds,
    required this.startedAt,
  });

  /// Час, що минув з початку кроку.
  Duration get elapsed => DateTime.now().difference(startedAt);

  /// Секунди, що залишились до таймауту (0 якщо вже вийшов).
  int get remainingSeconds =>
      (maxTimeSeconds - elapsed.inSeconds).clamp(0, maxTimeSeconds);

  /// Чи перевищено ліміт часу.
  bool get isExpired => elapsed.inSeconds >= maxTimeSeconds;

  @override
  String toString() =>
      'StepInProgress(elapsed: ${elapsed.inSeconds}s, max: ${maxTimeSeconds}s)';
}

/// Крок виконано успішно.
final class StepCompleted extends MarchStepState {
  final DateTime completedAt;

  /// Час виконання в секундах.
  final int elapsedSeconds;

  /// Нотатки медика (необов'язково).
  final String? notes;

  const StepCompleted({
    required super.maxTimeSeconds,
    required this.completedAt,
    required this.elapsedSeconds,
    this.notes,
  });

  @override
  String toString() =>
      'StepCompleted(in: ${elapsedSeconds}s${notes != null ? ', notes: $notes' : ''})';
}

/// Крок завершився невдачею (таймаут або явне повідомлення про відмову).
final class StepFailed extends MarchStepState {
  final String reason;
  final DateTime failedAt;

  const StepFailed({
    required super.maxTimeSeconds,
    required this.reason,
    required this.failedAt,
  });

  @override
  String toString() => 'StepFailed(reason: $reason)';
}

/// Крок навмисно пропущено (клінічне рішення медика).
final class StepSkipped extends MarchStepState {
  final String reason;
  final DateTime skippedAt;

  const StepSkipped({
    required super.maxTimeSeconds,
    required this.reason,
    required this.skippedAt,
  });

  @override
  String toString() => 'StepSkipped(reason: $reason)';
}

// ─── Extension helpers ───────────────────────────────────────────────────────

extension MarchStepStateX on MarchStepState {
  /// `true` якщо крок вважається "успішним" для продовження протоколу.
  bool get isSuccessful => this is StepCompleted || this is StepSkipped;

  /// `true` якщо крок завершено (будь-яким чином).
  bool get isTerminal =>
      this is StepCompleted || this is StepFailed || this is StepSkipped;
}
