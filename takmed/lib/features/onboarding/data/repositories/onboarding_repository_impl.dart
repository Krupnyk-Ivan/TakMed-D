import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_track.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_data_source.dart';

/// Реалізація репозиторія онбордингу.
class OnboardingRepositoryImpl implements OnboardingRepository {
  /// Створює реалізацію репозиторія.
  const OnboardingRepositoryImpl(this._localDataSource);

  final OnboardingLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, Unit>> saveTrack(UserTrack track) async {
    try {
      await _localDataSource.saveTrack(track);
      return const Right<Failure, Unit>(unit);
    } on CacheException catch (e) {
      return Left<Failure, Unit>(CacheFailure(e.message));
    } catch (e) {
      return Left<Failure, Unit>(
        UnknownFailure('Помилка збереження треку: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, UserTrack?>> getTrack() async {
    try {
      final track = _localDataSource.getTrack();
      return Right<Failure, UserTrack?>(track);
    } on CacheException catch (e) {
      return Left<Failure, UserTrack?>(CacheFailure(e.message));
    } catch (e) {
      return Left<Failure, UserTrack?>(
        UnknownFailure('Помилка отримання треку: $e'),
      );
    }
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return _localDataSource.isOnboardingCompleted();
  }

  @override
  Future<Either<Failure, Unit>> setOnboardingCompleted() async {
    try {
      await _localDataSource.setOnboardingCompleted();
      return const Right<Failure, Unit>(unit);
    } on CacheException catch (e) {
      return Left<Failure, Unit>(CacheFailure(e.message));
    } catch (e) {
      return Left<Failure, Unit>(
        UnknownFailure('Помилка збереження статусу онбордингу: $e'),
      );
    }
  }
}
