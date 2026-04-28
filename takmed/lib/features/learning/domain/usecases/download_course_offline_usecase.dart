import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/learning_repository.dart';

/// Use case: завантаження курсу офлайн.
class DownloadCourseOfflineUseCase {
  /// Створює use case.
  const DownloadCourseOfflineUseCase(this._repository);

  final LearningRepository _repository;

  /// Завантажує курс для офлайн використання.
  Future<Either<Failure, Unit>> call(int courseId) {
    return _repository.downloadCourseOffline(courseId);
  }
}
