import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_track.dart';
import '../repositories/onboarding_repository.dart';

/// Сценарій отримання збереженого треку.
class GetTrackUseCase {
  /// Створює сценарій отримання треку.
  const GetTrackUseCase(this._repository);

  final OnboardingRepository _repository;

  /// Отримує збережений трек.
  Future<Either<Failure, UserTrack?>> call() {
    return _repository.getTrack();
  }
}
