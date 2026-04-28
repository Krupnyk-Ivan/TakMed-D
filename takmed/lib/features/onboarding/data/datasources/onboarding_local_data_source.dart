import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/user_track.dart';

/// Контракт локального джерела даних онбордингу.
abstract class OnboardingLocalDataSource {
  /// Зберігає вибраний трек.
  Future<void> saveTrack(UserTrack track);

  /// Отримує збережений трек.
  UserTrack? getTrack();

  /// Перевіряє, чи онбординг завершений.
  bool isOnboardingCompleted();

  /// Позначає онбординг як завершений.
  Future<void> setOnboardingCompleted();
}

/// Реалізація локального джерела даних через SharedPreferences.
class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  /// Створює екземпляр data source.
  const OnboardingLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  static const String _trackKey = 'user_track';
  static const String _onboardingCompletedKey = 'onboarding_completed';

  @override
  Future<void> saveTrack(UserTrack track) async {
    try {
      await _prefs.setString(_trackKey, track.name);
    } catch (e) {
      throw CacheException(message: 'Не вдалося зберегти трек: $e');
    }
  }

  @override
  UserTrack? getTrack() {
    final String? trackName = _prefs.getString(_trackKey);
    if (trackName == null) return null;

    try {
      return UserTrack.values.firstWhere((t) => t.name == trackName);
    } catch (_) {
      return null;
    }
  }

  @override
  bool isOnboardingCompleted() {
    return _prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  @override
  Future<void> setOnboardingCompleted() async {
    try {
      await _prefs.setBool(_onboardingCompletedKey, true);
    } catch (e) {
      throw CacheException(
        message: 'Не вдалося зберегти статус онбордингу: $e',
      );
    }
  }
}
