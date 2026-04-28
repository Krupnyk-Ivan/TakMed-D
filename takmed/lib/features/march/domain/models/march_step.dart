/// Крок протоколу MARCH з метаданими та часовими обмеженнями.
enum MarchStep {
  massiveHemorrhage('M', 'Масивна кровотеча', 120),
  airway('A', 'Прохідність дихальних шляхів', 60),
  respiration('R', 'Дихання', 90),
  circulation('C', 'Кровообіг', 90),
  hypothermia('H', 'Гіпотермія / Травма голови', 120);

  /// Літерний код протоколу.
  final String code;

  /// Назва українською.
  final String label;

  /// Максимальний час виконання кроку в секундах (за замовчуванням).
  final int defaultMaxTimeSeconds;

  const MarchStep(this.code, this.label, this.defaultMaxTimeSeconds);

  /// Крок-попередник, який обов'язково має бути виконаний (Completed або Skipped)
  /// до початку поточного кроку. `null` — для першого кроку M.
  MarchStep? get prerequisite => switch (this) {
        MarchStep.massiveHemorrhage => null,
        MarchStep.airway => MarchStep.massiveHemorrhage,
        MarchStep.respiration => MarchStep.airway,
        MarchStep.circulation => MarchStep.respiration,
        MarchStep.hypothermia => MarchStep.circulation,
      };

  /// Наступний крок у протоколі.
  MarchStep? get next => switch (this) {
        MarchStep.massiveHemorrhage => MarchStep.airway,
        MarchStep.airway => MarchStep.respiration,
        MarchStep.respiration => MarchStep.circulation,
        MarchStep.circulation => MarchStep.hypothermia,
        MarchStep.hypothermia => null,
      };

  /// Список кроків, що слідують після поточного.
  List<MarchStep> get subsequentSteps {
    final all = MarchStep.values;
    final idx = all.indexOf(this);
    return all.sublist(idx + 1);
  }
}
