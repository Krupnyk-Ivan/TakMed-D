// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'march_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MarchItem {
  MarchStep get step => throw _privateConstructorUsedError;
  MarchItemStatus get status => throw _privateConstructorUsedError;
  int get elapsedSeconds => throw _privateConstructorUsedError;
  int get quizAttempts => throw _privateConstructorUsedError;
  bool? get quizAnsweredCorrectly => throw _privateConstructorUsedError;

  /// Create a copy of MarchItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarchItemCopyWith<MarchItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarchItemCopyWith<$Res> {
  factory $MarchItemCopyWith(MarchItem value, $Res Function(MarchItem) then) =
      _$MarchItemCopyWithImpl<$Res, MarchItem>;
  @useResult
  $Res call(
      {MarchStep step,
      MarchItemStatus status,
      int elapsedSeconds,
      int quizAttempts,
      bool? quizAnsweredCorrectly});
}

/// @nodoc
class _$MarchItemCopyWithImpl<$Res, $Val extends MarchItem>
    implements $MarchItemCopyWith<$Res> {
  _$MarchItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarchItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
    Object? status = null,
    Object? elapsedSeconds = null,
    Object? quizAttempts = null,
    Object? quizAnsweredCorrectly = freezed,
  }) {
    return _then(_value.copyWith(
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as MarchStep,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MarchItemStatus,
      elapsedSeconds: null == elapsedSeconds
          ? _value.elapsedSeconds
          : elapsedSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      quizAttempts: null == quizAttempts
          ? _value.quizAttempts
          : quizAttempts // ignore: cast_nullable_to_non_nullable
              as int,
      quizAnsweredCorrectly: freezed == quizAnsweredCorrectly
          ? _value.quizAnsweredCorrectly
          : quizAnsweredCorrectly // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MarchItemImplCopyWith<$Res>
    implements $MarchItemCopyWith<$Res> {
  factory _$$MarchItemImplCopyWith(
          _$MarchItemImpl value, $Res Function(_$MarchItemImpl) then) =
      __$$MarchItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {MarchStep step,
      MarchItemStatus status,
      int elapsedSeconds,
      int quizAttempts,
      bool? quizAnsweredCorrectly});
}

/// @nodoc
class __$$MarchItemImplCopyWithImpl<$Res>
    extends _$MarchItemCopyWithImpl<$Res, _$MarchItemImpl>
    implements _$$MarchItemImplCopyWith<$Res> {
  __$$MarchItemImplCopyWithImpl(
      _$MarchItemImpl _value, $Res Function(_$MarchItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of MarchItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
    Object? status = null,
    Object? elapsedSeconds = null,
    Object? quizAttempts = null,
    Object? quizAnsweredCorrectly = freezed,
  }) {
    return _then(_$MarchItemImpl(
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as MarchStep,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MarchItemStatus,
      elapsedSeconds: null == elapsedSeconds
          ? _value.elapsedSeconds
          : elapsedSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      quizAttempts: null == quizAttempts
          ? _value.quizAttempts
          : quizAttempts // ignore: cast_nullable_to_non_nullable
              as int,
      quizAnsweredCorrectly: freezed == quizAnsweredCorrectly
          ? _value.quizAnsweredCorrectly
          : quizAnsweredCorrectly // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

class _$MarchItemImpl extends _MarchItem {
  const _$MarchItemImpl(
      {required this.step,
      this.status = MarchItemStatus.locked,
      this.elapsedSeconds = 0,
      this.quizAttempts = 0,
      this.quizAnsweredCorrectly})
      : super._();

  @override
  final MarchStep step;
  @override
  @JsonKey()
  final MarchItemStatus status;
  @override
  @JsonKey()
  final int elapsedSeconds;
  @override
  @JsonKey()
  final int quizAttempts;
  @override
  final bool? quizAnsweredCorrectly;

  @override
  String toString() {
    return 'MarchItem(step: $step, status: $status, elapsedSeconds: $elapsedSeconds, quizAttempts: $quizAttempts, quizAnsweredCorrectly: $quizAnsweredCorrectly)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarchItemImpl &&
            (identical(other.step, step) || other.step == step) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.elapsedSeconds, elapsedSeconds) ||
                other.elapsedSeconds == elapsedSeconds) &&
            (identical(other.quizAttempts, quizAttempts) ||
                other.quizAttempts == quizAttempts) &&
            (identical(other.quizAnsweredCorrectly, quizAnsweredCorrectly) ||
                other.quizAnsweredCorrectly == quizAnsweredCorrectly));
  }

  @override
  int get hashCode => Object.hash(runtimeType, step, status, elapsedSeconds,
      quizAttempts, quizAnsweredCorrectly);

  /// Create a copy of MarchItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarchItemImplCopyWith<_$MarchItemImpl> get copyWith =>
      __$$MarchItemImplCopyWithImpl<_$MarchItemImpl>(this, _$identity);
}

abstract class _MarchItem extends MarchItem {
  const factory _MarchItem(
      {required final MarchStep step,
      final MarchItemStatus status,
      final int elapsedSeconds,
      final int quizAttempts,
      final bool? quizAnsweredCorrectly}) = _$MarchItemImpl;
  const _MarchItem._() : super._();

  @override
  MarchStep get step;
  @override
  MarchItemStatus get status;
  @override
  int get elapsedSeconds;
  @override
  int get quizAttempts;
  @override
  bool? get quizAnsweredCorrectly;

  /// Create a copy of MarchItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarchItemImplCopyWith<_$MarchItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
