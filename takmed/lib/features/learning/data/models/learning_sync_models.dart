class RemoteCourseDto {
  const RemoteCourseDto({
    required this.remoteId,
    required this.title,
    required this.description,
    required this.track,
    required this.orderIndex,
    required this.totalLessons,
    required this.updatedAt,
  });

  final String remoteId;
  final String title;
  final String description;
  final String track;
  final int orderIndex;
  final int totalLessons;
  final DateTime updatedAt;

  factory RemoteCourseDto.fromMap(Map<String, dynamic> map) {
    return RemoteCourseDto(
      remoteId: map['remote_id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      track: map['track']?.toString() ?? 'military',
      orderIndex: (map['order_index'] as num?)?.toInt() ?? 0,
      totalLessons: (map['total_lessons'] as num?)?.toInt() ?? 0,
      updatedAt: _parseDate(map['updated_at']),
    );
  }
}

class RemoteLessonDto {
  const RemoteLessonDto({
    required this.remoteId,
    required this.courseRemoteId,
    required this.type,
    required this.title,
    required this.contentJson,
    required this.durationSeconds,
    required this.orderIndex,
    required this.xpReward,
    required this.updatedAt,
  });

  final String remoteId;
  final String courseRemoteId;
  final String type;
  final String title;
  final String contentJson;
  final int durationSeconds;
  final int orderIndex;
  final int xpReward;
  final DateTime updatedAt;

  factory RemoteLessonDto.fromMap(Map<String, dynamic> map) {
    return RemoteLessonDto(
      remoteId: map['remote_id']?.toString() ?? '',
      courseRemoteId: map['course_remote_id']?.toString() ?? '',
      type: map['type']?.toString() ?? 'theory',
      title: map['title']?.toString() ?? '',
      contentJson: map['content_json']?.toString() ?? '',
      durationSeconds: (map['duration_seconds'] as num?)?.toInt() ?? 0,
      orderIndex: (map['order_index'] as num?)?.toInt() ?? 0,
      xpReward: (map['xp_reward'] as num?)?.toInt() ?? 10,
      updatedAt: _parseDate(map['updated_at']),
    );
  }
}

class RemoteUserProgressDto {
  const RemoteUserProgressDto({
    required this.userId,
    required this.lessonRemoteId,
    required this.score,
    required this.attempts,
    required this.completedAt,
    required this.weakTopics,
    this.updatedAt,
  });

  final String userId;
  final String lessonRemoteId;
  final int score;
  final int attempts;
  final DateTime completedAt;
  final List<String> weakTopics;
  final DateTime? updatedAt;

  DateTime get effectiveUpdatedAt => updatedAt ?? completedAt;

  factory RemoteUserProgressDto.fromMap(Map<String, dynamic> map) {
    final rawWeakTopics = map['weak_topics'];
    final weakTopics =
        (rawWeakTopics is List)
            ? rawWeakTopics.map((e) => e.toString()).toList()
            : const <String>[];

    return RemoteUserProgressDto(
      userId: map['user_id']?.toString() ?? '',
      lessonRemoteId: map['lesson_remote_id']?.toString() ?? '',
      score: (map['score'] as num?)?.toInt() ?? 0,
      attempts: (map['attempts'] as num?)?.toInt() ?? 1,
      completedAt: _parseDate(map['completed_at']),
      weakTopics: weakTopics,
      updatedAt: _tryParseDate(map['updated_at']),
    );
  }

  Map<String, dynamic> toUpsertMap() {
    return <String, dynamic>{
      'user_id': userId,
      'lesson_remote_id': lessonRemoteId,
      'score': score,
      'attempts': attempts,
      'completed_at': completedAt.toUtc().toIso8601String(),
      'weak_topics': weakTopics,
      'updated_at': effectiveUpdatedAt.toUtc().toIso8601String(),
      'synced_at': DateTime.now().toUtc().toIso8601String(),
    };
  }
}

DateTime _parseDate(Object? raw) {
  if (raw is DateTime) {
    return raw.toUtc();
  }
  if (raw is String && raw.trim().isNotEmpty) {
    return DateTime.tryParse(raw)?.toUtc() ?? DateTime.now().toUtc();
  }
  return DateTime.now().toUtc();
}

DateTime? _tryParseDate(Object? raw) {
  if (raw is DateTime) {
    return raw.toUtc();
  }
  if (raw is String && raw.trim().isNotEmpty) {
    return DateTime.tryParse(raw)?.toUtc();
  }
  return null;
}
