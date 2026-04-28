// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MultipleChoiceQuestionImpl _$$MultipleChoiceQuestionImplFromJson(
        Map<String, dynamic> json) =>
    _$MultipleChoiceQuestionImpl(
      id: json['id'] as String,
      text: json['text'] as String,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      imageUrl: json['imageUrl'] as String?,
      options: (json['options'] as List<dynamic>)
          .map((e) => AnswerOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      correctId: json['correctId'] as String,
      explanation: json['explanation'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$MultipleChoiceQuestionImplToJson(
        _$MultipleChoiceQuestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'tags': instance.tags,
      'imageUrl': instance.imageUrl,
      'options': instance.options,
      'correctId': instance.correctId,
      'explanation': instance.explanation,
      'runtimeType': instance.$type,
    };

_$TrueFalseQuestionImpl _$$TrueFalseQuestionImplFromJson(
        Map<String, dynamic> json) =>
    _$TrueFalseQuestionImpl(
      id: json['id'] as String,
      statement: json['statement'] as String,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      correctAnswer: json['correctAnswer'] as bool,
      explanation: json['explanation'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$TrueFalseQuestionImplToJson(
        _$TrueFalseQuestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'statement': instance.statement,
      'tags': instance.tags,
      'correctAnswer': instance.correctAnswer,
      'explanation': instance.explanation,
      'runtimeType': instance.$type,
    };

_$SequenceQuestionImpl _$$SequenceQuestionImplFromJson(
        Map<String, dynamic> json) =>
    _$SequenceQuestionImpl(
      id: json['id'] as String,
      instruction: json['instruction'] as String,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      items: (json['items'] as List<dynamic>)
          .map((e) => SequenceItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      explanation: json['explanation'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$SequenceQuestionImplToJson(
        _$SequenceQuestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'instruction': instance.instruction,
      'tags': instance.tags,
      'items': instance.items,
      'explanation': instance.explanation,
      'runtimeType': instance.$type,
    };

_$ImageMatchQuestionImpl _$$ImageMatchQuestionImplFromJson(
        Map<String, dynamic> json) =>
    _$ImageMatchQuestionImpl(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      question: json['question'] as String,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      options: (json['options'] as List<dynamic>)
          .map((e) => AnswerOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      correctId: json['correctId'] as String,
      explanation: json['explanation'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$ImageMatchQuestionImplToJson(
        _$ImageMatchQuestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'question': instance.question,
      'tags': instance.tags,
      'options': instance.options,
      'correctId': instance.correctId,
      'explanation': instance.explanation,
      'runtimeType': instance.$type,
    };
