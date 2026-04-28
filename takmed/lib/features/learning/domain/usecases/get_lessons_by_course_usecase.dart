import '../repositories/learning_repository.dart';
import '../entities/lesson_entity.dart';

/// Use case: отримання уроків курсу.
class GetLessonsByCourseUseCase {
  /// Створює use case.
  const GetLessonsByCourseUseCase(this._repository);

  final LearningRepository _repository;

  /// Повертає реактивний стрім уроків.
  Stream<List<LessonEntity>> call(int courseId) {
    return _repository.watchLessonsByCourse(courseId);
  }
}
