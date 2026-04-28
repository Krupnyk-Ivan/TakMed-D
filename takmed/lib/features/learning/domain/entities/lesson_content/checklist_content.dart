/// Контент чеклисту.
class ChecklistContent {
  /// Створює чеклист.
  const ChecklistContent({required this.steps});

  /// Кроки чеклисту.
  final List<ChecklistStep> steps;

  /// Парсить JSON.
  factory ChecklistContent.fromJson(Map<String, dynamic> json) {
    final stepsJson = json['steps'] as List<dynamic>? ?? [];
    return ChecklistContent(
      steps: stepsJson
          .map((s) => ChecklistStep.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Крок чеклисту.
class ChecklistStep {
  /// Створює крок.
  const ChecklistStep({
    required this.title,
    required this.description,
    this.isChecked = false,
  });

  /// Назва кроку.
  final String title;

  /// Опис.
  final String description;

  /// Чи виконаний.
  final bool isChecked;

  /// Парсить JSON.
  factory ChecklistStep.fromJson(Map<String, dynamic> json) {
    return ChecklistStep(
      title: json['title'] as String,
      description: json['description'] as String,
      isChecked: json['isChecked'] as bool? ?? false,
    );
  }
}
