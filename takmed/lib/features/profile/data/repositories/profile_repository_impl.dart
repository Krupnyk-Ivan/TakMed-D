import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._remote);
  final ProfileRemoteDataSource _remote;

  @override
  Future<Either<Failure, ProfileEntity>> getCurrentProfile() async {
    try {
      final model = await _remote.fetchCurrentProfile();
      return Right(model);
    } on AppAuthException catch (e) {
      if (e.message == 'Користувача не авторизовано') {
        return const Right(ProfileEntity(
          id: '',
          name: 'Гість',
          email: 'Гість',
          track: 'military',
        ));
      }
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Помилка завантаження профілю: $e'));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile(ProfileEntity profile) async {
    try {
      final updated = await _remote.updateProfile(ProfileModel.fromEntity(profile));
      return Right(updated);
    } on AppAuthException catch (e) {
      if (e.message == 'Користувача не авторизовано') {
        // Для гостя просто повертаємо його ж об'єкт (симуляція успішного збереження)
        return Right(profile);
      }
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Помилка збереження профілю: $e'));
    }
  }
}
