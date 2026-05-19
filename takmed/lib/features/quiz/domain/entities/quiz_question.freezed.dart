// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuizQuestion _$QuizQuestionFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'multipleChoice':
      return MultipleChoiceQuestion.fromJson(json);
    case 'trueFalse':
      return TrueFalseQuestion.fromJson(json);
    case 'sequence':
      return SequenceQuestion.fromJson(json);
    case 'imageMatch':
      return ImageMatchQuestion.fromJson(json);
    case 'multiSelect':
      return MultiSelectQuestion.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'QuizQuestion',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$QuizQuestion {
  String get id => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  String get explanation => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            String correctId,
            String explanation)
        multipleChoice,
    required TResult Function(String id, String statement, List<String> tags,
            bool correctAnswer, String explanation)
        trueFalse,
    required TResult Function(String id, String instruction, List<String> tags,
            List<SequenceItem> items, String explanation)
        sequence,
    required TResult Function(
            String id,
            String imageUrl,
            String question,
            List<String> tags,
            List<AnswerOption> options,
            String correctId,
            String explanation)
        imageMatch,
    required TResult Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            List<String> correctIds,
            String explanation)
        multiSelect,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            String correctId,
            String explanation)?
        multipleChoice,
    TResult? Function(String id, String statement, List<String> tags,
            bool correctAnswer, String explanation)?
        trueFalse,
    TResult? Function(String id, String instruction, List<String> tags,
            List<SequenceItem> items, String explanation)?
        sequence,
    TResult? Function(
            String id,
            String imageUrl,
            String question,
            List<String> tags,
            List<AnswerOption> options,
            String correctId,
            String explanation)?
        imageMatch,
    TResult? Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            List<String> correctIds,
            String explanation)?
        multiSelect,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            String correctId,
            String explanation)?
        multipleChoice,
    TResult Function(String id, String statement, List<String> tags,
            bool correctAnswer, String explanation)?
        trueFalse,
    TResult Function(String id, String instruction, List<String> tags,
            List<SequenceItem> items, String explanation)?
        sequence,
    TResult Function(
            String id,
            String imageUrl,
            String question,
            List<String> tags,
            List<AnswerOption> options,
            String correctId,
            String explanation)?
        imageMatch,
    TResult Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            List<String> correctIds,
            String explanation)?
        multiSelect,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MultipleChoiceQuestion value) multipleChoice,
    required TResult Function(TrueFalseQuestion value) trueFalse,
    required TResult Function(SequenceQuestion value) sequence,
    required TResult Function(ImageMatchQuestion value) imageMatch,
    required TResult Function(MultiSelectQuestion value) multiSelect,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MultipleChoiceQuestion value)? multipleChoice,
    TResult? Function(TrueFalseQuestion value)? trueFalse,
    TResult? Function(SequenceQuestion value)? sequence,
    TResult? Function(ImageMatchQuestion value)? imageMatch,
    TResult? Function(MultiSelectQuestion value)? multiSelect,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MultipleChoiceQuestion value)? multipleChoice,
    TResult Function(TrueFalseQuestion value)? trueFalse,
    TResult Function(SequenceQuestion value)? sequence,
    TResult Function(ImageMatchQuestion value)? imageMatch,
    TResult Function(MultiSelectQuestion value)? multiSelect,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this QuizQuestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizQuestionCopyWith<QuizQuestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizQuestionCopyWith<$Res> {
  factory $QuizQuestionCopyWith(
          QuizQuestion value, $Res Function(QuizQuestion) then) =
      _$QuizQuestionCopyWithImpl<$Res, QuizQuestion>;
  @useResult
  $Res call({String id, List<String> tags, String explanation});
}

/// @nodoc
class _$QuizQuestionCopyWithImpl<$Res, $Val extends QuizQuestion>
    implements $QuizQuestionCopyWith<$Res> {
  _$QuizQuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tags = null,
    Object? explanation = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      explanation: null == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MultipleChoiceQuestionImplCopyWith<$Res>
    implements $QuizQuestionCopyWith<$Res> {
  factory _$$MultipleChoiceQuestionImplCopyWith(
          _$MultipleChoiceQuestionImpl value,
          $Res Function(_$MultipleChoiceQuestionImpl) then) =
      __$$MultipleChoiceQuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String text,
      List<String> tags,
      String? imageUrl,
      List<AnswerOption> options,
      String correctId,
      String explanation});
}

/// @nodoc
class __$$MultipleChoiceQuestionImplCopyWithImpl<$Res>
    extends _$QuizQuestionCopyWithImpl<$Res, _$MultipleChoiceQuestionImpl>
    implements _$$MultipleChoiceQuestionImplCopyWith<$Res> {
  __$$MultipleChoiceQuestionImplCopyWithImpl(
      _$MultipleChoiceQuestionImpl _value,
      $Res Function(_$MultipleChoiceQuestionImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? tags = null,
    Object? imageUrl = freezed,
    Object? options = null,
    Object? correctId = null,
    Object? explanation = null,
  }) {
    return _then(_$MultipleChoiceQuestionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<AnswerOption>,
      correctId: null == correctId
          ? _value.correctId
          : correctId // ignore: cast_nullable_to_non_nullable
              as String,
      explanation: null == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MultipleChoiceQuestionImpl implements MultipleChoiceQuestion {
  const _$MultipleChoiceQuestionImpl(
      {required this.id,
      required this.text,
      final List<String> tags = const [],
      this.imageUrl,
      required final List<AnswerOption> options,
      required this.correctId,
      required this.explanation,
      final String? $type})
      : _tags = tags,
        _options = options,
        $type = $type ?? 'multipleChoice';

  factory _$MultipleChoiceQuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$MultipleChoiceQuestionImplFromJson(json);

  @override
  final String id;
  @override
  final String text;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

// For weak topics
  @override
  final String? imageUrl;
  final List<AnswerOption> _options;
  @override
  List<AnswerOption> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  final String correctId;
  @override
  final String explanation;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'QuizQuestion.multipleChoice(id: $id, text: $text, tags: $tags, imageUrl: $imageUrl, options: $options, correctId: $correctId, explanation: $explanation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MultipleChoiceQuestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.correctId, correctId) ||
                other.correctId == correctId) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      text,
      const DeepCollectionEquality().hash(_tags),
      imageUrl,
      const DeepCollectionEquality().hash(_options),
      correctId,
      explanation);

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MultipleChoiceQuestionImplCopyWith<_$MultipleChoiceQuestionImpl>
      get copyWith => __$$MultipleChoiceQuestionImplCopyWithImpl<
          _$MultipleChoiceQuestionImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            String correctId,
            String explanation)
        multipleChoice,
    required TResult Function(String id, String statement, List<String> tags,
            bool correctAnswer, String explanation)
        trueFalse,
    required TResult Function(String id, String instruction, List<String> tags,
            List<SequenceItem> items, String explanation)
        sequence,
    required TResult Function(
            String id,
            String imageUrl,
            String question,
            List<String> tags,
            List<AnswerOption> options,
            String correctId,
            String explanation)
        imageMatch,
    required TResult Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            List<String> correctIds,
            String explanation)
        multiSelect,
  }) {
    return multipleChoice(
        id, text, tags, imageUrl, options, correctId, explanation);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            String correctId,
            String explanation)?
        multipleChoice,
    TResult? Function(String id, String statement, List<String> tags,
            bool correctAnswer, String explanation)?
        trueFalse,
    TResult? Function(String id, String instruction, List<String> tags,
            List<SequenceItem> items, String explanation)?
        sequence,
    TResult? Function(
            String id,
            String imageUrl,
            String question,
            List<String> tags,
            List<AnswerOption> options,
            String correctId,
            String explanation)?
        imageMatch,
    TResult? Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            List<String> correctIds,
            String explanation)?
        multiSelect,
  }) {
    return multipleChoice?.call(
        id, text, tags, imageUrl, options, correctId, explanation);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            String correctId,
            String explanation)?
        multipleChoice,
    TResult Function(String id, String statement, List<String> tags,
            bool correctAnswer, String explanation)?
        trueFalse,
    TResult Function(String id, String instruction, List<String> tags,
            List<SequenceItem> items, String explanation)?
        sequence,
    TResult Function(
            String id,
            String imageUrl,
            String question,
            List<String> tags,
            List<AnswerOption> options,
            String correctId,
            String explanation)?
        imageMatch,
    TResult Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            List<String> correctIds,
            String explanation)?
        multiSelect,
    required TResult orElse(),
  }) {
    if (multipleChoice != null) {
      return multipleChoice(
          id, text, tags, imageUrl, options, correctId, explanation);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MultipleChoiceQuestion value) multipleChoice,
    required TResult Function(TrueFalseQuestion value) trueFalse,
    required TResult Function(SequenceQuestion value) sequence,
    required TResult Function(ImageMatchQuestion value) imageMatch,
    required TResult Function(MultiSelectQuestion value) multiSelect,
  }) {
    return multipleChoice(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MultipleChoiceQuestion value)? multipleChoice,
    TResult? Function(TrueFalseQuestion value)? trueFalse,
    TResult? Function(SequenceQuestion value)? sequence,
    TResult? Function(ImageMatchQuestion value)? imageMatch,
    TResult? Function(MultiSelectQuestion value)? multiSelect,
  }) {
    return multipleChoice?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MultipleChoiceQuestion value)? multipleChoice,
    TResult Function(TrueFalseQuestion value)? trueFalse,
    TResult Function(SequenceQuestion value)? sequence,
    TResult Function(ImageMatchQuestion value)? imageMatch,
    TResult Function(MultiSelectQuestion value)? multiSelect,
    required TResult orElse(),
  }) {
    if (multipleChoice != null) {
      return multipleChoice(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MultipleChoiceQuestionImplToJson(
      this,
    );
  }
}

abstract class MultipleChoiceQuestion implements QuizQuestion {
  const factory MultipleChoiceQuestion(
      {required final String id,
      required final String text,
      final List<String> tags,
      final String? imageUrl,
      required final List<AnswerOption> options,
      required final String correctId,
      required final String explanation}) = _$MultipleChoiceQuestionImpl;

  factory MultipleChoiceQuestion.fromJson(Map<String, dynamic> json) =
      _$MultipleChoiceQuestionImpl.fromJson;

  @override
  String get id;
  String get text;
  @override
  List<String> get tags; // For weak topics
  String? get imageUrl;
  List<AnswerOption> get options;
  String get correctId;
  @override
  String get explanation;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MultipleChoiceQuestionImplCopyWith<_$MultipleChoiceQuestionImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TrueFalseQuestionImplCopyWith<$Res>
    implements $QuizQuestionCopyWith<$Res> {
  factory _$$TrueFalseQuestionImplCopyWith(_$TrueFalseQuestionImpl value,
          $Res Function(_$TrueFalseQuestionImpl) then) =
      __$$TrueFalseQuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String statement,
      List<String> tags,
      bool correctAnswer,
      String explanation});
}

/// @nodoc
class __$$TrueFalseQuestionImplCopyWithImpl<$Res>
    extends _$QuizQuestionCopyWithImpl<$Res, _$TrueFalseQuestionImpl>
    implements _$$TrueFalseQuestionImplCopyWith<$Res> {
  __$$TrueFalseQuestionImplCopyWithImpl(_$TrueFalseQuestionImpl _value,
      $Res Function(_$TrueFalseQuestionImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? statement = null,
    Object? tags = null,
    Object? correctAnswer = null,
    Object? explanation = null,
  }) {
    return _then(_$TrueFalseQuestionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      statement: null == statement
          ? _value.statement
          : statement // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      correctAnswer: null == correctAnswer
          ? _value.correctAnswer
          : correctAnswer // ignore: cast_nullable_to_non_nullable
              as bool,
      explanation: null == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrueFalseQuestionImpl implements TrueFalseQuestion {
  const _$TrueFalseQuestionImpl(
      {required this.id,
      required this.statement,
      final List<String> tags = const [],
      required this.correctAnswer,
      required this.explanation,
      final String? $type})
      : _tags = tags,
        $type = $type ?? 'trueFalse';

  factory _$TrueFalseQuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrueFalseQuestionImplFromJson(json);

  @override
  final String id;
  @override
  final String statement;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final bool correctAnswer;
  @override
  final String explanation;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'QuizQuestion.trueFalse(id: $id, statement: $statement, tags: $tags, correctAnswer: $correctAnswer, explanation: $explanation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrueFalseQuestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.statement, statement) ||
                other.statement == statement) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.correctAnswer, correctAnswer) ||
                other.correctAnswer == correctAnswer) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, statement,
      const DeepCollectionEquality().hash(_tags), correctAnswer, explanation);

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrueFalseQuestionImplCopyWith<_$TrueFalseQuestionImpl> get copyWith =>
      __$$TrueFalseQuestionImplCopyWithImpl<_$TrueFalseQuestionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            String correctId,
            String explanation)
        multipleChoice,
    required TResult Function(String id, String statement, List<String> tags,
            bool correctAnswer, String explanation)
        trueFalse,
    required TResult Function(String id, String instruction, List<String> tags,
            List<SequenceItem> items, String explanation)
        sequence,
    required TResult Function(
            String id,
            String imageUrl,
            String question,
            List<String> tags,
            List<AnswerOption> options,
            String correctId,
            String explanation)
        imageMatch,
    required TResult Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            List<String> correctIds,
            String explanation)
        multiSelect,
  }) {
    return trueFalse(id, statement, tags, correctAnswer, explanation);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            String correctId,
            String explanation)?
        multipleChoice,
    TResult? Function(String id, String statement, List<String> tags,
            bool correctAnswer, String explanation)?
        trueFalse,
    TResult? Function(String id, String instruction, List<String> tags,
            List<SequenceItem> items, String explanation)?
        sequence,
    TResult? Function(
            String id,
            String imageUrl,
            String question,
            List<String> tags,
            List<AnswerOption> options,
            String correctId,
            String explanation)?
        imageMatch,
    TResult? Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            List<String> correctIds,
            String explanation)?
        multiSelect,
  }) {
    return trueFalse?.call(id, statement, tags, correctAnswer, explanation);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            String correctId,
            String explanation)?
        multipleChoice,
    TResult Function(String id, String statement, List<String> tags,
            bool correctAnswer, String explanation)?
        trueFalse,
    TResult Function(String id, String instruction, List<String> tags,
            List<SequenceItem> items, String explanation)?
        sequence,
    TResult Function(
            String id,
            String imageUrl,
            String question,
            List<String> tags,
            List<AnswerOption> options,
            String correctId,
            String explanation)?
        imageMatch,
    TResult Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            List<String> correctIds,
            String explanation)?
        multiSelect,
    required TResult orElse(),
  }) {
    if (trueFalse != null) {
      return trueFalse(id, statement, tags, correctAnswer, explanation);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MultipleChoiceQuestion value) multipleChoice,
    required TResult Function(TrueFalseQuestion value) trueFalse,
    required TResult Function(SequenceQuestion value) sequence,
    required TResult Function(ImageMatchQuestion value) imageMatch,
    required TResult Function(MultiSelectQuestion value) multiSelect,
  }) {
    return trueFalse(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MultipleChoiceQuestion value)? multipleChoice,
    TResult? Function(TrueFalseQuestion value)? trueFalse,
    TResult? Function(SequenceQuestion value)? sequence,
    TResult? Function(ImageMatchQuestion value)? imageMatch,
    TResult? Function(MultiSelectQuestion value)? multiSelect,
  }) {
    return trueFalse?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MultipleChoiceQuestion value)? multipleChoice,
    TResult Function(TrueFalseQuestion value)? trueFalse,
    TResult Function(SequenceQuestion value)? sequence,
    TResult Function(ImageMatchQuestion value)? imageMatch,
    TResult Function(MultiSelectQuestion value)? multiSelect,
    required TResult orElse(),
  }) {
    if (trueFalse != null) {
      return trueFalse(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TrueFalseQuestionImplToJson(
      this,
    );
  }
}

abstract class TrueFalseQuestion implements QuizQuestion {
  const factory TrueFalseQuestion(
      {required final String id,
      required final String statement,
      final List<String> tags,
      required final bool correctAnswer,
      required final String explanation}) = _$TrueFalseQuestionImpl;

  factory TrueFalseQuestion.fromJson(Map<String, dynamic> json) =
      _$TrueFalseQuestionImpl.fromJson;

  @override
  String get id;
  String get statement;
  @override
  List<String> get tags;
  bool get correctAnswer;
  @override
  String get explanation;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrueFalseQuestionImplCopyWith<_$TrueFalseQuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SequenceQuestionImplCopyWith<$Res>
    implements $QuizQuestionCopyWith<$Res> {
  factory _$$SequenceQuestionImplCopyWith(_$SequenceQuestionImpl value,
          $Res Function(_$SequenceQuestionImpl) then) =
      __$$SequenceQuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String instruction,
      List<String> tags,
      List<SequenceItem> items,
      String explanation});
}

/// @nodoc
class __$$SequenceQuestionImplCopyWithImpl<$Res>
    extends _$QuizQuestionCopyWithImpl<$Res, _$SequenceQuestionImpl>
    implements _$$SequenceQuestionImplCopyWith<$Res> {
  __$$SequenceQuestionImplCopyWithImpl(_$SequenceQuestionImpl _value,
      $Res Function(_$SequenceQuestionImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? instruction = null,
    Object? tags = null,
    Object? items = null,
    Object? explanation = null,
  }) {
    return _then(_$SequenceQuestionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      instruction: null == instruction
          ? _value.instruction
          : instruction // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<SequenceItem>,
      explanation: null == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SequenceQuestionImpl implements SequenceQuestion {
  const _$SequenceQuestionImpl(
      {required this.id,
      required this.instruction,
      final List<String> tags = const [],
      required final List<SequenceItem> items,
      required this.explanation,
      final String? $type})
      : _tags = tags,
        _items = items,
        $type = $type ?? 'sequence';

  factory _$SequenceQuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SequenceQuestionImplFromJson(json);

  @override
  final String id;
  @override
  final String instruction;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<SequenceItem> _items;
  @override
  List<SequenceItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String explanation;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'QuizQuestion.sequence(id: $id, instruction: $instruction, tags: $tags, items: $items, explanation: $explanation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SequenceQuestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.instruction, instruction) ||
                other.instruction == instruction) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      instruction,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_items),
      explanation);

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SequenceQuestionImplCopyWith<_$SequenceQuestionImpl> get copyWith =>
      __$$SequenceQuestionImplCopyWithImpl<_$SequenceQuestionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            String correctId,
            String explanation)
        multipleChoice,
    required TResult Function(String id, String statement, List<String> tags,
            bool correctAnswer, String explanation)
        trueFalse,
    required TResult Function(String id, String instruction, List<String> tags,
            List<SequenceItem> items, String explanation)
        sequence,
    required TResult Function(
            String id,
            String imageUrl,
            String question,
            List<String> tags,
            List<AnswerOption> options,
            String correctId,
            String explanation)
        imageMatch,
    required TResult Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            List<String> correctIds,
            String explanation)
        multiSelect,
  }) {
    return sequence(id, instruction, tags, items, explanation);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            String correctId,
            String explanation)?
        multipleChoice,
    TResult? Function(String id, String statement, List<String> tags,
            bool correctAnswer, String explanation)?
        trueFalse,
    TResult? Function(String id, String instruction, List<String> tags,
            List<SequenceItem> items, String explanation)?
        sequence,
    TResult? Function(
            String id,
            String imageUrl,
            String question,
            List<String> tags,
            List<AnswerOption> options,
            String correctId,
            String explanation)?
        imageMatch,
    TResult? Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            List<String> correctIds,
            String explanation)?
        multiSelect,
  }) {
    return sequence?.call(id, instruction, tags, items, explanation);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            String correctId,
            String explanation)?
        multipleChoice,
    TResult Function(String id, String statement, List<String> tags,
            bool correctAnswer, String explanation)?
        trueFalse,
    TResult Function(String id, String instruction, List<String> tags,
            List<SequenceItem> items, String explanation)?
        sequence,
    TResult Function(
            String id,
            String imageUrl,
            String question,
            List<String> tags,
            List<AnswerOption> options,
            String correctId,
            String explanation)?
        imageMatch,
    TResult Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            List<String> correctIds,
            String explanation)?
        multiSelect,
    required TResult orElse(),
  }) {
    if (sequence != null) {
      return sequence(id, instruction, tags, items, explanation);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MultipleChoiceQuestion value) multipleChoice,
    required TResult Function(TrueFalseQuestion value) trueFalse,
    required TResult Function(SequenceQuestion value) sequence,
    required TResult Function(ImageMatchQuestion value) imageMatch,
    required TResult Function(MultiSelectQuestion value) multiSelect,
  }) {
    return sequence(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MultipleChoiceQuestion value)? multipleChoice,
    TResult? Function(TrueFalseQuestion value)? trueFalse,
    TResult? Function(SequenceQuestion value)? sequence,
    TResult? Function(ImageMatchQuestion value)? imageMatch,
    TResult? Function(MultiSelectQuestion value)? multiSelect,
  }) {
    return sequence?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MultipleChoiceQuestion value)? multipleChoice,
    TResult Function(TrueFalseQuestion value)? trueFalse,
    TResult Function(SequenceQuestion value)? sequence,
    TResult Function(ImageMatchQuestion value)? imageMatch,
    TResult Function(MultiSelectQuestion value)? multiSelect,
    required TResult orElse(),
  }) {
    if (sequence != null) {
      return sequence(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SequenceQuestionImplToJson(
      this,
    );
  }
}

abstract class SequenceQuestion implements QuizQuestion {
  const factory SequenceQuestion(
      {required final String id,
      required final String instruction,
      final List<String> tags,
      required final List<SequenceItem> items,
      required final String explanation}) = _$SequenceQuestionImpl;

  factory SequenceQuestion.fromJson(Map<String, dynamic> json) =
      _$SequenceQuestionImpl.fromJson;

  @override
  String get id;
  String get instruction;
  @override
  List<String> get tags;
  List<SequenceItem> get items;
  @override
  String get explanation;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SequenceQuestionImplCopyWith<_$SequenceQuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ImageMatchQuestionImplCopyWith<$Res>
    implements $QuizQuestionCopyWith<$Res> {
  factory _$$ImageMatchQuestionImplCopyWith(_$ImageMatchQuestionImpl value,
          $Res Function(_$ImageMatchQuestionImpl) then) =
      __$$ImageMatchQuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String imageUrl,
      String question,
      List<String> tags,
      List<AnswerOption> options,
      String correctId,
      String explanation});
}

/// @nodoc
class __$$ImageMatchQuestionImplCopyWithImpl<$Res>
    extends _$QuizQuestionCopyWithImpl<$Res, _$ImageMatchQuestionImpl>
    implements _$$ImageMatchQuestionImplCopyWith<$Res> {
  __$$ImageMatchQuestionImplCopyWithImpl(_$ImageMatchQuestionImpl _value,
      $Res Function(_$ImageMatchQuestionImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
    Object? question = null,
    Object? tags = null,
    Object? options = null,
    Object? correctId = null,
    Object? explanation = null,
  }) {
    return _then(_$ImageMatchQuestionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<AnswerOption>,
      correctId: null == correctId
          ? _value.correctId
          : correctId // ignore: cast_nullable_to_non_nullable
              as String,
      explanation: null == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ImageMatchQuestionImpl implements ImageMatchQuestion {
  const _$ImageMatchQuestionImpl(
      {required this.id,
      required this.imageUrl,
      required this.question,
      final List<String> tags = const [],
      required final List<AnswerOption> options,
      required this.correctId,
      required this.explanation,
      final String? $type})
      : _tags = tags,
        _options = options,
        $type = $type ?? 'imageMatch';

  factory _$ImageMatchQuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImageMatchQuestionImplFromJson(json);

  @override
  final String id;
  @override
  final String imageUrl;
  @override
  final String question;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<AnswerOption> _options;
  @override
  List<AnswerOption> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  final String correctId;
  @override
  final String explanation;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'QuizQuestion.imageMatch(id: $id, imageUrl: $imageUrl, question: $question, tags: $tags, options: $options, correctId: $correctId, explanation: $explanation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageMatchQuestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.question, question) ||
                other.question == question) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.correctId, correctId) ||
                other.correctId == correctId) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      imageUrl,
      question,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_options),
      correctId,
      explanation);

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImageMatchQuestionImplCopyWith<_$ImageMatchQuestionImpl> get copyWith =>
      __$$ImageMatchQuestionImplCopyWithImpl<_$ImageMatchQuestionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            String correctId,
            String explanation)
        multipleChoice,
    required TResult Function(String id, String statement, List<String> tags,
            bool correctAnswer, String explanation)
        trueFalse,
    required TResult Function(String id, String instruction, List<String> tags,
            List<SequenceItem> items, String explanation)
        sequence,
    required TResult Function(
            String id,
            String imageUrl,
            String question,
            List<String> tags,
            List<AnswerOption> options,
            String correctId,
            String explanation)
        imageMatch,
    required TResult Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            List<String> correctIds,
            String explanation)
        multiSelect,
  }) {
    return imageMatch(
        id, imageUrl, question, tags, options, correctId, explanation);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            String correctId,
            String explanation)?
        multipleChoice,
    TResult? Function(String id, String statement, List<String> tags,
            bool correctAnswer, String explanation)?
        trueFalse,
    TResult? Function(String id, String instruction, List<String> tags,
            List<SequenceItem> items, String explanation)?
        sequence,
    TResult? Function(
            String id,
            String imageUrl,
            String question,
            List<String> tags,
            List<AnswerOption> options,
            String correctId,
            String explanation)?
        imageMatch,
    TResult? Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            List<String> correctIds,
            String explanation)?
        multiSelect,
  }) {
    return imageMatch?.call(
        id, imageUrl, question, tags, options, correctId, explanation);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            String correctId,
            String explanation)?
        multipleChoice,
    TResult Function(String id, String statement, List<String> tags,
            bool correctAnswer, String explanation)?
        trueFalse,
    TResult Function(String id, String instruction, List<String> tags,
            List<SequenceItem> items, String explanation)?
        sequence,
    TResult Function(
            String id,
            String imageUrl,
            String question,
            List<String> tags,
            List<AnswerOption> options,
            String correctId,
            String explanation)?
        imageMatch,
    TResult Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            List<String> correctIds,
            String explanation)?
        multiSelect,
    required TResult orElse(),
  }) {
    if (imageMatch != null) {
      return imageMatch(
          id, imageUrl, question, tags, options, correctId, explanation);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MultipleChoiceQuestion value) multipleChoice,
    required TResult Function(TrueFalseQuestion value) trueFalse,
    required TResult Function(SequenceQuestion value) sequence,
    required TResult Function(ImageMatchQuestion value) imageMatch,
    required TResult Function(MultiSelectQuestion value) multiSelect,
  }) {
    return imageMatch(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MultipleChoiceQuestion value)? multipleChoice,
    TResult? Function(TrueFalseQuestion value)? trueFalse,
    TResult? Function(SequenceQuestion value)? sequence,
    TResult? Function(ImageMatchQuestion value)? imageMatch,
    TResult? Function(MultiSelectQuestion value)? multiSelect,
  }) {
    return imageMatch?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MultipleChoiceQuestion value)? multipleChoice,
    TResult Function(TrueFalseQuestion value)? trueFalse,
    TResult Function(SequenceQuestion value)? sequence,
    TResult Function(ImageMatchQuestion value)? imageMatch,
    TResult Function(MultiSelectQuestion value)? multiSelect,
    required TResult orElse(),
  }) {
    if (imageMatch != null) {
      return imageMatch(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ImageMatchQuestionImplToJson(
      this,
    );
  }
}

abstract class ImageMatchQuestion implements QuizQuestion {
  const factory ImageMatchQuestion(
      {required final String id,
      required final String imageUrl,
      required final String question,
      final List<String> tags,
      required final List<AnswerOption> options,
      required final String correctId,
      required final String explanation}) = _$ImageMatchQuestionImpl;

  factory ImageMatchQuestion.fromJson(Map<String, dynamic> json) =
      _$ImageMatchQuestionImpl.fromJson;

  @override
  String get id;
  String get imageUrl;
  String get question;
  @override
  List<String> get tags;
  List<AnswerOption> get options;
  String get correctId;
  @override
  String get explanation;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImageMatchQuestionImplCopyWith<_$ImageMatchQuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MultiSelectQuestionImplCopyWith<$Res>
    implements $QuizQuestionCopyWith<$Res> {
  factory _$$MultiSelectQuestionImplCopyWith(_$MultiSelectQuestionImpl value,
          $Res Function(_$MultiSelectQuestionImpl) then) =
      __$$MultiSelectQuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String text,
      List<String> tags,
      String? imageUrl,
      List<AnswerOption> options,
      List<String> correctIds,
      String explanation});
}

/// @nodoc
class __$$MultiSelectQuestionImplCopyWithImpl<$Res>
    extends _$QuizQuestionCopyWithImpl<$Res, _$MultiSelectQuestionImpl>
    implements _$$MultiSelectQuestionImplCopyWith<$Res> {
  __$$MultiSelectQuestionImplCopyWithImpl(_$MultiSelectQuestionImpl _value,
      $Res Function(_$MultiSelectQuestionImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? tags = null,
    Object? imageUrl = freezed,
    Object? options = null,
    Object? correctIds = null,
    Object? explanation = null,
  }) {
    return _then(_$MultiSelectQuestionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<AnswerOption>,
      correctIds: null == correctIds
          ? _value._correctIds
          : correctIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      explanation: null == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MultiSelectQuestionImpl implements MultiSelectQuestion {
  const _$MultiSelectQuestionImpl(
      {required this.id,
      required this.text,
      final List<String> tags = const [],
      this.imageUrl,
      required final List<AnswerOption> options,
      required final List<String> correctIds,
      required this.explanation,
      final String? $type})
      : _tags = tags,
        _options = options,
        _correctIds = correctIds,
        $type = $type ?? 'multiSelect';

  factory _$MultiSelectQuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$MultiSelectQuestionImplFromJson(json);

  @override
  final String id;
  @override
  final String text;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final String? imageUrl;
  final List<AnswerOption> _options;
  @override
  List<AnswerOption> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  final List<String> _correctIds;
  @override
  List<String> get correctIds {
    if (_correctIds is EqualUnmodifiableListView) return _correctIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_correctIds);
  }

  @override
  final String explanation;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'QuizQuestion.multiSelect(id: $id, text: $text, tags: $tags, imageUrl: $imageUrl, options: $options, correctIds: $correctIds, explanation: $explanation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MultiSelectQuestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            const DeepCollectionEquality()
                .equals(other._correctIds, _correctIds) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      text,
      const DeepCollectionEquality().hash(_tags),
      imageUrl,
      const DeepCollectionEquality().hash(_options),
      const DeepCollectionEquality().hash(_correctIds),
      explanation);

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MultiSelectQuestionImplCopyWith<_$MultiSelectQuestionImpl> get copyWith =>
      __$$MultiSelectQuestionImplCopyWithImpl<_$MultiSelectQuestionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            String correctId,
            String explanation)
        multipleChoice,
    required TResult Function(String id, String statement, List<String> tags,
            bool correctAnswer, String explanation)
        trueFalse,
    required TResult Function(String id, String instruction, List<String> tags,
            List<SequenceItem> items, String explanation)
        sequence,
    required TResult Function(
            String id,
            String imageUrl,
            String question,
            List<String> tags,
            List<AnswerOption> options,
            String correctId,
            String explanation)
        imageMatch,
    required TResult Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            List<String> correctIds,
            String explanation)
        multiSelect,
  }) {
    return multiSelect(
        id, text, tags, imageUrl, options, correctIds, explanation);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            String correctId,
            String explanation)?
        multipleChoice,
    TResult? Function(String id, String statement, List<String> tags,
            bool correctAnswer, String explanation)?
        trueFalse,
    TResult? Function(String id, String instruction, List<String> tags,
            List<SequenceItem> items, String explanation)?
        sequence,
    TResult? Function(
            String id,
            String imageUrl,
            String question,
            List<String> tags,
            List<AnswerOption> options,
            String correctId,
            String explanation)?
        imageMatch,
    TResult? Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            List<String> correctIds,
            String explanation)?
        multiSelect,
  }) {
    return multiSelect?.call(
        id, text, tags, imageUrl, options, correctIds, explanation);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            String correctId,
            String explanation)?
        multipleChoice,
    TResult Function(String id, String statement, List<String> tags,
            bool correctAnswer, String explanation)?
        trueFalse,
    TResult Function(String id, String instruction, List<String> tags,
            List<SequenceItem> items, String explanation)?
        sequence,
    TResult Function(
            String id,
            String imageUrl,
            String question,
            List<String> tags,
            List<AnswerOption> options,
            String correctId,
            String explanation)?
        imageMatch,
    TResult Function(
            String id,
            String text,
            List<String> tags,
            String? imageUrl,
            List<AnswerOption> options,
            List<String> correctIds,
            String explanation)?
        multiSelect,
    required TResult orElse(),
  }) {
    if (multiSelect != null) {
      return multiSelect(
          id, text, tags, imageUrl, options, correctIds, explanation);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MultipleChoiceQuestion value) multipleChoice,
    required TResult Function(TrueFalseQuestion value) trueFalse,
    required TResult Function(SequenceQuestion value) sequence,
    required TResult Function(ImageMatchQuestion value) imageMatch,
    required TResult Function(MultiSelectQuestion value) multiSelect,
  }) {
    return multiSelect(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MultipleChoiceQuestion value)? multipleChoice,
    TResult? Function(TrueFalseQuestion value)? trueFalse,
    TResult? Function(SequenceQuestion value)? sequence,
    TResult? Function(ImageMatchQuestion value)? imageMatch,
    TResult? Function(MultiSelectQuestion value)? multiSelect,
  }) {
    return multiSelect?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MultipleChoiceQuestion value)? multipleChoice,
    TResult Function(TrueFalseQuestion value)? trueFalse,
    TResult Function(SequenceQuestion value)? sequence,
    TResult Function(ImageMatchQuestion value)? imageMatch,
    TResult Function(MultiSelectQuestion value)? multiSelect,
    required TResult orElse(),
  }) {
    if (multiSelect != null) {
      return multiSelect(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MultiSelectQuestionImplToJson(
      this,
    );
  }
}

abstract class MultiSelectQuestion implements QuizQuestion {
  const factory MultiSelectQuestion(
      {required final String id,
      required final String text,
      final List<String> tags,
      final String? imageUrl,
      required final List<AnswerOption> options,
      required final List<String> correctIds,
      required final String explanation}) = _$MultiSelectQuestionImpl;

  factory MultiSelectQuestion.fromJson(Map<String, dynamic> json) =
      _$MultiSelectQuestionImpl.fromJson;

  @override
  String get id;
  String get text;
  @override
  List<String> get tags;
  String? get imageUrl;
  List<AnswerOption> get options;
  List<String> get correctIds;
  @override
  String get explanation;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MultiSelectQuestionImplCopyWith<_$MultiSelectQuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
