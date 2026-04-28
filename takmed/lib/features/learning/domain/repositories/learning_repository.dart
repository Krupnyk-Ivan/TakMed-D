import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/course_entity.dart';
import '../entities/lesson_entity.dart';

/// Контракт репозиторія навчання.
abstract class LearningRepository {
  /// Отримує курси за треком (реактивний стрім).
  Stream<List<CourseEntity>> watchCoursesByTrack(String track);

  /// Отримує уроки курсу (реактивний стрім).
  Stream<List<LessonEntity>> watchLessonsByCourse(int courseId);

  /// Завершує урок і зберігає прогрес.
  Future<Either<Failure, Unit>> completeLesson(int lessonId, int score);

  /// Отримує наступний незавершений урок.
  Future<Either<Failure, LessonEntity?>> getNextLesson();

  /// Отримує наступний урок у конкретному курсі.
  Future<Either<Failure, LessonEntity?>> getNextLessonInCourse(int courseId);

  /// Позначає курс як завантажений офлайн.
  Future<Either<Failure, Unit>> downloadCourseOffline(int courseId);

  /// Синхронізує з сервером (stub).
  Future<Either<Failure, Unit>> syncWithServer();

  /// Отримує курс за ID.
  Future<Either<Failure, CourseEntity?>> getCourseById(int id);

  /// Ініціалізує seed data.
  Future<void> seedIfEmpty();
}
