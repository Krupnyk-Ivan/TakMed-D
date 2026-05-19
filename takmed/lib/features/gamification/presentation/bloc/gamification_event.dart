import 'package:equatable/equatable.dart';

abstract class GamificationEvent extends Equatable {
  const GamificationEvent();
  @override
  List<Object?> get props => [];
}

/// Викликається при старті додатку — перевіряє стрік і нараховує щоденний XP.
class GamificationInitialized extends GamificationEvent {
  const GamificationInitialized();
}

/// Викликається після завершення теоретичного уроку.
class GamificationLessonCompleted extends GamificationEvent {
  final int lessonId;
  final String courseRemoteId;
  final bool isOffline;
  final bool isAllCourseComplete;
  final int totalCompletedLessons;

  const GamificationLessonCompleted({
    required this.lessonId,
    required this.courseRemoteId,
    required this.isOffline,
    required this.isAllCourseComplete,
    required this.totalCompletedLessons,
  });

  @override
  List<Object?> get props =>
      [lessonId, courseRemoteId, isOffline, isAllCourseComplete, totalCompletedLessons];
}

/// Викликається після завершення quiz-уроку.
class GamificationQuizCompleted extends GamificationEvent {
  final int totalQuestions;
  final int correctAnswers;
  final int earnedXp;
  final String courseRemoteId;
  final int fastAnswerCount;
  /// Загальна кількість спроб тестів (для досягнення quiz_5).
  final int totalQuizAttempts;

  const GamificationQuizCompleted({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.earnedXp,
    required this.courseRemoteId,
    required this.fastAnswerCount,
    this.totalQuizAttempts = 0,
  });

  @override
  List<Object?> get props =>
      [totalQuestions, correctAnswers, earnedXp, courseRemoteId, fastAnswerCount, totalQuizAttempts];
}

/// Скидає leveledUp та newlyUnlocked після показу анімацій/банерів.
class GamificationEventsSeen extends GamificationEvent {
  const GamificationEventsSeen();
}
