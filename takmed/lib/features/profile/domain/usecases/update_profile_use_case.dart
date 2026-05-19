import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  const UpdateProfileUseCase(this._repository);
  final ProfileRepository _repository;

  Future<Either<Failure, ProfileEntity>> call(ProfileEntity profile) =>
      _repository.updateProfile(profile);
}
