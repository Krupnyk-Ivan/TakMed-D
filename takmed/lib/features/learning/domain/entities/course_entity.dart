import 'package:equatable/equatable.dart';

/// Доменна сутність курсу.
class CourseEntity extends Equatable {
  /// Створює сутність курсу.
  const CourseEntity({
    required this.id,
    required this.remoteId,
    required this.title,
    required this.description,
    required this.track,
    required this.orderIndex,
    required this.totalLessons,
    required this.completedLessons,
    required this.isDownloaded,
    required this.updatedAt,
  });

  /// Локальний ID.
  final int id;

  /// Віддалений ID.
  final String remoteId;

  /// Назва курсу.
  final String title;

  /// Опис курсу.
  final String description;

  /// Трек: 'military' або 'civilian'.
  final String track;

  /// Порядковий номер.
  final int orderIndex;

  /// Загальна кількість уроків.
  final int totalLessons;

  /// Завершені уроки.
  final int completedLessons;

  /// Чи завантажений офлайн.
  final bool isDownloaded;

  /// Час оновлення.
  final DateTime updatedAt;

  /// Відсоток прогресу (0.0 — 1.0).
  double get progressPercent =>
      totalLessons > 0 ? completedLessons / totalLessons : 0;

  /// Чи курс завершений.
  bool get isCompleted => totalLessons > 0 && completedLessons >= totalLessons;

  @override
  List<Object?> get props => [
        id, remoteId, title, description, track, orderIndex,
        totalLessons, completedLessons, isDownloaded, updatedAt,
      ];
}
