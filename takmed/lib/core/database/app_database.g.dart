// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CoursesTable extends Courses with TableInfo<$CoursesTable, CourseDB> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CoursesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _trackMeta = const VerificationMeta('track');
  @override
  late final GeneratedColumn<String> track = GeneratedColumn<String>(
      'track', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderIndexMeta =
      const VerificationMeta('orderIndex');
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
      'order_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isDownloadedMeta =
      const VerificationMeta('isDownloaded');
  @override
  late final GeneratedColumn<bool> isDownloaded = GeneratedColumn<bool>(
      'is_downloaded', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_downloaded" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _totalLessonsMeta =
      const VerificationMeta('totalLessons');
  @override
  late final GeneratedColumn<int> totalLessons = GeneratedColumn<int>(
      'total_lessons', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _completedLessonsMeta =
      const VerificationMeta('completedLessons');
  @override
  late final GeneratedColumn<int> completedLessons = GeneratedColumn<int>(
      'completed_lessons', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        remoteId,
        title,
        description,
        track,
        orderIndex,
        isDownloaded,
        totalLessons,
        completedLessons,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'courses';
  @override
  VerificationContext validateIntegrity(Insertable<CourseDB> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    } else if (isInserting) {
      context.missing(_remoteIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('track')) {
      context.handle(
          _trackMeta, track.isAcceptableOrUnknown(data['track']!, _trackMeta));
    } else if (isInserting) {
      context.missing(_trackMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
          _orderIndexMeta,
          orderIndex.isAcceptableOrUnknown(
              data['order_index']!, _orderIndexMeta));
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('is_downloaded')) {
      context.handle(
          _isDownloadedMeta,
          isDownloaded.isAcceptableOrUnknown(
              data['is_downloaded']!, _isDownloadedMeta));
    }
    if (data.containsKey('total_lessons')) {
      context.handle(
          _totalLessonsMeta,
          totalLessons.isAcceptableOrUnknown(
              data['total_lessons']!, _totalLessonsMeta));
    }
    if (data.containsKey('completed_lessons')) {
      context.handle(
          _completedLessonsMeta,
          completedLessons.isAcceptableOrUnknown(
              data['completed_lessons']!, _completedLessonsMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {remoteId},
      ];
  @override
  CourseDB map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CourseDB(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      track: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}track'])!,
      orderIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_index'])!,
      isDownloaded: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_downloaded'])!,
      totalLessons: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_lessons'])!,
      completedLessons: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}completed_lessons'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CoursesTable createAlias(String alias) {
    return $CoursesTable(attachedDatabase, alias);
  }
}

class CourseDB extends DataClass implements Insertable<CourseDB> {
  /// Локальний автоінкрементний ID.
  final int id;

  /// Віддалений ID для синхронізації.
  final String remoteId;

  /// Назва курсу.
  final String title;

  /// Опис курсу.
  final String description;

  /// Трек: 'military' або 'civilian'.
  final String track;

  /// Порядковий номер для сортування.
  final int orderIndex;

  /// Чи завантажений для офлайн.
  final bool isDownloaded;

  /// Загальна кількість уроків.
  final int totalLessons;

  /// Кількість завершених уроків.
  final int completedLessons;

  /// Час останнього оновлення.
  final DateTime updatedAt;
  const CourseDB(
      {required this.id,
      required this.remoteId,
      required this.title,
      required this.description,
      required this.track,
      required this.orderIndex,
      required this.isDownloaded,
      required this.totalLessons,
      required this.completedLessons,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['remote_id'] = Variable<String>(remoteId);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['track'] = Variable<String>(track);
    map['order_index'] = Variable<int>(orderIndex);
    map['is_downloaded'] = Variable<bool>(isDownloaded);
    map['total_lessons'] = Variable<int>(totalLessons);
    map['completed_lessons'] = Variable<int>(completedLessons);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CoursesCompanion toCompanion(bool nullToAbsent) {
    return CoursesCompanion(
      id: Value(id),
      remoteId: Value(remoteId),
      title: Value(title),
      description: Value(description),
      track: Value(track),
      orderIndex: Value(orderIndex),
      isDownloaded: Value(isDownloaded),
      totalLessons: Value(totalLessons),
      completedLessons: Value(completedLessons),
      updatedAt: Value(updatedAt),
    );
  }

  factory CourseDB.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CourseDB(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<String>(json['remoteId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      track: serializer.fromJson<String>(json['track']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      isDownloaded: serializer.fromJson<bool>(json['isDownloaded']),
      totalLessons: serializer.fromJson<int>(json['totalLessons']),
      completedLessons: serializer.fromJson<int>(json['completedLessons']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<String>(remoteId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'track': serializer.toJson<String>(track),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'isDownloaded': serializer.toJson<bool>(isDownloaded),
      'totalLessons': serializer.toJson<int>(totalLessons),
      'completedLessons': serializer.toJson<int>(completedLessons),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CourseDB copyWith(
          {int? id,
          String? remoteId,
          String? title,
          String? description,
          String? track,
          int? orderIndex,
          bool? isDownloaded,
          int? totalLessons,
          int? completedLessons,
          DateTime? updatedAt}) =>
      CourseDB(
        id: id ?? this.id,
        remoteId: remoteId ?? this.remoteId,
        title: title ?? this.title,
        description: description ?? this.description,
        track: track ?? this.track,
        orderIndex: orderIndex ?? this.orderIndex,
        isDownloaded: isDownloaded ?? this.isDownloaded,
        totalLessons: totalLessons ?? this.totalLessons,
        completedLessons: completedLessons ?? this.completedLessons,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  CourseDB copyWithCompanion(CoursesCompanion data) {
    return CourseDB(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      track: data.track.present ? data.track.value : this.track,
      orderIndex:
          data.orderIndex.present ? data.orderIndex.value : this.orderIndex,
      isDownloaded: data.isDownloaded.present
          ? data.isDownloaded.value
          : this.isDownloaded,
      totalLessons: data.totalLessons.present
          ? data.totalLessons.value
          : this.totalLessons,
      completedLessons: data.completedLessons.present
          ? data.completedLessons.value
          : this.completedLessons,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CourseDB(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('track: $track, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('isDownloaded: $isDownloaded, ')
          ..write('totalLessons: $totalLessons, ')
          ..write('completedLessons: $completedLessons, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, remoteId, title, description, track,
      orderIndex, isDownloaded, totalLessons, completedLessons, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CourseDB &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.title == this.title &&
          other.description == this.description &&
          other.track == this.track &&
          other.orderIndex == this.orderIndex &&
          other.isDownloaded == this.isDownloaded &&
          other.totalLessons == this.totalLessons &&
          other.completedLessons == this.completedLessons &&
          other.updatedAt == this.updatedAt);
}

class CoursesCompanion extends UpdateCompanion<CourseDB> {
  final Value<int> id;
  final Value<String> remoteId;
  final Value<String> title;
  final Value<String> description;
  final Value<String> track;
  final Value<int> orderIndex;
  final Value<bool> isDownloaded;
  final Value<int> totalLessons;
  final Value<int> completedLessons;
  final Value<DateTime> updatedAt;
  const CoursesCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.track = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.isDownloaded = const Value.absent(),
    this.totalLessons = const Value.absent(),
    this.completedLessons = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CoursesCompanion.insert({
    this.id = const Value.absent(),
    required String remoteId,
    required String title,
    required String description,
    required String track,
    required int orderIndex,
    this.isDownloaded = const Value.absent(),
    this.totalLessons = const Value.absent(),
    this.completedLessons = const Value.absent(),
    required DateTime updatedAt,
  })  : remoteId = Value(remoteId),
        title = Value(title),
        description = Value(description),
        track = Value(track),
        orderIndex = Value(orderIndex),
        updatedAt = Value(updatedAt);
  static Insertable<CourseDB> custom({
    Expression<int>? id,
    Expression<String>? remoteId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? track,
    Expression<int>? orderIndex,
    Expression<bool>? isDownloaded,
    Expression<int>? totalLessons,
    Expression<int>? completedLessons,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (track != null) 'track': track,
      if (orderIndex != null) 'order_index': orderIndex,
      if (isDownloaded != null) 'is_downloaded': isDownloaded,
      if (totalLessons != null) 'total_lessons': totalLessons,
      if (completedLessons != null) 'completed_lessons': completedLessons,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CoursesCompanion copyWith(
      {Value<int>? id,
      Value<String>? remoteId,
      Value<String>? title,
      Value<String>? description,
      Value<String>? track,
      Value<int>? orderIndex,
      Value<bool>? isDownloaded,
      Value<int>? totalLessons,
      Value<int>? completedLessons,
      Value<DateTime>? updatedAt}) {
    return CoursesCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      title: title ?? this.title,
      description: description ?? this.description,
      track: track ?? this.track,
      orderIndex: orderIndex ?? this.orderIndex,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      totalLessons: totalLessons ?? this.totalLessons,
      completedLessons: completedLessons ?? this.completedLessons,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (track.present) {
      map['track'] = Variable<String>(track.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (isDownloaded.present) {
      map['is_downloaded'] = Variable<bool>(isDownloaded.value);
    }
    if (totalLessons.present) {
      map['total_lessons'] = Variable<int>(totalLessons.value);
    }
    if (completedLessons.present) {
      map['completed_lessons'] = Variable<int>(completedLessons.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoursesCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('track: $track, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('isDownloaded: $isDownloaded, ')
          ..write('totalLessons: $totalLessons, ')
          ..write('completedLessons: $completedLessons, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $LessonsTable extends Lessons with TableInfo<$LessonsTable, LessonDB> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _courseIdMeta =
      const VerificationMeta('courseId');
  @override
  late final GeneratedColumn<int> courseId = GeneratedColumn<int>(
      'course_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES courses (id)'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentJsonMeta =
      const VerificationMeta('contentJson');
  @override
  late final GeneratedColumn<String> contentJson = GeneratedColumn<String>(
      'content_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _durationSecondsMeta =
      const VerificationMeta('durationSeconds');
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
      'duration_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _orderIndexMeta =
      const VerificationMeta('orderIndex');
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
      'order_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _xpRewardMeta =
      const VerificationMeta('xpReward');
  @override
  late final GeneratedColumn<int> xpReward = GeneratedColumn<int>(
      'xp_reward', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(10));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        remoteId,
        courseId,
        type,
        title,
        contentJson,
        durationSeconds,
        orderIndex,
        isCompleted,
        xpReward,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lessons';
  @override
  VerificationContext validateIntegrity(Insertable<LessonDB> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    } else if (isInserting) {
      context.missing(_remoteIdMeta);
    }
    if (data.containsKey('course_id')) {
      context.handle(_courseIdMeta,
          courseId.isAcceptableOrUnknown(data['course_id']!, _courseIdMeta));
    } else if (isInserting) {
      context.missing(_courseIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content_json')) {
      context.handle(
          _contentJsonMeta,
          contentJson.isAcceptableOrUnknown(
              data['content_json']!, _contentJsonMeta));
    } else if (isInserting) {
      context.missing(_contentJsonMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
          _durationSecondsMeta,
          durationSeconds.isAcceptableOrUnknown(
              data['duration_seconds']!, _durationSecondsMeta));
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
          _orderIndexMeta,
          orderIndex.isAcceptableOrUnknown(
              data['order_index']!, _orderIndexMeta));
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('xp_reward')) {
      context.handle(_xpRewardMeta,
          xpReward.isAcceptableOrUnknown(data['xp_reward']!, _xpRewardMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {remoteId},
      ];
  @override
  LessonDB map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonDB(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id'])!,
      courseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}course_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      contentJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_json'])!,
      durationSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_seconds'])!,
      orderIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_index'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      xpReward: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}xp_reward'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $LessonsTable createAlias(String alias) {
    return $LessonsTable(attachedDatabase, alias);
  }
}

class LessonDB extends DataClass implements Insertable<LessonDB> {
  /// Локальний автоінкрементний ID.
  final int id;

  /// Віддалений ID для синхронізації.
  final String remoteId;

  /// ID курсу (зовнішній ключ).
  final int courseId;

  /// Тип уроку: 'theory', 'video', 'quiz', 'checklist'.
  final String type;

  /// Назва уроку.
  final String title;

  /// Серіалізований JSON контент.
  final String contentJson;

  /// Тривалість у секундах.
  final int durationSeconds;

  /// Порядковий номер для сортування.
  final int orderIndex;

  /// Чи завершений урок.
  final bool isCompleted;

  /// XP нагорода за завершення.
  final int xpReward;

  /// Час останнього оновлення.
  final DateTime updatedAt;
  const LessonDB(
      {required this.id,
      required this.remoteId,
      required this.courseId,
      required this.type,
      required this.title,
      required this.contentJson,
      required this.durationSeconds,
      required this.orderIndex,
      required this.isCompleted,
      required this.xpReward,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['remote_id'] = Variable<String>(remoteId);
    map['course_id'] = Variable<int>(courseId);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    map['content_json'] = Variable<String>(contentJson);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['order_index'] = Variable<int>(orderIndex);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['xp_reward'] = Variable<int>(xpReward);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LessonsCompanion toCompanion(bool nullToAbsent) {
    return LessonsCompanion(
      id: Value(id),
      remoteId: Value(remoteId),
      courseId: Value(courseId),
      type: Value(type),
      title: Value(title),
      contentJson: Value(contentJson),
      durationSeconds: Value(durationSeconds),
      orderIndex: Value(orderIndex),
      isCompleted: Value(isCompleted),
      xpReward: Value(xpReward),
      updatedAt: Value(updatedAt),
    );
  }

  factory LessonDB.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonDB(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<String>(json['remoteId']),
      courseId: serializer.fromJson<int>(json['courseId']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      contentJson: serializer.fromJson<String>(json['contentJson']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      xpReward: serializer.fromJson<int>(json['xpReward']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<String>(remoteId),
      'courseId': serializer.toJson<int>(courseId),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'contentJson': serializer.toJson<String>(contentJson),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'xpReward': serializer.toJson<int>(xpReward),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LessonDB copyWith(
          {int? id,
          String? remoteId,
          int? courseId,
          String? type,
          String? title,
          String? contentJson,
          int? durationSeconds,
          int? orderIndex,
          bool? isCompleted,
          int? xpReward,
          DateTime? updatedAt}) =>
      LessonDB(
        id: id ?? this.id,
        remoteId: remoteId ?? this.remoteId,
        courseId: courseId ?? this.courseId,
        type: type ?? this.type,
        title: title ?? this.title,
        contentJson: contentJson ?? this.contentJson,
        durationSeconds: durationSeconds ?? this.durationSeconds,
        orderIndex: orderIndex ?? this.orderIndex,
        isCompleted: isCompleted ?? this.isCompleted,
        xpReward: xpReward ?? this.xpReward,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  LessonDB copyWithCompanion(LessonsCompanion data) {
    return LessonDB(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      courseId: data.courseId.present ? data.courseId.value : this.courseId,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      contentJson:
          data.contentJson.present ? data.contentJson.value : this.contentJson,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      orderIndex:
          data.orderIndex.present ? data.orderIndex.value : this.orderIndex,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      xpReward: data.xpReward.present ? data.xpReward.value : this.xpReward,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonDB(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('courseId: $courseId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('contentJson: $contentJson, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('xpReward: $xpReward, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      remoteId,
      courseId,
      type,
      title,
      contentJson,
      durationSeconds,
      orderIndex,
      isCompleted,
      xpReward,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonDB &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.courseId == this.courseId &&
          other.type == this.type &&
          other.title == this.title &&
          other.contentJson == this.contentJson &&
          other.durationSeconds == this.durationSeconds &&
          other.orderIndex == this.orderIndex &&
          other.isCompleted == this.isCompleted &&
          other.xpReward == this.xpReward &&
          other.updatedAt == this.updatedAt);
}

class LessonsCompanion extends UpdateCompanion<LessonDB> {
  final Value<int> id;
  final Value<String> remoteId;
  final Value<int> courseId;
  final Value<String> type;
  final Value<String> title;
  final Value<String> contentJson;
  final Value<int> durationSeconds;
  final Value<int> orderIndex;
  final Value<bool> isCompleted;
  final Value<int> xpReward;
  final Value<DateTime> updatedAt;
  const LessonsCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.courseId = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.contentJson = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.xpReward = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  LessonsCompanion.insert({
    this.id = const Value.absent(),
    required String remoteId,
    required int courseId,
    required String type,
    required String title,
    required String contentJson,
    required int durationSeconds,
    required int orderIndex,
    this.isCompleted = const Value.absent(),
    this.xpReward = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : remoteId = Value(remoteId),
        courseId = Value(courseId),
        type = Value(type),
        title = Value(title),
        contentJson = Value(contentJson),
        durationSeconds = Value(durationSeconds),
        orderIndex = Value(orderIndex);
  static Insertable<LessonDB> custom({
    Expression<int>? id,
    Expression<String>? remoteId,
    Expression<int>? courseId,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? contentJson,
    Expression<int>? durationSeconds,
    Expression<int>? orderIndex,
    Expression<bool>? isCompleted,
    Expression<int>? xpReward,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (courseId != null) 'course_id': courseId,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (contentJson != null) 'content_json': contentJson,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (orderIndex != null) 'order_index': orderIndex,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (xpReward != null) 'xp_reward': xpReward,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  LessonsCompanion copyWith(
      {Value<int>? id,
      Value<String>? remoteId,
      Value<int>? courseId,
      Value<String>? type,
      Value<String>? title,
      Value<String>? contentJson,
      Value<int>? durationSeconds,
      Value<int>? orderIndex,
      Value<bool>? isCompleted,
      Value<int>? xpReward,
      Value<DateTime>? updatedAt}) {
    return LessonsCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      courseId: courseId ?? this.courseId,
      type: type ?? this.type,
      title: title ?? this.title,
      contentJson: contentJson ?? this.contentJson,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      orderIndex: orderIndex ?? this.orderIndex,
      isCompleted: isCompleted ?? this.isCompleted,
      xpReward: xpReward ?? this.xpReward,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (courseId.present) {
      map['course_id'] = Variable<int>(courseId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (contentJson.present) {
      map['content_json'] = Variable<String>(contentJson.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (xpReward.present) {
      map['xp_reward'] = Variable<int>(xpReward.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonsCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('courseId: $courseId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('contentJson: $contentJson, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('xpReward: $xpReward, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $UserProgressTable extends UserProgress
    with TableInfo<$UserProgressTable, UserProgressDB> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _lessonRemoteIdMeta =
      const VerificationMeta('lessonRemoteId');
  @override
  late final GeneratedColumn<String> lessonRemoteId = GeneratedColumn<String>(
      'lesson_remote_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
      'score', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _attemptsMeta =
      const VerificationMeta('attempts');
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
      'attempts', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _isDirtyMeta =
      const VerificationMeta('isDirty');
  @override
  late final GeneratedColumn<bool> isDirty = GeneratedColumn<bool>(
      'is_dirty', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_dirty" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _weakTopicsMeta =
      const VerificationMeta('weakTopics');
  @override
  late final GeneratedColumn<String> weakTopics = GeneratedColumn<String>(
      'weak_topics', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        lessonRemoteId,
        score,
        attempts,
        completedAt,
        updatedAt,
        isDirty,
        syncedAt,
        weakTopics
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_progress';
  @override
  VerificationContext validateIntegrity(Insertable<UserProgressDB> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('lesson_remote_id')) {
      context.handle(
          _lessonRemoteIdMeta,
          lessonRemoteId.isAcceptableOrUnknown(
              data['lesson_remote_id']!, _lessonRemoteIdMeta));
    } else if (isInserting) {
      context.missing(_lessonRemoteIdMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(_attemptsMeta,
          attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta));
    } else if (isInserting) {
      context.missing(_attemptsMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('is_dirty')) {
      context.handle(_isDirtyMeta,
          isDirty.isAcceptableOrUnknown(data['is_dirty']!, _isDirtyMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('weak_topics')) {
      context.handle(
          _weakTopicsMeta,
          weakTopics.isAcceptableOrUnknown(
              data['weak_topics']!, _weakTopicsMeta));
    } else if (isInserting) {
      context.missing(_weakTopicsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {userId, lessonRemoteId},
      ];
  @override
  UserProgressDB map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProgressDB(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      lessonRemoteId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}lesson_remote_id'])!,
      score: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}score'])!,
      attempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempts'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      isDirty: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_dirty'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
      weakTopics: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}weak_topics'])!,
    );
  }

  @override
  $UserProgressTable createAlias(String alias) {
    return $UserProgressTable(attachedDatabase, alias);
  }
}

class UserProgressDB extends DataClass implements Insertable<UserProgressDB> {
  /// Локальний автоінкрементний ID.
  final int id;

  /// ID користувача (Supabase auth.users.id).
  final String userId;

  /// Віддалений ID уроку.
  final String lessonRemoteId;

  /// Оцінка (0-100).
  final int score;

  /// Кількість спроб.
  final int attempts;

  /// Час завершення.
  final DateTime completedAt;

  /// Час останнього оновлення запису прогресу.
  final DateTime updatedAt;

  /// Чи має локальні зміни, які треба відправити на сервер.
  final bool isDirty;

  /// Час останньої успішної синхронізації цього запису.
  final DateTime? syncedAt;

  /// JSON масив слабких тем.
  final String weakTopics;
  const UserProgressDB(
      {required this.id,
      required this.userId,
      required this.lessonRemoteId,
      required this.score,
      required this.attempts,
      required this.completedAt,
      required this.updatedAt,
      required this.isDirty,
      this.syncedAt,
      required this.weakTopics});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['lesson_remote_id'] = Variable<String>(lessonRemoteId);
    map['score'] = Variable<int>(score);
    map['attempts'] = Variable<int>(attempts);
    map['completed_at'] = Variable<DateTime>(completedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_dirty'] = Variable<bool>(isDirty);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['weak_topics'] = Variable<String>(weakTopics);
    return map;
  }

  UserProgressCompanion toCompanion(bool nullToAbsent) {
    return UserProgressCompanion(
      id: Value(id),
      userId: Value(userId),
      lessonRemoteId: Value(lessonRemoteId),
      score: Value(score),
      attempts: Value(attempts),
      completedAt: Value(completedAt),
      updatedAt: Value(updatedAt),
      isDirty: Value(isDirty),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      weakTopics: Value(weakTopics),
    );
  }

  factory UserProgressDB.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProgressDB(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      lessonRemoteId: serializer.fromJson<String>(json['lessonRemoteId']),
      score: serializer.fromJson<int>(json['score']),
      attempts: serializer.fromJson<int>(json['attempts']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isDirty: serializer.fromJson<bool>(json['isDirty']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      weakTopics: serializer.fromJson<String>(json['weakTopics']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'lessonRemoteId': serializer.toJson<String>(lessonRemoteId),
      'score': serializer.toJson<int>(score),
      'attempts': serializer.toJson<int>(attempts),
      'completedAt': serializer.toJson<DateTime>(completedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isDirty': serializer.toJson<bool>(isDirty),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'weakTopics': serializer.toJson<String>(weakTopics),
    };
  }

  UserProgressDB copyWith(
          {int? id,
          String? userId,
          String? lessonRemoteId,
          int? score,
          int? attempts,
          DateTime? completedAt,
          DateTime? updatedAt,
          bool? isDirty,
          Value<DateTime?> syncedAt = const Value.absent(),
          String? weakTopics}) =>
      UserProgressDB(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        lessonRemoteId: lessonRemoteId ?? this.lessonRemoteId,
        score: score ?? this.score,
        attempts: attempts ?? this.attempts,
        completedAt: completedAt ?? this.completedAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isDirty: isDirty ?? this.isDirty,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        weakTopics: weakTopics ?? this.weakTopics,
      );
  UserProgressDB copyWithCompanion(UserProgressCompanion data) {
    return UserProgressDB(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      lessonRemoteId: data.lessonRemoteId.present
          ? data.lessonRemoteId.value
          : this.lessonRemoteId,
      score: data.score.present ? data.score.value : this.score,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDirty: data.isDirty.present ? data.isDirty.value : this.isDirty,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      weakTopics:
          data.weakTopics.present ? data.weakTopics.value : this.weakTopics,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressDB(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('lessonRemoteId: $lessonRemoteId, ')
          ..write('score: $score, ')
          ..write('attempts: $attempts, ')
          ..write('completedAt: $completedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDirty: $isDirty, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('weakTopics: $weakTopics')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, lessonRemoteId, score, attempts,
      completedAt, updatedAt, isDirty, syncedAt, weakTopics);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProgressDB &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.lessonRemoteId == this.lessonRemoteId &&
          other.score == this.score &&
          other.attempts == this.attempts &&
          other.completedAt == this.completedAt &&
          other.updatedAt == this.updatedAt &&
          other.isDirty == this.isDirty &&
          other.syncedAt == this.syncedAt &&
          other.weakTopics == this.weakTopics);
}

class UserProgressCompanion extends UpdateCompanion<UserProgressDB> {
  final Value<int> id;
  final Value<String> userId;
  final Value<String> lessonRemoteId;
  final Value<int> score;
  final Value<int> attempts;
  final Value<DateTime> completedAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isDirty;
  final Value<DateTime?> syncedAt;
  final Value<String> weakTopics;
  const UserProgressCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.lessonRemoteId = const Value.absent(),
    this.score = const Value.absent(),
    this.attempts = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDirty = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.weakTopics = const Value.absent(),
  });
  UserProgressCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    required String lessonRemoteId,
    required int score,
    required int attempts,
    required DateTime completedAt,
    this.updatedAt = const Value.absent(),
    this.isDirty = const Value.absent(),
    this.syncedAt = const Value.absent(),
    required String weakTopics,
  })  : lessonRemoteId = Value(lessonRemoteId),
        score = Value(score),
        attempts = Value(attempts),
        completedAt = Value(completedAt),
        weakTopics = Value(weakTopics);
  static Insertable<UserProgressDB> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<String>? lessonRemoteId,
    Expression<int>? score,
    Expression<int>? attempts,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isDirty,
    Expression<DateTime>? syncedAt,
    Expression<String>? weakTopics,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (lessonRemoteId != null) 'lesson_remote_id': lessonRemoteId,
      if (score != null) 'score': score,
      if (attempts != null) 'attempts': attempts,
      if (completedAt != null) 'completed_at': completedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDirty != null) 'is_dirty': isDirty,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (weakTopics != null) 'weak_topics': weakTopics,
    });
  }

  UserProgressCompanion copyWith(
      {Value<int>? id,
      Value<String>? userId,
      Value<String>? lessonRemoteId,
      Value<int>? score,
      Value<int>? attempts,
      Value<DateTime>? completedAt,
      Value<DateTime>? updatedAt,
      Value<bool>? isDirty,
      Value<DateTime?>? syncedAt,
      Value<String>? weakTopics}) {
    return UserProgressCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      lessonRemoteId: lessonRemoteId ?? this.lessonRemoteId,
      score: score ?? this.score,
      attempts: attempts ?? this.attempts,
      completedAt: completedAt ?? this.completedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDirty: isDirty ?? this.isDirty,
      syncedAt: syncedAt ?? this.syncedAt,
      weakTopics: weakTopics ?? this.weakTopics,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (lessonRemoteId.present) {
      map['lesson_remote_id'] = Variable<String>(lessonRemoteId.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isDirty.present) {
      map['is_dirty'] = Variable<bool>(isDirty.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (weakTopics.present) {
      map['weak_topics'] = Variable<String>(weakTopics.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('lessonRemoteId: $lessonRemoteId, ')
          ..write('score: $score, ')
          ..write('attempts: $attempts, ')
          ..write('completedAt: $completedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDirty: $isDirty, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('weakTopics: $weakTopics')
          ..write(')'))
        .toString();
  }
}

class $QuizAttemptsTable extends QuizAttempts
    with TableInfo<$QuizAttemptsTable, QuizAttemptDB> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lessonRemoteIdMeta =
      const VerificationMeta('lessonRemoteId');
  @override
  late final GeneratedColumn<String> lessonRemoteId = GeneratedColumn<String>(
      'lesson_remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _totalQuestionsMeta =
      const VerificationMeta('totalQuestions');
  @override
  late final GeneratedColumn<int> totalQuestions = GeneratedColumn<int>(
      'total_questions', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _correctAnswersMeta =
      const VerificationMeta('correctAnswers');
  @override
  late final GeneratedColumn<int> correctAnswers = GeneratedColumn<int>(
      'correct_answers', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _scorePercentMeta =
      const VerificationMeta('scorePercent');
  @override
  late final GeneratedColumn<int> scorePercent = GeneratedColumn<int>(
      'score_percent', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _earnedXpMeta =
      const VerificationMeta('earnedXp');
  @override
  late final GeneratedColumn<int> earnedXp = GeneratedColumn<int>(
      'earned_xp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _weakTopicsMeta =
      const VerificationMeta('weakTopics');
  @override
  late final GeneratedColumn<String> weakTopics = GeneratedColumn<String>(
      'weak_topics', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _attemptedAtMeta =
      const VerificationMeta('attemptedAt');
  @override
  late final GeneratedColumn<DateTime> attemptedAt = GeneratedColumn<DateTime>(
      'attempted_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        lessonRemoteId,
        totalQuestions,
        correctAnswers,
        scorePercent,
        earnedXp,
        weakTopics,
        attemptedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_attempts';
  @override
  VerificationContext validateIntegrity(Insertable<QuizAttemptDB> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('lesson_remote_id')) {
      context.handle(
          _lessonRemoteIdMeta,
          lessonRemoteId.isAcceptableOrUnknown(
              data['lesson_remote_id']!, _lessonRemoteIdMeta));
    }
    if (data.containsKey('total_questions')) {
      context.handle(
          _totalQuestionsMeta,
          totalQuestions.isAcceptableOrUnknown(
              data['total_questions']!, _totalQuestionsMeta));
    } else if (isInserting) {
      context.missing(_totalQuestionsMeta);
    }
    if (data.containsKey('correct_answers')) {
      context.handle(
          _correctAnswersMeta,
          correctAnswers.isAcceptableOrUnknown(
              data['correct_answers']!, _correctAnswersMeta));
    } else if (isInserting) {
      context.missing(_correctAnswersMeta);
    }
    if (data.containsKey('score_percent')) {
      context.handle(
          _scorePercentMeta,
          scorePercent.isAcceptableOrUnknown(
              data['score_percent']!, _scorePercentMeta));
    } else if (isInserting) {
      context.missing(_scorePercentMeta);
    }
    if (data.containsKey('earned_xp')) {
      context.handle(_earnedXpMeta,
          earnedXp.isAcceptableOrUnknown(data['earned_xp']!, _earnedXpMeta));
    } else if (isInserting) {
      context.missing(_earnedXpMeta);
    }
    if (data.containsKey('weak_topics')) {
      context.handle(
          _weakTopicsMeta,
          weakTopics.isAcceptableOrUnknown(
              data['weak_topics']!, _weakTopicsMeta));
    }
    if (data.containsKey('attempted_at')) {
      context.handle(
          _attemptedAtMeta,
          attemptedAt.isAcceptableOrUnknown(
              data['attempted_at']!, _attemptedAtMeta));
    } else if (isInserting) {
      context.missing(_attemptedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuizAttemptDB map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizAttemptDB(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      lessonRemoteId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}lesson_remote_id']),
      totalQuestions: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_questions'])!,
      correctAnswers: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}correct_answers'])!,
      scorePercent: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}score_percent'])!,
      earnedXp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}earned_xp'])!,
      weakTopics: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}weak_topics'])!,
      attemptedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}attempted_at'])!,
    );
  }

  @override
  $QuizAttemptsTable createAlias(String alias) {
    return $QuizAttemptsTable(attachedDatabase, alias);
  }
}

class QuizAttemptDB extends DataClass implements Insertable<QuizAttemptDB> {
  final int id;

  /// ID користувача.
  final String userId;

  /// Remote ID уроку-тесту (nullable — для standalone quiz).
  final String? lessonRemoteId;

  /// Кількість питань.
  final int totalQuestions;

  /// Кількість правильних відповідей.
  final int correctAnswers;

  /// Відсоток правильних (0-100).
  final int scorePercent;

  /// Зароблені XP.
  final int earnedXp;

  /// JSON-масив слабких тем.
  final String weakTopics;

  /// Час проходження.
  final DateTime attemptedAt;
  const QuizAttemptDB(
      {required this.id,
      required this.userId,
      this.lessonRemoteId,
      required this.totalQuestions,
      required this.correctAnswers,
      required this.scorePercent,
      required this.earnedXp,
      required this.weakTopics,
      required this.attemptedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || lessonRemoteId != null) {
      map['lesson_remote_id'] = Variable<String>(lessonRemoteId);
    }
    map['total_questions'] = Variable<int>(totalQuestions);
    map['correct_answers'] = Variable<int>(correctAnswers);
    map['score_percent'] = Variable<int>(scorePercent);
    map['earned_xp'] = Variable<int>(earnedXp);
    map['weak_topics'] = Variable<String>(weakTopics);
    map['attempted_at'] = Variable<DateTime>(attemptedAt);
    return map;
  }

  QuizAttemptsCompanion toCompanion(bool nullToAbsent) {
    return QuizAttemptsCompanion(
      id: Value(id),
      userId: Value(userId),
      lessonRemoteId: lessonRemoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(lessonRemoteId),
      totalQuestions: Value(totalQuestions),
      correctAnswers: Value(correctAnswers),
      scorePercent: Value(scorePercent),
      earnedXp: Value(earnedXp),
      weakTopics: Value(weakTopics),
      attemptedAt: Value(attemptedAt),
    );
  }

  factory QuizAttemptDB.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizAttemptDB(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      lessonRemoteId: serializer.fromJson<String?>(json['lessonRemoteId']),
      totalQuestions: serializer.fromJson<int>(json['totalQuestions']),
      correctAnswers: serializer.fromJson<int>(json['correctAnswers']),
      scorePercent: serializer.fromJson<int>(json['scorePercent']),
      earnedXp: serializer.fromJson<int>(json['earnedXp']),
      weakTopics: serializer.fromJson<String>(json['weakTopics']),
      attemptedAt: serializer.fromJson<DateTime>(json['attemptedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'lessonRemoteId': serializer.toJson<String?>(lessonRemoteId),
      'totalQuestions': serializer.toJson<int>(totalQuestions),
      'correctAnswers': serializer.toJson<int>(correctAnswers),
      'scorePercent': serializer.toJson<int>(scorePercent),
      'earnedXp': serializer.toJson<int>(earnedXp),
      'weakTopics': serializer.toJson<String>(weakTopics),
      'attemptedAt': serializer.toJson<DateTime>(attemptedAt),
    };
  }

  QuizAttemptDB copyWith(
          {int? id,
          String? userId,
          Value<String?> lessonRemoteId = const Value.absent(),
          int? totalQuestions,
          int? correctAnswers,
          int? scorePercent,
          int? earnedXp,
          String? weakTopics,
          DateTime? attemptedAt}) =>
      QuizAttemptDB(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        lessonRemoteId:
            lessonRemoteId.present ? lessonRemoteId.value : this.lessonRemoteId,
        totalQuestions: totalQuestions ?? this.totalQuestions,
        correctAnswers: correctAnswers ?? this.correctAnswers,
        scorePercent: scorePercent ?? this.scorePercent,
        earnedXp: earnedXp ?? this.earnedXp,
        weakTopics: weakTopics ?? this.weakTopics,
        attemptedAt: attemptedAt ?? this.attemptedAt,
      );
  QuizAttemptDB copyWithCompanion(QuizAttemptsCompanion data) {
    return QuizAttemptDB(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      lessonRemoteId: data.lessonRemoteId.present
          ? data.lessonRemoteId.value
          : this.lessonRemoteId,
      totalQuestions: data.totalQuestions.present
          ? data.totalQuestions.value
          : this.totalQuestions,
      correctAnswers: data.correctAnswers.present
          ? data.correctAnswers.value
          : this.correctAnswers,
      scorePercent: data.scorePercent.present
          ? data.scorePercent.value
          : this.scorePercent,
      earnedXp: data.earnedXp.present ? data.earnedXp.value : this.earnedXp,
      weakTopics:
          data.weakTopics.present ? data.weakTopics.value : this.weakTopics,
      attemptedAt:
          data.attemptedAt.present ? data.attemptedAt.value : this.attemptedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizAttemptDB(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('lessonRemoteId: $lessonRemoteId, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('correctAnswers: $correctAnswers, ')
          ..write('scorePercent: $scorePercent, ')
          ..write('earnedXp: $earnedXp, ')
          ..write('weakTopics: $weakTopics, ')
          ..write('attemptedAt: $attemptedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, lessonRemoteId, totalQuestions,
      correctAnswers, scorePercent, earnedXp, weakTopics, attemptedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizAttemptDB &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.lessonRemoteId == this.lessonRemoteId &&
          other.totalQuestions == this.totalQuestions &&
          other.correctAnswers == this.correctAnswers &&
          other.scorePercent == this.scorePercent &&
          other.earnedXp == this.earnedXp &&
          other.weakTopics == this.weakTopics &&
          other.attemptedAt == this.attemptedAt);
}

class QuizAttemptsCompanion extends UpdateCompanion<QuizAttemptDB> {
  final Value<int> id;
  final Value<String> userId;
  final Value<String?> lessonRemoteId;
  final Value<int> totalQuestions;
  final Value<int> correctAnswers;
  final Value<int> scorePercent;
  final Value<int> earnedXp;
  final Value<String> weakTopics;
  final Value<DateTime> attemptedAt;
  const QuizAttemptsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.lessonRemoteId = const Value.absent(),
    this.totalQuestions = const Value.absent(),
    this.correctAnswers = const Value.absent(),
    this.scorePercent = const Value.absent(),
    this.earnedXp = const Value.absent(),
    this.weakTopics = const Value.absent(),
    this.attemptedAt = const Value.absent(),
  });
  QuizAttemptsCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    this.lessonRemoteId = const Value.absent(),
    required int totalQuestions,
    required int correctAnswers,
    required int scorePercent,
    required int earnedXp,
    this.weakTopics = const Value.absent(),
    required DateTime attemptedAt,
  })  : userId = Value(userId),
        totalQuestions = Value(totalQuestions),
        correctAnswers = Value(correctAnswers),
        scorePercent = Value(scorePercent),
        earnedXp = Value(earnedXp),
        attemptedAt = Value(attemptedAt);
  static Insertable<QuizAttemptDB> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<String>? lessonRemoteId,
    Expression<int>? totalQuestions,
    Expression<int>? correctAnswers,
    Expression<int>? scorePercent,
    Expression<int>? earnedXp,
    Expression<String>? weakTopics,
    Expression<DateTime>? attemptedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (lessonRemoteId != null) 'lesson_remote_id': lessonRemoteId,
      if (totalQuestions != null) 'total_questions': totalQuestions,
      if (correctAnswers != null) 'correct_answers': correctAnswers,
      if (scorePercent != null) 'score_percent': scorePercent,
      if (earnedXp != null) 'earned_xp': earnedXp,
      if (weakTopics != null) 'weak_topics': weakTopics,
      if (attemptedAt != null) 'attempted_at': attemptedAt,
    });
  }

  QuizAttemptsCompanion copyWith(
      {Value<int>? id,
      Value<String>? userId,
      Value<String?>? lessonRemoteId,
      Value<int>? totalQuestions,
      Value<int>? correctAnswers,
      Value<int>? scorePercent,
      Value<int>? earnedXp,
      Value<String>? weakTopics,
      Value<DateTime>? attemptedAt}) {
    return QuizAttemptsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      lessonRemoteId: lessonRemoteId ?? this.lessonRemoteId,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      scorePercent: scorePercent ?? this.scorePercent,
      earnedXp: earnedXp ?? this.earnedXp,
      weakTopics: weakTopics ?? this.weakTopics,
      attemptedAt: attemptedAt ?? this.attemptedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (lessonRemoteId.present) {
      map['lesson_remote_id'] = Variable<String>(lessonRemoteId.value);
    }
    if (totalQuestions.present) {
      map['total_questions'] = Variable<int>(totalQuestions.value);
    }
    if (correctAnswers.present) {
      map['correct_answers'] = Variable<int>(correctAnswers.value);
    }
    if (scorePercent.present) {
      map['score_percent'] = Variable<int>(scorePercent.value);
    }
    if (earnedXp.present) {
      map['earned_xp'] = Variable<int>(earnedXp.value);
    }
    if (weakTopics.present) {
      map['weak_topics'] = Variable<String>(weakTopics.value);
    }
    if (attemptedAt.present) {
      map['attempted_at'] = Variable<DateTime>(attemptedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizAttemptsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('lessonRemoteId: $lessonRemoteId, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('correctAnswers: $correctAnswers, ')
          ..write('scorePercent: $scorePercent, ')
          ..write('earnedXp: $earnedXp, ')
          ..write('weakTopics: $weakTopics, ')
          ..write('attemptedAt: $attemptedAt')
          ..write(')'))
        .toString();
  }
}

class $ChatMessagesLocalTable extends ChatMessagesLocal
    with TableInfo<$ChatMessagesLocalTable, ChatMessageDB> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatMessagesLocalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, userId, role, content, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_messages_local';
  @override
  VerificationContext validateIntegrity(Insertable<ChatMessageDB> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatMessageDB map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMessageDB(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ChatMessagesLocalTable createAlias(String alias) {
    return $ChatMessagesLocalTable(attachedDatabase, alias);
  }
}

class ChatMessageDB extends DataClass implements Insertable<ChatMessageDB> {
  /// UUID з Supabase (або тимчасовий локальний для pending).
  final String id;
  final String userId;
  final String role;
  final String content;
  final DateTime createdAt;
  const ChatMessageDB(
      {required this.id,
      required this.userId,
      required this.role,
      required this.content,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ChatMessagesLocalCompanion toCompanion(bool nullToAbsent) {
    return ChatMessagesLocalCompanion(
      id: Value(id),
      userId: Value(userId),
      role: Value(role),
      content: Value(content),
      createdAt: Value(createdAt),
    );
  }

  factory ChatMessageDB.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMessageDB(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ChatMessageDB copyWith(
          {String? id,
          String? userId,
          String? role,
          String? content,
          DateTime? createdAt}) =>
      ChatMessageDB(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        role: role ?? this.role,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
      );
  ChatMessageDB copyWithCompanion(ChatMessagesLocalCompanion data) {
    return ChatMessageDB(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessageDB(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, role, content, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessageDB &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.role == this.role &&
          other.content == this.content &&
          other.createdAt == this.createdAt);
}

class ChatMessagesLocalCompanion extends UpdateCompanion<ChatMessageDB> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> role;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ChatMessagesLocalCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatMessagesLocalCompanion.insert({
    required String id,
    required String userId,
    required String role,
    required String content,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        role = Value(role),
        content = Value(content),
        createdAt = Value(createdAt);
  static Insertable<ChatMessageDB> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? role,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatMessagesLocalCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? role,
      Value<String>? content,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ChatMessagesLocalCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessagesLocalCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MarchHistoryTable extends MarchHistory
    with TableInfo<$MarchHistoryTable, MarchHistoryDB> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MarchHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _totalDurationSecondsMeta =
      const VerificationMeta('totalDurationSeconds');
  @override
  late final GeneratedColumn<int> totalDurationSeconds = GeneratedColumn<int>(
      'total_duration_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _successRateMeta =
      const VerificationMeta('successRate');
  @override
  late final GeneratedColumn<int> successRate = GeneratedColumn<int>(
      'success_rate', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _weakTopicsMeta =
      const VerificationMeta('weakTopics');
  @override
  late final GeneratedColumn<String> weakTopics = GeneratedColumn<String>(
      'weak_topics', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _itemsJsonMeta =
      const VerificationMeta('itemsJson');
  @override
  late final GeneratedColumn<String> itemsJson = GeneratedColumn<String>(
      'items_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _isDirtyMeta =
      const VerificationMeta('isDirty');
  @override
  late final GeneratedColumn<bool> isDirty = GeneratedColumn<bool>(
      'is_dirty', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_dirty" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        startedAt,
        totalDurationSeconds,
        successRate,
        weakTopics,
        itemsJson,
        isDirty,
        syncedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'march_history';
  @override
  VerificationContext validateIntegrity(Insertable<MarchHistoryDB> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('total_duration_seconds')) {
      context.handle(
          _totalDurationSecondsMeta,
          totalDurationSeconds.isAcceptableOrUnknown(
              data['total_duration_seconds']!, _totalDurationSecondsMeta));
    } else if (isInserting) {
      context.missing(_totalDurationSecondsMeta);
    }
    if (data.containsKey('success_rate')) {
      context.handle(
          _successRateMeta,
          successRate.isAcceptableOrUnknown(
              data['success_rate']!, _successRateMeta));
    } else if (isInserting) {
      context.missing(_successRateMeta);
    }
    if (data.containsKey('weak_topics')) {
      context.handle(
          _weakTopicsMeta,
          weakTopics.isAcceptableOrUnknown(
              data['weak_topics']!, _weakTopicsMeta));
    }
    if (data.containsKey('items_json')) {
      context.handle(_itemsJsonMeta,
          itemsJson.isAcceptableOrUnknown(data['items_json']!, _itemsJsonMeta));
    }
    if (data.containsKey('is_dirty')) {
      context.handle(_isDirtyMeta,
          isDirty.isAcceptableOrUnknown(data['is_dirty']!, _isDirtyMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MarchHistoryDB map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MarchHistoryDB(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      totalDurationSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_duration_seconds'])!,
      successRate: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}success_rate'])!,
      weakTopics: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}weak_topics'])!,
      itemsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}items_json'])!,
      isDirty: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_dirty'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $MarchHistoryTable createAlias(String alias) {
    return $MarchHistoryTable(attachedDatabase, alias);
  }
}

class MarchHistoryDB extends DataClass implements Insertable<MarchHistoryDB> {
  final int id;

  /// ID користувача (порожній для гостя).
  final String userId;

  /// Час старту сесії.
  final DateTime startedAt;

  /// Загальна тривалість у секундах.
  final int totalDurationSeconds;

  /// % правильних відповідей у мікро-квізах (0–100).
  final int successRate;

  /// JSON-масив кодів кроків зі слабкими результатами (наприклад ["M","R"]).
  final String weakTopics;

  /// JSON з покроковою аналітикою (elapsedSeconds, quizAnsweredCorrectly).
  final String itemsJson;

  /// Чи синхронізовано з сервером.
  final bool isDirty;
  final DateTime? syncedAt;
  const MarchHistoryDB(
      {required this.id,
      required this.userId,
      required this.startedAt,
      required this.totalDurationSeconds,
      required this.successRate,
      required this.weakTopics,
      required this.itemsJson,
      required this.isDirty,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['total_duration_seconds'] = Variable<int>(totalDurationSeconds);
    map['success_rate'] = Variable<int>(successRate);
    map['weak_topics'] = Variable<String>(weakTopics);
    map['items_json'] = Variable<String>(itemsJson);
    map['is_dirty'] = Variable<bool>(isDirty);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  MarchHistoryCompanion toCompanion(bool nullToAbsent) {
    return MarchHistoryCompanion(
      id: Value(id),
      userId: Value(userId),
      startedAt: Value(startedAt),
      totalDurationSeconds: Value(totalDurationSeconds),
      successRate: Value(successRate),
      weakTopics: Value(weakTopics),
      itemsJson: Value(itemsJson),
      isDirty: Value(isDirty),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory MarchHistoryDB.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MarchHistoryDB(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      totalDurationSeconds:
          serializer.fromJson<int>(json['totalDurationSeconds']),
      successRate: serializer.fromJson<int>(json['successRate']),
      weakTopics: serializer.fromJson<String>(json['weakTopics']),
      itemsJson: serializer.fromJson<String>(json['itemsJson']),
      isDirty: serializer.fromJson<bool>(json['isDirty']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'totalDurationSeconds': serializer.toJson<int>(totalDurationSeconds),
      'successRate': serializer.toJson<int>(successRate),
      'weakTopics': serializer.toJson<String>(weakTopics),
      'itemsJson': serializer.toJson<String>(itemsJson),
      'isDirty': serializer.toJson<bool>(isDirty),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  MarchHistoryDB copyWith(
          {int? id,
          String? userId,
          DateTime? startedAt,
          int? totalDurationSeconds,
          int? successRate,
          String? weakTopics,
          String? itemsJson,
          bool? isDirty,
          Value<DateTime?> syncedAt = const Value.absent()}) =>
      MarchHistoryDB(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        startedAt: startedAt ?? this.startedAt,
        totalDurationSeconds: totalDurationSeconds ?? this.totalDurationSeconds,
        successRate: successRate ?? this.successRate,
        weakTopics: weakTopics ?? this.weakTopics,
        itemsJson: itemsJson ?? this.itemsJson,
        isDirty: isDirty ?? this.isDirty,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  MarchHistoryDB copyWithCompanion(MarchHistoryCompanion data) {
    return MarchHistoryDB(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      totalDurationSeconds: data.totalDurationSeconds.present
          ? data.totalDurationSeconds.value
          : this.totalDurationSeconds,
      successRate:
          data.successRate.present ? data.successRate.value : this.successRate,
      weakTopics:
          data.weakTopics.present ? data.weakTopics.value : this.weakTopics,
      itemsJson: data.itemsJson.present ? data.itemsJson.value : this.itemsJson,
      isDirty: data.isDirty.present ? data.isDirty.value : this.isDirty,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MarchHistoryDB(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('startedAt: $startedAt, ')
          ..write('totalDurationSeconds: $totalDurationSeconds, ')
          ..write('successRate: $successRate, ')
          ..write('weakTopics: $weakTopics, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('isDirty: $isDirty, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, startedAt, totalDurationSeconds,
      successRate, weakTopics, itemsJson, isDirty, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MarchHistoryDB &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.startedAt == this.startedAt &&
          other.totalDurationSeconds == this.totalDurationSeconds &&
          other.successRate == this.successRate &&
          other.weakTopics == this.weakTopics &&
          other.itemsJson == this.itemsJson &&
          other.isDirty == this.isDirty &&
          other.syncedAt == this.syncedAt);
}

class MarchHistoryCompanion extends UpdateCompanion<MarchHistoryDB> {
  final Value<int> id;
  final Value<String> userId;
  final Value<DateTime> startedAt;
  final Value<int> totalDurationSeconds;
  final Value<int> successRate;
  final Value<String> weakTopics;
  final Value<String> itemsJson;
  final Value<bool> isDirty;
  final Value<DateTime?> syncedAt;
  const MarchHistoryCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.totalDurationSeconds = const Value.absent(),
    this.successRate = const Value.absent(),
    this.weakTopics = const Value.absent(),
    this.itemsJson = const Value.absent(),
    this.isDirty = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  MarchHistoryCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    required DateTime startedAt,
    required int totalDurationSeconds,
    required int successRate,
    this.weakTopics = const Value.absent(),
    this.itemsJson = const Value.absent(),
    this.isDirty = const Value.absent(),
    this.syncedAt = const Value.absent(),
  })  : startedAt = Value(startedAt),
        totalDurationSeconds = Value(totalDurationSeconds),
        successRate = Value(successRate);
  static Insertable<MarchHistoryDB> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<DateTime>? startedAt,
    Expression<int>? totalDurationSeconds,
    Expression<int>? successRate,
    Expression<String>? weakTopics,
    Expression<String>? itemsJson,
    Expression<bool>? isDirty,
    Expression<DateTime>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (startedAt != null) 'started_at': startedAt,
      if (totalDurationSeconds != null)
        'total_duration_seconds': totalDurationSeconds,
      if (successRate != null) 'success_rate': successRate,
      if (weakTopics != null) 'weak_topics': weakTopics,
      if (itemsJson != null) 'items_json': itemsJson,
      if (isDirty != null) 'is_dirty': isDirty,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  MarchHistoryCompanion copyWith(
      {Value<int>? id,
      Value<String>? userId,
      Value<DateTime>? startedAt,
      Value<int>? totalDurationSeconds,
      Value<int>? successRate,
      Value<String>? weakTopics,
      Value<String>? itemsJson,
      Value<bool>? isDirty,
      Value<DateTime?>? syncedAt}) {
    return MarchHistoryCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startedAt: startedAt ?? this.startedAt,
      totalDurationSeconds: totalDurationSeconds ?? this.totalDurationSeconds,
      successRate: successRate ?? this.successRate,
      weakTopics: weakTopics ?? this.weakTopics,
      itemsJson: itemsJson ?? this.itemsJson,
      isDirty: isDirty ?? this.isDirty,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (totalDurationSeconds.present) {
      map['total_duration_seconds'] = Variable<int>(totalDurationSeconds.value);
    }
    if (successRate.present) {
      map['success_rate'] = Variable<int>(successRate.value);
    }
    if (weakTopics.present) {
      map['weak_topics'] = Variable<String>(weakTopics.value);
    }
    if (itemsJson.present) {
      map['items_json'] = Variable<String>(itemsJson.value);
    }
    if (isDirty.present) {
      map['is_dirty'] = Variable<bool>(isDirty.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MarchHistoryCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('startedAt: $startedAt, ')
          ..write('totalDurationSeconds: $totalDurationSeconds, ')
          ..write('successRate: $successRate, ')
          ..write('weakTopics: $weakTopics, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('isDirty: $isDirty, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CoursesTable courses = $CoursesTable(this);
  late final $LessonsTable lessons = $LessonsTable(this);
  late final $UserProgressTable userProgress = $UserProgressTable(this);
  late final $QuizAttemptsTable quizAttempts = $QuizAttemptsTable(this);
  late final $ChatMessagesLocalTable chatMessagesLocal =
      $ChatMessagesLocalTable(this);
  late final $MarchHistoryTable marchHistory = $MarchHistoryTable(this);
  late final CourseDao courseDao = CourseDao(this as AppDatabase);
  late final LessonDao lessonDao = LessonDao(this as AppDatabase);
  late final ProgressDao progressDao = ProgressDao(this as AppDatabase);
  late final QuizAttemptDao quizAttemptDao =
      QuizAttemptDao(this as AppDatabase);
  late final ChatDao chatDao = ChatDao(this as AppDatabase);
  late final MarchHistoryDao marchHistoryDao =
      MarchHistoryDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        courses,
        lessons,
        userProgress,
        quizAttempts,
        chatMessagesLocal,
        marchHistory
      ];
}

typedef $$CoursesTableCreateCompanionBuilder = CoursesCompanion Function({
  Value<int> id,
  required String remoteId,
  required String title,
  required String description,
  required String track,
  required int orderIndex,
  Value<bool> isDownloaded,
  Value<int> totalLessons,
  Value<int> completedLessons,
  required DateTime updatedAt,
});
typedef $$CoursesTableUpdateCompanionBuilder = CoursesCompanion Function({
  Value<int> id,
  Value<String> remoteId,
  Value<String> title,
  Value<String> description,
  Value<String> track,
  Value<int> orderIndex,
  Value<bool> isDownloaded,
  Value<int> totalLessons,
  Value<int> completedLessons,
  Value<DateTime> updatedAt,
});

final class $$CoursesTableReferences
    extends BaseReferences<_$AppDatabase, $CoursesTable, CourseDB> {
  $$CoursesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LessonsTable, List<LessonDB>> _lessonsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.lessons,
          aliasName: $_aliasNameGenerator(db.courses.id, db.lessons.courseId));

  $$LessonsTableProcessedTableManager get lessonsRefs {
    final manager = $$LessonsTableTableManager($_db, $_db.lessons)
        .filter((f) => f.courseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_lessonsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CoursesTableFilterComposer
    extends Composer<_$AppDatabase, $CoursesTable> {
  $$CoursesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get track => $composableBuilder(
      column: $table.track, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDownloaded => $composableBuilder(
      column: $table.isDownloaded, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalLessons => $composableBuilder(
      column: $table.totalLessons, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get completedLessons => $composableBuilder(
      column: $table.completedLessons,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> lessonsRefs(
      Expression<bool> Function($$LessonsTableFilterComposer f) f) {
    final $$LessonsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.courseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableFilterComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CoursesTableOrderingComposer
    extends Composer<_$AppDatabase, $CoursesTable> {
  $$CoursesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get track => $composableBuilder(
      column: $table.track, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDownloaded => $composableBuilder(
      column: $table.isDownloaded,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalLessons => $composableBuilder(
      column: $table.totalLessons,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get completedLessons => $composableBuilder(
      column: $table.completedLessons,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CoursesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CoursesTable> {
  $$CoursesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get track =>
      $composableBuilder(column: $table.track, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => column);

  GeneratedColumn<bool> get isDownloaded => $composableBuilder(
      column: $table.isDownloaded, builder: (column) => column);

  GeneratedColumn<int> get totalLessons => $composableBuilder(
      column: $table.totalLessons, builder: (column) => column);

  GeneratedColumn<int> get completedLessons => $composableBuilder(
      column: $table.completedLessons, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> lessonsRefs<T extends Object>(
      Expression<T> Function($$LessonsTableAnnotationComposer a) f) {
    final $$LessonsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.lessons,
        getReferencedColumn: (t) => t.courseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LessonsTableAnnotationComposer(
              $db: $db,
              $table: $db.lessons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CoursesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CoursesTable,
    CourseDB,
    $$CoursesTableFilterComposer,
    $$CoursesTableOrderingComposer,
    $$CoursesTableAnnotationComposer,
    $$CoursesTableCreateCompanionBuilder,
    $$CoursesTableUpdateCompanionBuilder,
    (CourseDB, $$CoursesTableReferences),
    CourseDB,
    PrefetchHooks Function({bool lessonsRefs})> {
  $$CoursesTableTableManager(_$AppDatabase db, $CoursesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CoursesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CoursesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CoursesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> remoteId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> track = const Value.absent(),
            Value<int> orderIndex = const Value.absent(),
            Value<bool> isDownloaded = const Value.absent(),
            Value<int> totalLessons = const Value.absent(),
            Value<int> completedLessons = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              CoursesCompanion(
            id: id,
            remoteId: remoteId,
            title: title,
            description: description,
            track: track,
            orderIndex: orderIndex,
            isDownloaded: isDownloaded,
            totalLessons: totalLessons,
            completedLessons: completedLessons,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String remoteId,
            required String title,
            required String description,
            required String track,
            required int orderIndex,
            Value<bool> isDownloaded = const Value.absent(),
            Value<int> totalLessons = const Value.absent(),
            Value<int> completedLessons = const Value.absent(),
            required DateTime updatedAt,
          }) =>
              CoursesCompanion.insert(
            id: id,
            remoteId: remoteId,
            title: title,
            description: description,
            track: track,
            orderIndex: orderIndex,
            isDownloaded: isDownloaded,
            totalLessons: totalLessons,
            completedLessons: completedLessons,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$CoursesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({lessonsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (lessonsRefs) db.lessons],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (lessonsRefs)
                    await $_getPrefetchedData<CourseDB, $CoursesTable,
                            LessonDB>(
                        currentTable: table,
                        referencedTable:
                            $$CoursesTableReferences._lessonsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CoursesTableReferences(db, table, p0).lessonsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.courseId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CoursesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CoursesTable,
    CourseDB,
    $$CoursesTableFilterComposer,
    $$CoursesTableOrderingComposer,
    $$CoursesTableAnnotationComposer,
    $$CoursesTableCreateCompanionBuilder,
    $$CoursesTableUpdateCompanionBuilder,
    (CourseDB, $$CoursesTableReferences),
    CourseDB,
    PrefetchHooks Function({bool lessonsRefs})>;
typedef $$LessonsTableCreateCompanionBuilder = LessonsCompanion Function({
  Value<int> id,
  required String remoteId,
  required int courseId,
  required String type,
  required String title,
  required String contentJson,
  required int durationSeconds,
  required int orderIndex,
  Value<bool> isCompleted,
  Value<int> xpReward,
  Value<DateTime> updatedAt,
});
typedef $$LessonsTableUpdateCompanionBuilder = LessonsCompanion Function({
  Value<int> id,
  Value<String> remoteId,
  Value<int> courseId,
  Value<String> type,
  Value<String> title,
  Value<String> contentJson,
  Value<int> durationSeconds,
  Value<int> orderIndex,
  Value<bool> isCompleted,
  Value<int> xpReward,
  Value<DateTime> updatedAt,
});

final class $$LessonsTableReferences
    extends BaseReferences<_$AppDatabase, $LessonsTable, LessonDB> {
  $$LessonsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CoursesTable _courseIdTable(_$AppDatabase db) => db.courses
      .createAlias($_aliasNameGenerator(db.lessons.courseId, db.courses.id));

  $$CoursesTableProcessedTableManager get courseId {
    final $_column = $_itemColumn<int>('course_id')!;

    final manager = $$CoursesTableTableManager($_db, $_db.courses)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_courseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$LessonsTableFilterComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contentJson => $composableBuilder(
      column: $table.contentJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get xpReward => $composableBuilder(
      column: $table.xpReward, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$CoursesTableFilterComposer get courseId {
    final $$CoursesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.courseId,
        referencedTable: $db.courses,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CoursesTableFilterComposer(
              $db: $db,
              $table: $db.courses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LessonsTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contentJson => $composableBuilder(
      column: $table.contentJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get xpReward => $composableBuilder(
      column: $table.xpReward, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$CoursesTableOrderingComposer get courseId {
    final $$CoursesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.courseId,
        referencedTable: $db.courses,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CoursesTableOrderingComposer(
              $db: $db,
              $table: $db.courses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LessonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get contentJson => $composableBuilder(
      column: $table.contentJson, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<int> get xpReward =>
      $composableBuilder(column: $table.xpReward, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CoursesTableAnnotationComposer get courseId {
    final $$CoursesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.courseId,
        referencedTable: $db.courses,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CoursesTableAnnotationComposer(
              $db: $db,
              $table: $db.courses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LessonsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LessonsTable,
    LessonDB,
    $$LessonsTableFilterComposer,
    $$LessonsTableOrderingComposer,
    $$LessonsTableAnnotationComposer,
    $$LessonsTableCreateCompanionBuilder,
    $$LessonsTableUpdateCompanionBuilder,
    (LessonDB, $$LessonsTableReferences),
    LessonDB,
    PrefetchHooks Function({bool courseId})> {
  $$LessonsTableTableManager(_$AppDatabase db, $LessonsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> remoteId = const Value.absent(),
            Value<int> courseId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> contentJson = const Value.absent(),
            Value<int> durationSeconds = const Value.absent(),
            Value<int> orderIndex = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<int> xpReward = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              LessonsCompanion(
            id: id,
            remoteId: remoteId,
            courseId: courseId,
            type: type,
            title: title,
            contentJson: contentJson,
            durationSeconds: durationSeconds,
            orderIndex: orderIndex,
            isCompleted: isCompleted,
            xpReward: xpReward,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String remoteId,
            required int courseId,
            required String type,
            required String title,
            required String contentJson,
            required int durationSeconds,
            required int orderIndex,
            Value<bool> isCompleted = const Value.absent(),
            Value<int> xpReward = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              LessonsCompanion.insert(
            id: id,
            remoteId: remoteId,
            courseId: courseId,
            type: type,
            title: title,
            contentJson: contentJson,
            durationSeconds: durationSeconds,
            orderIndex: orderIndex,
            isCompleted: isCompleted,
            xpReward: xpReward,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$LessonsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({courseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (courseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.courseId,
                    referencedTable:
                        $$LessonsTableReferences._courseIdTable(db),
                    referencedColumn:
                        $$LessonsTableReferences._courseIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$LessonsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LessonsTable,
    LessonDB,
    $$LessonsTableFilterComposer,
    $$LessonsTableOrderingComposer,
    $$LessonsTableAnnotationComposer,
    $$LessonsTableCreateCompanionBuilder,
    $$LessonsTableUpdateCompanionBuilder,
    (LessonDB, $$LessonsTableReferences),
    LessonDB,
    PrefetchHooks Function({bool courseId})>;
typedef $$UserProgressTableCreateCompanionBuilder = UserProgressCompanion
    Function({
  Value<int> id,
  Value<String> userId,
  required String lessonRemoteId,
  required int score,
  required int attempts,
  required DateTime completedAt,
  Value<DateTime> updatedAt,
  Value<bool> isDirty,
  Value<DateTime?> syncedAt,
  required String weakTopics,
});
typedef $$UserProgressTableUpdateCompanionBuilder = UserProgressCompanion
    Function({
  Value<int> id,
  Value<String> userId,
  Value<String> lessonRemoteId,
  Value<int> score,
  Value<int> attempts,
  Value<DateTime> completedAt,
  Value<DateTime> updatedAt,
  Value<bool> isDirty,
  Value<DateTime?> syncedAt,
  Value<String> weakTopics,
});

class $$UserProgressTableFilterComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lessonRemoteId => $composableBuilder(
      column: $table.lessonRemoteId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDirty => $composableBuilder(
      column: $table.isDirty, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weakTopics => $composableBuilder(
      column: $table.weakTopics, builder: (column) => ColumnFilters(column));
}

class $$UserProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lessonRemoteId => $composableBuilder(
      column: $table.lessonRemoteId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDirty => $composableBuilder(
      column: $table.isDirty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weakTopics => $composableBuilder(
      column: $table.weakTopics, builder: (column) => ColumnOrderings(column));
}

class $$UserProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get lessonRemoteId => $composableBuilder(
      column: $table.lessonRemoteId, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDirty =>
      $composableBuilder(column: $table.isDirty, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<String> get weakTopics => $composableBuilder(
      column: $table.weakTopics, builder: (column) => column);
}

class $$UserProgressTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserProgressTable,
    UserProgressDB,
    $$UserProgressTableFilterComposer,
    $$UserProgressTableOrderingComposer,
    $$UserProgressTableAnnotationComposer,
    $$UserProgressTableCreateCompanionBuilder,
    $$UserProgressTableUpdateCompanionBuilder,
    (
      UserProgressDB,
      BaseReferences<_$AppDatabase, $UserProgressTable, UserProgressDB>
    ),
    UserProgressDB,
    PrefetchHooks Function()> {
  $$UserProgressTableTableManager(_$AppDatabase db, $UserProgressTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> lessonRemoteId = const Value.absent(),
            Value<int> score = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<DateTime> completedAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> isDirty = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<String> weakTopics = const Value.absent(),
          }) =>
              UserProgressCompanion(
            id: id,
            userId: userId,
            lessonRemoteId: lessonRemoteId,
            score: score,
            attempts: attempts,
            completedAt: completedAt,
            updatedAt: updatedAt,
            isDirty: isDirty,
            syncedAt: syncedAt,
            weakTopics: weakTopics,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            required String lessonRemoteId,
            required int score,
            required int attempts,
            required DateTime completedAt,
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> isDirty = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            required String weakTopics,
          }) =>
              UserProgressCompanion.insert(
            id: id,
            userId: userId,
            lessonRemoteId: lessonRemoteId,
            score: score,
            attempts: attempts,
            completedAt: completedAt,
            updatedAt: updatedAt,
            isDirty: isDirty,
            syncedAt: syncedAt,
            weakTopics: weakTopics,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserProgressTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserProgressTable,
    UserProgressDB,
    $$UserProgressTableFilterComposer,
    $$UserProgressTableOrderingComposer,
    $$UserProgressTableAnnotationComposer,
    $$UserProgressTableCreateCompanionBuilder,
    $$UserProgressTableUpdateCompanionBuilder,
    (
      UserProgressDB,
      BaseReferences<_$AppDatabase, $UserProgressTable, UserProgressDB>
    ),
    UserProgressDB,
    PrefetchHooks Function()>;
typedef $$QuizAttemptsTableCreateCompanionBuilder = QuizAttemptsCompanion
    Function({
  Value<int> id,
  required String userId,
  Value<String?> lessonRemoteId,
  required int totalQuestions,
  required int correctAnswers,
  required int scorePercent,
  required int earnedXp,
  Value<String> weakTopics,
  required DateTime attemptedAt,
});
typedef $$QuizAttemptsTableUpdateCompanionBuilder = QuizAttemptsCompanion
    Function({
  Value<int> id,
  Value<String> userId,
  Value<String?> lessonRemoteId,
  Value<int> totalQuestions,
  Value<int> correctAnswers,
  Value<int> scorePercent,
  Value<int> earnedXp,
  Value<String> weakTopics,
  Value<DateTime> attemptedAt,
});

class $$QuizAttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $QuizAttemptsTable> {
  $$QuizAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lessonRemoteId => $composableBuilder(
      column: $table.lessonRemoteId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalQuestions => $composableBuilder(
      column: $table.totalQuestions,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get correctAnswers => $composableBuilder(
      column: $table.correctAnswers,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get scorePercent => $composableBuilder(
      column: $table.scorePercent, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get earnedXp => $composableBuilder(
      column: $table.earnedXp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weakTopics => $composableBuilder(
      column: $table.weakTopics, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get attemptedAt => $composableBuilder(
      column: $table.attemptedAt, builder: (column) => ColumnFilters(column));
}

class $$QuizAttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizAttemptsTable> {
  $$QuizAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lessonRemoteId => $composableBuilder(
      column: $table.lessonRemoteId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalQuestions => $composableBuilder(
      column: $table.totalQuestions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get correctAnswers => $composableBuilder(
      column: $table.correctAnswers,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get scorePercent => $composableBuilder(
      column: $table.scorePercent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get earnedXp => $composableBuilder(
      column: $table.earnedXp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weakTopics => $composableBuilder(
      column: $table.weakTopics, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get attemptedAt => $composableBuilder(
      column: $table.attemptedAt, builder: (column) => ColumnOrderings(column));
}

class $$QuizAttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizAttemptsTable> {
  $$QuizAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get lessonRemoteId => $composableBuilder(
      column: $table.lessonRemoteId, builder: (column) => column);

  GeneratedColumn<int> get totalQuestions => $composableBuilder(
      column: $table.totalQuestions, builder: (column) => column);

  GeneratedColumn<int> get correctAnswers => $composableBuilder(
      column: $table.correctAnswers, builder: (column) => column);

  GeneratedColumn<int> get scorePercent => $composableBuilder(
      column: $table.scorePercent, builder: (column) => column);

  GeneratedColumn<int> get earnedXp =>
      $composableBuilder(column: $table.earnedXp, builder: (column) => column);

  GeneratedColumn<String> get weakTopics => $composableBuilder(
      column: $table.weakTopics, builder: (column) => column);

  GeneratedColumn<DateTime> get attemptedAt => $composableBuilder(
      column: $table.attemptedAt, builder: (column) => column);
}

class $$QuizAttemptsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $QuizAttemptsTable,
    QuizAttemptDB,
    $$QuizAttemptsTableFilterComposer,
    $$QuizAttemptsTableOrderingComposer,
    $$QuizAttemptsTableAnnotationComposer,
    $$QuizAttemptsTableCreateCompanionBuilder,
    $$QuizAttemptsTableUpdateCompanionBuilder,
    (
      QuizAttemptDB,
      BaseReferences<_$AppDatabase, $QuizAttemptsTable, QuizAttemptDB>
    ),
    QuizAttemptDB,
    PrefetchHooks Function()> {
  $$QuizAttemptsTableTableManager(_$AppDatabase db, $QuizAttemptsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String?> lessonRemoteId = const Value.absent(),
            Value<int> totalQuestions = const Value.absent(),
            Value<int> correctAnswers = const Value.absent(),
            Value<int> scorePercent = const Value.absent(),
            Value<int> earnedXp = const Value.absent(),
            Value<String> weakTopics = const Value.absent(),
            Value<DateTime> attemptedAt = const Value.absent(),
          }) =>
              QuizAttemptsCompanion(
            id: id,
            userId: userId,
            lessonRemoteId: lessonRemoteId,
            totalQuestions: totalQuestions,
            correctAnswers: correctAnswers,
            scorePercent: scorePercent,
            earnedXp: earnedXp,
            weakTopics: weakTopics,
            attemptedAt: attemptedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String userId,
            Value<String?> lessonRemoteId = const Value.absent(),
            required int totalQuestions,
            required int correctAnswers,
            required int scorePercent,
            required int earnedXp,
            Value<String> weakTopics = const Value.absent(),
            required DateTime attemptedAt,
          }) =>
              QuizAttemptsCompanion.insert(
            id: id,
            userId: userId,
            lessonRemoteId: lessonRemoteId,
            totalQuestions: totalQuestions,
            correctAnswers: correctAnswers,
            scorePercent: scorePercent,
            earnedXp: earnedXp,
            weakTopics: weakTopics,
            attemptedAt: attemptedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$QuizAttemptsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $QuizAttemptsTable,
    QuizAttemptDB,
    $$QuizAttemptsTableFilterComposer,
    $$QuizAttemptsTableOrderingComposer,
    $$QuizAttemptsTableAnnotationComposer,
    $$QuizAttemptsTableCreateCompanionBuilder,
    $$QuizAttemptsTableUpdateCompanionBuilder,
    (
      QuizAttemptDB,
      BaseReferences<_$AppDatabase, $QuizAttemptsTable, QuizAttemptDB>
    ),
    QuizAttemptDB,
    PrefetchHooks Function()>;
typedef $$ChatMessagesLocalTableCreateCompanionBuilder
    = ChatMessagesLocalCompanion Function({
  required String id,
  required String userId,
  required String role,
  required String content,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ChatMessagesLocalTableUpdateCompanionBuilder
    = ChatMessagesLocalCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> role,
  Value<String> content,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ChatMessagesLocalTableFilterComposer
    extends Composer<_$AppDatabase, $ChatMessagesLocalTable> {
  $$ChatMessagesLocalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ChatMessagesLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatMessagesLocalTable> {
  $$ChatMessagesLocalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ChatMessagesLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatMessagesLocalTable> {
  $$ChatMessagesLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ChatMessagesLocalTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChatMessagesLocalTable,
    ChatMessageDB,
    $$ChatMessagesLocalTableFilterComposer,
    $$ChatMessagesLocalTableOrderingComposer,
    $$ChatMessagesLocalTableAnnotationComposer,
    $$ChatMessagesLocalTableCreateCompanionBuilder,
    $$ChatMessagesLocalTableUpdateCompanionBuilder,
    (
      ChatMessageDB,
      BaseReferences<_$AppDatabase, $ChatMessagesLocalTable, ChatMessageDB>
    ),
    ChatMessageDB,
    PrefetchHooks Function()> {
  $$ChatMessagesLocalTableTableManager(
      _$AppDatabase db, $ChatMessagesLocalTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatMessagesLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatMessagesLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatMessagesLocalTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatMessagesLocalCompanion(
            id: id,
            userId: userId,
            role: role,
            content: content,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String role,
            required String content,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ChatMessagesLocalCompanion.insert(
            id: id,
            userId: userId,
            role: role,
            content: content,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChatMessagesLocalTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChatMessagesLocalTable,
    ChatMessageDB,
    $$ChatMessagesLocalTableFilterComposer,
    $$ChatMessagesLocalTableOrderingComposer,
    $$ChatMessagesLocalTableAnnotationComposer,
    $$ChatMessagesLocalTableCreateCompanionBuilder,
    $$ChatMessagesLocalTableUpdateCompanionBuilder,
    (
      ChatMessageDB,
      BaseReferences<_$AppDatabase, $ChatMessagesLocalTable, ChatMessageDB>
    ),
    ChatMessageDB,
    PrefetchHooks Function()>;
typedef $$MarchHistoryTableCreateCompanionBuilder = MarchHistoryCompanion
    Function({
  Value<int> id,
  Value<String> userId,
  required DateTime startedAt,
  required int totalDurationSeconds,
  required int successRate,
  Value<String> weakTopics,
  Value<String> itemsJson,
  Value<bool> isDirty,
  Value<DateTime?> syncedAt,
});
typedef $$MarchHistoryTableUpdateCompanionBuilder = MarchHistoryCompanion
    Function({
  Value<int> id,
  Value<String> userId,
  Value<DateTime> startedAt,
  Value<int> totalDurationSeconds,
  Value<int> successRate,
  Value<String> weakTopics,
  Value<String> itemsJson,
  Value<bool> isDirty,
  Value<DateTime?> syncedAt,
});

class $$MarchHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $MarchHistoryTable> {
  $$MarchHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalDurationSeconds => $composableBuilder(
      column: $table.totalDurationSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get successRate => $composableBuilder(
      column: $table.successRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weakTopics => $composableBuilder(
      column: $table.weakTopics, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemsJson => $composableBuilder(
      column: $table.itemsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDirty => $composableBuilder(
      column: $table.isDirty, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));
}

class $$MarchHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $MarchHistoryTable> {
  $$MarchHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalDurationSeconds => $composableBuilder(
      column: $table.totalDurationSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get successRate => $composableBuilder(
      column: $table.successRate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weakTopics => $composableBuilder(
      column: $table.weakTopics, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemsJson => $composableBuilder(
      column: $table.itemsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDirty => $composableBuilder(
      column: $table.isDirty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$MarchHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $MarchHistoryTable> {
  $$MarchHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get totalDurationSeconds => $composableBuilder(
      column: $table.totalDurationSeconds, builder: (column) => column);

  GeneratedColumn<int> get successRate => $composableBuilder(
      column: $table.successRate, builder: (column) => column);

  GeneratedColumn<String> get weakTopics => $composableBuilder(
      column: $table.weakTopics, builder: (column) => column);

  GeneratedColumn<String> get itemsJson =>
      $composableBuilder(column: $table.itemsJson, builder: (column) => column);

  GeneratedColumn<bool> get isDirty =>
      $composableBuilder(column: $table.isDirty, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$MarchHistoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MarchHistoryTable,
    MarchHistoryDB,
    $$MarchHistoryTableFilterComposer,
    $$MarchHistoryTableOrderingComposer,
    $$MarchHistoryTableAnnotationComposer,
    $$MarchHistoryTableCreateCompanionBuilder,
    $$MarchHistoryTableUpdateCompanionBuilder,
    (
      MarchHistoryDB,
      BaseReferences<_$AppDatabase, $MarchHistoryTable, MarchHistoryDB>
    ),
    MarchHistoryDB,
    PrefetchHooks Function()> {
  $$MarchHistoryTableTableManager(_$AppDatabase db, $MarchHistoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MarchHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MarchHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MarchHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<int> totalDurationSeconds = const Value.absent(),
            Value<int> successRate = const Value.absent(),
            Value<String> weakTopics = const Value.absent(),
            Value<String> itemsJson = const Value.absent(),
            Value<bool> isDirty = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
          }) =>
              MarchHistoryCompanion(
            id: id,
            userId: userId,
            startedAt: startedAt,
            totalDurationSeconds: totalDurationSeconds,
            successRate: successRate,
            weakTopics: weakTopics,
            itemsJson: itemsJson,
            isDirty: isDirty,
            syncedAt: syncedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            required DateTime startedAt,
            required int totalDurationSeconds,
            required int successRate,
            Value<String> weakTopics = const Value.absent(),
            Value<String> itemsJson = const Value.absent(),
            Value<bool> isDirty = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
          }) =>
              MarchHistoryCompanion.insert(
            id: id,
            userId: userId,
            startedAt: startedAt,
            totalDurationSeconds: totalDurationSeconds,
            successRate: successRate,
            weakTopics: weakTopics,
            itemsJson: itemsJson,
            isDirty: isDirty,
            syncedAt: syncedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MarchHistoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MarchHistoryTable,
    MarchHistoryDB,
    $$MarchHistoryTableFilterComposer,
    $$MarchHistoryTableOrderingComposer,
    $$MarchHistoryTableAnnotationComposer,
    $$MarchHistoryTableCreateCompanionBuilder,
    $$MarchHistoryTableUpdateCompanionBuilder,
    (
      MarchHistoryDB,
      BaseReferences<_$AppDatabase, $MarchHistoryTable, MarchHistoryDB>
    ),
    MarchHistoryDB,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CoursesTableTableManager get courses =>
      $$CoursesTableTableManager(_db, _db.courses);
  $$LessonsTableTableManager get lessons =>
      $$LessonsTableTableManager(_db, _db.lessons);
  $$UserProgressTableTableManager get userProgress =>
      $$UserProgressTableTableManager(_db, _db.userProgress);
  $$QuizAttemptsTableTableManager get quizAttempts =>
      $$QuizAttemptsTableTableManager(_db, _db.quizAttempts);
  $$ChatMessagesLocalTableTableManager get chatMessagesLocal =>
      $$ChatMessagesLocalTableTableManager(_db, _db.chatMessagesLocal);
  $$MarchHistoryTableTableManager get marchHistory =>
      $$MarchHistoryTableTableManager(_db, _db.marchHistory);
}
