import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/profile_entity.dart';

/// Контракт репозиторію профілю.
abstract class ProfileRepository {
  /// Завантажує профіль поточного користувача.
  Future<Either<Failure, ProfileEntity>> getCurrentProfile();

  /// Оновлює профіль (name, avatarUrl, track).
  Future<Either<Failure, ProfileEntity>> updateProfile(ProfileEntity profile);
}
