import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_user_model.dart';

/// Реалізація репозиторія авторизації.
class AuthRepositoryImpl implements AuthRepository {
  /// Створює реалізацію репозиторія.
  const AuthRepositoryImpl(this._remoteDataSource, this._secureStorage);

  final AuthRemoteDataSource _remoteDataSource;
  final FlutterSecureStorage _secureStorage;

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  @override
  Future<Either<Failure, AuthUser>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final AuthUserModel user = await _remoteDataSource.signIn(
        email: email,
        password: password,
      );
      // Зберігає маркер у безпечному сховищі
      await _secureStorage.write(key: _tokenKey, value: user.token);
      await _secureStorage.write(
        key: _userKey,
        value: user.toJson().toString(),
      );
      return Right<Failure, AuthUser>(user);
    } on AppAuthException catch (error) {
      return Left<Failure, AuthUser>(AuthFailure(error.message));
    } catch (error) {
      return Left<Failure, AuthUser>(
        UnknownFailure('${AppStrings.unexpectedAuthError}: $error'),
      );
    }
  }

  @override
  Future<Either<Failure, AuthUser>> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final AuthUserModel user = await _remoteDataSource.signUp(
        email: email,
        password: password,
        name: name,
      );
      // Зберігає маркер у безпечному сховищі
      await _secureStorage.write(key: _tokenKey, value: user.token);
      await _secureStorage.write(
        key: _userKey,
        value: user.toJson().toString(),
      );
      return Right<Failure, AuthUser>(user);
    } on AppAuthException catch (error) {
      return Left<Failure, AuthUser>(AuthFailure(error.message));
    } catch (error) {
      return Left<Failure, AuthUser>(
        UnknownFailure('${AppStrings.unexpectedAuthError}: $error'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({required String email}) async {
    try {
      await _remoteDataSource.resetPassword(email: email);
      return const Right<Failure, Unit>(unit);
    } on AppAuthException catch (error) {
      return Left<Failure, Unit>(AuthFailure(error.message));
    } catch (error) {
      return Left<Failure, Unit>(
        UnknownFailure('${AppStrings.unexpectedAuthError}: $error'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _remoteDataSource.logout();
      // Видаляє маркер та інформацію про користувача
      await _secureStorage.delete(key: _tokenKey);
      await _secureStorage.delete(key: _userKey);
      return const Right<Failure, Unit>(unit);
    } on AppAuthException catch (error) {
      return Left<Failure, Unit>(AuthFailure(error.message));
    } catch (error) {
      return Left<Failure, Unit>(
        UnknownFailure('${AppStrings.unexpectedAuthError}: $error'),
      );
    }
  }

  @override
  Future<Either<Failure, AuthUser>> refreshToken() async {
    try {
      final AuthUserModel user = await _remoteDataSource.refreshToken();
      // Оновлює маркер у безпечному сховищі
      await _secureStorage.write(key: _tokenKey, value: user.token);
      await _secureStorage.write(
        key: _userKey,
        value: user.toJson().toString(),
      );
      return Right<Failure, AuthUser>(user);
    } on AppAuthException catch (error) {
      return Left<Failure, AuthUser>(AuthFailure(error.message));
    } catch (error) {
      return Left<Failure, AuthUser>(
        UnknownFailure('${AppStrings.unexpectedAuthError}: $error'),
      );
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final String? token = await _secureStorage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    try {
      final String? userJson = await _secureStorage.read(key: _userKey);
      if (userJson == null) return null;
      // Парсування JSON та повернення користувача
      final Map<String, dynamic> userMap = Map<String, dynamic>.from(
        userJson
            .replaceAll('{', '')
            .replaceAll('}', '')
            .split(', ')
            .fold<Map<String, dynamic>>({}, (map, pair) {
              final parts = pair.split(': ');
              if (parts.length == 2) {
                map[parts[0]] = parts[1];
              }
              return map;
            }),
      );
      return AuthUserModel.fromJson(userMap);
    } catch (_) {
      return null;
    }
  }
}
