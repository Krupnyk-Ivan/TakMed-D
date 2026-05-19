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

/// Перемикає вибір одного варіанта у multi-select питанні.
class MultiSelectToggled extends QuizEvent {
  final String optionId;
  const MultiSelectToggled(this.optionId);

  @override
  List<Object?> get props => [optionId];
}

/// Підтверджує відповідь у multi-select питанні.
class SubmitMultiSelect extends QuizEvent {
  const SubmitMultiSelect();
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
