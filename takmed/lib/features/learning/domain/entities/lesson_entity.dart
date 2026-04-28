import 'package:equatable/equatable.dart';

/// Доменна сутність уроку.
class LessonEntity extends Equatable {
  /// Створює сутність уроку.
  const LessonEntity({
    required this.id,
    required this.remoteId,
    required this.courseId,
    required this.type,
    required this.title,
    required this.contentJson,
    required this.durationSeconds,
    required this.orderIndex,
    required this.isCompleted,
    required this.xpReward,
  });

  /// Локальний ID.
  final int id;

  /// Віддалений ID.
  final String remoteId;

  /// ID курсу.
  final int courseId;

  /// Тип: 'theory', 'video', 'quiz', 'checklist'.
  final String type;

  /// Назва уроку.
  final String title;

  /// JSON контент.
  final String contentJson;

  /// Тривалість у секундах.
  final int durationSeconds;

  /// Порядковий номер.
  final int orderIndex;

  /// Чи завершений.
  final bool isCompleted;

  /// XP нагорода.
  final int xpReward;

  /// Іконка типу уроку.
  String get typeEmoji {
    switch (type) {
      case 'theory':
        return '📖';
      case 'video':
        return '🎥';
      case 'quiz':
        return '❓';
      case 'checklist':
        return '✅';
      default:
        return '📄';
    }
  }

  /// Форматована тривалість.
  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    if (minutes < 1) return '<1 хв';
    return '$minutes хв';
  }

  @override
  List<Object?> get props => [
        id, remoteId, courseId, type, title, contentJson,
        durationSeconds, orderIndex, isCompleted, xpReward,
      ];
}
