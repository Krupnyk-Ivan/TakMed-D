import 'package:equatable/equatable.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class StartQuiz extends QuizEvent {
  final String topicId;
  const StartQuiz(this.topicId);

  @override
  List<Object?> get props => [topicId];
}

class AnswerSelected extends QuizEvent {
  final String answerId; // Or boolean for true/false
  const AnswerSelected(this.answerId);

  @override
  List<Object?> get props => [answerId];
}

class SequenceReordered extends QuizEvent {
  final List<String> reorderedItemIds;
  const SequenceReordered(this.reorderedItemIds);

  @override
  List<Object?> get props => [reorderedItemIds];
}

class NextQuestion extends QuizEvent {
  const NextQuestion();
}

class FinishQuiz extends QuizEvent {
  const FinishQuiz();
}

class RetryQuiz extends QuizEvent {
  final String topicId;
  const RetryQuiz(this.topicId);

  @override
  List<Object?> get props => [topicId];
}
