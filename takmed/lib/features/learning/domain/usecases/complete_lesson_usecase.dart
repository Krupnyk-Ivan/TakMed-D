import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/learning_repository.dart';

/// Use case: завершення уроку.
class CompleteLessonUseCase {
  /// Створює use case.
  const CompleteLessonUseCase(this._repository);

  final LearningRepository _repository;

  /// Завершує урок з оцінкою.
  Future<Either<Failure, Unit>> call(int lessonId, {int score = 100}) {
    return _repository.completeLesson(lessonId, score);
  }
}
