// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sequence_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SequenceItemImpl _$$SequenceItemImplFromJson(Map<String, dynamic> json) =>
    _$SequenceItemImpl(
      id: json['id'] as String,
      text: json['text'] as String,
      correctIndex: (json['correctIndex'] as num).toInt(),
    );

Map<String, dynamic> _$$SequenceItemImplToJson(_$SequenceItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'correctIndex': instance.correctIndex,
    };
