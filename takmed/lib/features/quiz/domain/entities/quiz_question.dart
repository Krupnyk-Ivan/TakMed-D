import 'package:freezed_annotation/freezed_annotation.dart';
import 'answer_option.dart';
import 'sequence_item.dart';

part 'quiz_question.freezed.dart';
part 'quiz_question.g.dart';

@freezed
class QuizQuestion with _$QuizQuestion {
  // Тип 1: Multiple Choice
  const factory QuizQuestion.multipleChoice({
    required String id,
    required String text,
    @Default([]) List<String> tags, // For weak topics
    String? imageUrl,
    required List<AnswerOption> options,
    required String correctId,
    required String explanation,
  }) = MultipleChoiceQuestion;

  // Тип 2: True/False
  const factory QuizQuestion.trueFalse({
    required String id,
    required String statement,
    @Default([]) List<String> tags,
    required bool correctAnswer,
    required String explanation,
  }) = TrueFalseQuestion;

  // Тип 3: Sequence (правильний порядок дій)
  const factory QuizQuestion.sequence({
    required String id,
    required String instruction,
    @Default([]) List<String> tags,
    required List<SequenceItem> items,
    required String explanation,
  }) = SequenceQuestion;

  // Тип 4: Image Match (визнач тип поранення)
  const factory QuizQuestion.imageMatch({
    required String id,
    required String imageUrl,
    required String question,
    @Default([]) List<String> tags,
    required List<AnswerOption> options,
    required String correctId,
    required String explanation,
  }) = ImageMatchQuestion;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);
}
