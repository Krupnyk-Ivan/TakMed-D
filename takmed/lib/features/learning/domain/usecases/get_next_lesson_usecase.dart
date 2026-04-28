import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/lesson_entity.dart';
import '../repositories/learning_repository.dart';

/// Use case: отримання наступного уроку.
class GetNextLessonUseCase {
  /// Створює use case.
  const GetNextLessonUseCase(this._repository);

  final LearningRepository _repository;

  /// Отримує наступний незавершений урок.
  Future<Either<Failure, LessonEntity?>> call() {
    return _repository.getNextLesson();
  }
}
