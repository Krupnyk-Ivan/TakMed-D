/// Контент вікторини.
class QuizContent {
  /// Створює вікторину.
  const QuizContent({required this.questions});

  /// Питання.
  final List<QuizQuestion> questions;

  /// Парсить JSON.
  factory QuizContent.fromJson(Map<String, dynamic> json) {
    final questionsJson = json['questions'] as List<dynamic>? ?? [];
    return QuizContent(
      questions: questionsJson
          .map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Питання вікторини.
class QuizQuestion {
  /// Створює питання.
  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
  });

  /// Текст питання.
  final String question;

  /// Варіанти відповідей.
  final List<String> options;

  /// Індекс правильної відповіді.
  final int correctIndex;

  /// Пояснення правильної відповіді.
  final String? explanation;

  /// Парсить JSON.
  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      question: json['question'] as String,
      options:
          (json['options'] as List<dynamic>).map((o) => o as String).toList(),
      correctIndex: json['correctIndex'] as int,
      explanation: json['explanation'] as String?,
    );
  }
}
