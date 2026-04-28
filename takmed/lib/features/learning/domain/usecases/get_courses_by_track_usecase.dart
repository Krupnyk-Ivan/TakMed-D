import '../repositories/learning_repository.dart';
import '../entities/course_entity.dart';

/// Use case: отримання курсів за треком.
class GetCoursesByTrackUseCase {
  /// Створює use case.
  const GetCoursesByTrackUseCase(this._repository);

  final LearningRepository _repository;

  /// Повертає реактивний стрім курсів за треком.
  Stream<List<CourseEntity>> call(String track) {
    return _repository.watchCoursesByTrack(track);
  }
}
