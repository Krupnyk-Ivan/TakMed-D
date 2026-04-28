// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sequence_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SequenceItem _$SequenceItemFromJson(Map<String, dynamic> json) {
  return _SequenceItem.fromJson(json);
}

/// @nodoc
mixin _$SequenceItem {
  String get id => throw _privateConstructorUsedError;
  String get text =>
      throw _privateConstructorUsedError; // The correct order index (0, 1, 2, ...)
  int get correctIndex => throw _privateConstructorUsedError;

  /// Serializes this SequenceItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SequenceItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SequenceItemCopyWith<SequenceItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SequenceItemCopyWith<$Res> {
  factory $SequenceItemCopyWith(
          SequenceItem value, $Res Function(SequenceItem) then) =
      _$SequenceItemCopyWithImpl<$Res, SequenceItem>;
  @useResult
  $Res call({String id, String text, int correctIndex});
}

/// @nodoc
class _$SequenceItemCopyWithImpl<$Res, $Val extends SequenceItem>
    implements $SequenceItemCopyWith<$Res> {
  _$SequenceItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SequenceItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? correctIndex = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      correctIndex: null == correctIndex
          ? _value.correctIndex
          : correctIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SequenceItemImplCopyWith<$Res>
    implements $SequenceItemCopyWith<$Res> {
  factory _$$SequenceItemImplCopyWith(
          _$SequenceItemImpl value, $Res Function(_$SequenceItemImpl) then) =
      __$$SequenceItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String text, int correctIndex});
}

/// @nodoc
class __$$SequenceItemImplCopyWithImpl<$Res>
    extends _$SequenceItemCopyWithImpl<$Res, _$SequenceItemImpl>
    implements _$$SequenceItemImplCopyWith<$Res> {
  __$$SequenceItemImplCopyWithImpl(
      _$SequenceItemImpl _value, $Res Function(_$SequenceItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of SequenceItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? correctIndex = null,
  }) {
    return _then(_$SequenceItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      correctIndex: null == correctIndex
          ? _value.correctIndex
          : correctIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SequenceItemImpl implements _SequenceItem {
  const _$SequenceItemImpl(
      {required this.id, required this.text, required this.correctIndex});

  factory _$SequenceItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$SequenceItemImplFromJson(json);

  @override
  final String id;
  @override
  final String text;
// The correct order index (0, 1, 2, ...)
  @override
  final int correctIndex;

  @override
  String toString() {
    return 'SequenceItem(id: $id, text: $text, correctIndex: $correctIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SequenceItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.correctIndex, correctIndex) ||
                other.correctIndex == correctIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, text, correctIndex);

  /// Create a copy of SequenceItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SequenceItemImplCopyWith<_$SequenceItemImpl> get copyWith =>
      __$$SequenceItemImplCopyWithImpl<_$SequenceItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SequenceItemImplToJson(
      this,
    );
  }
}

abstract class _SequenceItem implements SequenceItem {
  const factory _SequenceItem(
      {required final String id,
      required final String text,
      required final int correctIndex}) = _$SequenceItemImpl;

  factory _SequenceItem.fromJson(Map<String, dynamic> json) =
      _$SequenceItemImpl.fromJson;

  @override
  String get id;
  @override
  String get text; // The correct order index (0, 1, 2, ...)
  @override
  int get correctIndex;

  /// Create a copy of SequenceItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SequenceItemImplCopyWith<_$SequenceItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
