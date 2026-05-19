import 'package:equatable/equatable.dart';
import '../../domain/entities/quiz_question.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {
  const QuizInitial();
}

class QuizLoading extends QuizState {
  const QuizLoading();
}

class QuizInProgress extends QuizState {
  final List<QuizQuestion> questions;
  final int currentIndex;
  final int score;
  final List<String> weakTopics;
  final int fastAnswerCount;
  // Для multi-select — поточний вибір до підтвердження
  final List<String> pendingSelectedIds;

  const QuizInProgress({
    required this.questions,
    required this.currentIndex,
    required this.score,
    required this.weakTopics,
    this.fastAnswerCount = 0,
    this.pendingSelectedIds = const [],
  });

  QuizQuestion get currentQuestion => questions[currentIndex];

  @override
  List<Object?> get props => [
        questions,
        currentIndex,
        score,
        weakTopics,
        fastAnswerCount,
        pendingSelectedIds,
      ];

  QuizInProgress copyWith({
    List<QuizQuestion>? questions,
    int? currentIndex,
    int? score,
    List<String>? weakTopics,
    int? fastAnswerCount,
    List<String>? pendingSelectedIds,
  }) {
    return QuizInProgress(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      score: score ?? this.score,
      weakTopics: weakTopics ?? this.weakTopics,
      fastAnswerCount: fastAnswerCount ?? this.fastAnswerCount,
      pendingSelectedIds: pendingSelectedIds ?? this.pendingSelectedIds,
    );
  }
}

class QuizAnswered extends QuizState {
  final QuizInProgress progressState;
  final bool isCorrect;
  final String selectedAnswerId;
  // Для multi-select — всі вибрані id
  final List<String> selectedAnswerIds;

  const QuizAnswered({
    required this.progressState,
    required this.isCorrect,
    required this.selectedAnswerId,
    this.selectedAnswerIds = const [],
  });

  @override
  List<Object?> get props => [
        progressState,
        isCorrect,
        selectedAnswerId,
        selectedAnswerIds,
      ];
}

class QuizCompleted extends QuizState {
  final int totalQuestions;
  final int correctAnswers;
  final int earnedXp;
  final List<String> weakTopics;
  final int fastAnswerCount;

  const QuizCompleted({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.earnedXp,
    required this.weakTopics,
    this.fastAnswerCount = 0,
  });

  @override
  List<Object?> get props =>
      [totalQuestions, correctAnswers, earnedXp, weakTopics, fastAnswerCount];
}

class QuizError extends QuizState {
  final String message;
  const QuizError(this.message);

  @override
  List<Object?> get props => [message];
}
