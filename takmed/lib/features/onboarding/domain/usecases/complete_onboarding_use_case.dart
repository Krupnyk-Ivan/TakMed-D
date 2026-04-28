import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/onboarding_repository.dart';

/// Сценарій завершення онбордингу.
class CompleteOnboardingUseCase {
  /// Створює сценарій завершення онбордингу.
  const CompleteOnboardingUseCase(this._repository);

  final OnboardingRepository _repository;

  /// Позначає онбординг як завершений.
  Future<Either<Failure, Unit>> call() {
    return _repository.setOnboardingCompleted();
  }
}
