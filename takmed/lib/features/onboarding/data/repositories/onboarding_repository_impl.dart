import 'dart:async' show unawaited;
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_track.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_data_source.dart';

/// Реалізація репозиторія онбордингу.
class OnboardingRepositoryImpl implements OnboardingRepository {
  /// Створює реалізацію репозиторія.
  const OnboardingRepositoryImpl(this._localDataSource, this._client);

  final OnboardingLocalDataSource _localDataSource;
  final SupabaseClient _client;

  @override
  Future<Either<Failure, Unit>> saveTrack(UserTrack track) async {
    try {
      await _localDataSource.saveTrack(track);

      // Синхронізуємо трек у хмару (fire-and-forget)
      final userId = _client.auth.currentUser?.id;
      if (userId != null) {
        unawaited(
          _client.from('profiles').upsert({
            'id': userId,
            'track': track.name,
          }).catchError((_) {}),
        );
      }

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
      final local = _localDataSource.getTrack();
      if (local != null) return Right<Failure, UserTrack?>(local);

      // Локально порожньо — спробуємо відновити з Supabase
      final userId = _client.auth.currentUser?.id;
      if (userId != null) {
        final row = await _client
            .from('profiles')
            .select('track')
            .eq('id', userId)
            .maybeSingle();
        final trackName = row?['track'] as String?;
        if (trackName != null) {
          final cloudTrack = UserTrack.values.cast<UserTrack?>().firstWhere(
                (t) => t?.name == trackName,
                orElse: () => null,
              );
          if (cloudTrack != null) {
            await _localDataSource.saveTrack(cloudTrack);
            return Right<Failure, UserTrack?>(cloudTrack);
          }
        }
      }

      return const Right<Failure, UserTrack?>(null);
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
