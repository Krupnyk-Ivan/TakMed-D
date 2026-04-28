// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'answer_option.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AnswerOption _$AnswerOptionFromJson(Map<String, dynamic> json) {
  return _AnswerOption.fromJson(json);
}

/// @nodoc
mixin _$AnswerOption {
  String get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  /// Serializes this AnswerOption to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnswerOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnswerOptionCopyWith<AnswerOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnswerOptionCopyWith<$Res> {
  factory $AnswerOptionCopyWith(
          AnswerOption value, $Res Function(AnswerOption) then) =
      _$AnswerOptionCopyWithImpl<$Res, AnswerOption>;
  @useResult
  $Res call({String id, String text, String? imageUrl});
}

/// @nodoc
class _$AnswerOptionCopyWithImpl<$Res, $Val extends AnswerOption>
    implements $AnswerOptionCopyWith<$Res> {
  _$AnswerOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnswerOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? imageUrl = freezed,
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
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnswerOptionImplCopyWith<$Res>
    implements $AnswerOptionCopyWith<$Res> {
  factory _$$AnswerOptionImplCopyWith(
          _$AnswerOptionImpl value, $Res Function(_$AnswerOptionImpl) then) =
      __$$AnswerOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String text, String? imageUrl});
}

/// @nodoc
class __$$AnswerOptionImplCopyWithImpl<$Res>
    extends _$AnswerOptionCopyWithImpl<$Res, _$AnswerOptionImpl>
    implements _$$AnswerOptionImplCopyWith<$Res> {
  __$$AnswerOptionImplCopyWithImpl(
      _$AnswerOptionImpl _value, $Res Function(_$AnswerOptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnswerOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? imageUrl = freezed,
  }) {
    return _then(_$AnswerOptionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnswerOptionImpl implements _AnswerOption {
  const _$AnswerOptionImpl(
      {required this.id, required this.text, this.imageUrl});

  factory _$AnswerOptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnswerOptionImplFromJson(json);

  @override
  final String id;
  @override
  final String text;
  @override
  final String? imageUrl;

  @override
  String toString() {
    return 'AnswerOption(id: $id, text: $text, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnswerOptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, text, imageUrl);

  /// Create a copy of AnswerOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnswerOptionImplCopyWith<_$AnswerOptionImpl> get copyWith =>
      __$$AnswerOptionImplCopyWithImpl<_$AnswerOptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnswerOptionImplToJson(
      this,
    );
  }
}

abstract class _AnswerOption implements AnswerOption {
  const factory _AnswerOption(
      {required final String id,
      required final String text,
      final String? imageUrl}) = _$AnswerOptionImpl;

  factory _AnswerOption.fromJson(Map<String, dynamic> json) =
      _$AnswerOptionImpl.fromJson;

  @override
  String get id;
  @override
  String get text;
  @override
  String? get imageUrl;

  /// Create a copy of AnswerOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnswerOptionImplCopyWith<_$AnswerOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
