import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_track.dart';
import '../repositories/onboarding_repository.dart';

/// Сценарій збереження вибраного треку.
class SaveTrackUseCase {
  /// Створює сценарій збереження треку.
  const SaveTrackUseCase(this._repository);

  final OnboardingRepository _repository;

  /// Зберігає трек та повертає результат.
  Future<Either<Failure, Unit>> call(UserTrack track) {
    return _repository.saveTrack(track);
  }
}
