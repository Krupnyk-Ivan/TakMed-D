import 'package:freezed_annotation/freezed_annotation.dart';

part 'answer_option.freezed.dart';
part 'answer_option.g.dart';

@freezed
class AnswerOption with _$AnswerOption {
  const factory AnswerOption({
    required String id,
    required String text,
    String? imageUrl,
  }) = _AnswerOption;

  factory AnswerOption.fromJson(Map<String, dynamic> json) =>
      _$AnswerOptionFromJson(json);
}
