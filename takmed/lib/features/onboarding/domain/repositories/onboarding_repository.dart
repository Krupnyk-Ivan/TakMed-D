import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_track.dart';

/// Контракт репозиторія онбордингу.
abstract class OnboardingRepository {
  /// Зберігає вибраний трек користувача.
  Future<Either<Failure, Unit>> saveTrack(UserTrack track);

  /// Отримує збережений трек користувача.
  Future<Either<Failure, UserTrack?>> getTrack();

  /// Перевіряє, чи онбординг вже пройдений.
  Future<bool> isOnboardingCompleted();

  /// Позначає онбординг як завершений.
  Future<Either<Failure, Unit>> setOnboardingCompleted();
}
