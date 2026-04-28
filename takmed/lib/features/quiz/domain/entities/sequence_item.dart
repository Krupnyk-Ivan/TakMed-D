import 'package:freezed_annotation/freezed_annotation.dart';

part 'sequence_item.freezed.dart';
part 'sequence_item.g.dart';

@freezed
class SequenceItem with _$SequenceItem {
  const factory SequenceItem({
    required String id,
    required String text,
    // The correct order index (0, 1, 2, ...)
    required int correctIndex,
  }) = _SequenceItem;

  factory SequenceItem.fromJson(Map<String, dynamic> json) =>
      _$SequenceItemFromJson(json);
}
