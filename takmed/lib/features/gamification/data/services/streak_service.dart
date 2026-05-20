import 'package:shared_preferences/shared_preferences.dart';

class StreakService {
  final SharedPreferences _prefs;

  static const String _lastActivityKey = 'streak_last_activity';
  static const String _currentStreakKey = 'streak_current';
  static const String _bestStreakKey = 'streak_best';
  static const String _freezesAvailableKey = 'streak_freezes_available';

  StreakService(this._prefs);

  int getCurrentStreak() => _prefs.getInt(_currentStreakKey) ?? 0;
  int getBestStreak() => _prefs.getInt(_bestStreakKey) ?? 0;
  int getFreezesAvailable() => _prefs.getInt(_freezesAvailableKey) ?? 0;

  Future<void> setCurrentStreak(int value) =>
      _prefs.setInt(_currentStreakKey, value);
  Future<void> setBestStreak(int value) =>
      _prefs.setInt(_bestStreakKey, value);
  Future<void> setFreezesAvailable(int value) =>
      _prefs.setInt(_freezesAvailableKey, value);
  Future<void> setLastActivityDate(DateTime date) =>
      _prefs.setString(_lastActivityKey, date.toIso8601String());
  
  DateTime? getLastActivityDate() {
    final str = _prefs.getString(_lastActivityKey);
    if (str == null) return null;
    return DateTime.tryParse(str);
  }

  /// Викликається щоразу, коли користувач відкриває додаток
  Future<void> checkStreak() async {
    final lastActivity = getLastActivityDate();
    if (lastActivity == null) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastActivityDay = DateTime(lastActivity.year, lastActivity.month, lastActivity.day);

    final difference = today.difference(lastActivityDay).inDays;

    if (difference > 1) {
      // Пропущено більше 1 дня
      final freezes = getFreezesAvailable();
      if (freezes >= difference - 1) {
        // Якщо є заморозки, використовуємо їх
        await _prefs.setInt(_freezesAvailableKey, freezes - (difference - 1));
        // Оновлюємо lastActivityDate на вчорашній день, ніби ми не пропускали
        final yesterday = today.subtract(const Duration(days: 1));
        await _prefs.setString(_lastActivityKey, yesterday.toIso8601String());
      } else {
        // Стрік втрачено
        await _prefs.setInt(_currentStreakKey, 0);
        await _prefs.setInt(_freezesAvailableKey, 0); // Обнуляємо заморозки при втраті стріку
      }
    }
  }

  /// Викликається коли користувач проходить урок / квіз
  Future<bool> registerActivity() async {
    await checkStreak(); // Спочатку перевіряємо чи не пропустили дні
    
    final lastActivity = getLastActivityDate();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    bool streakIncreased = false;

    if (lastActivity == null) {
      // Перша активність в історії
      await _prefs.setInt(_currentStreakKey, 1);
      await _prefs.setInt(_bestStreakKey, 1);
      streakIncreased = true;
    } else {
      final lastActivityDay = DateTime(lastActivity.year, lastActivity.month, lastActivity.day);
      final difference = today.difference(lastActivityDay).inDays;

      if (difference == 1) {
        // Активність на наступний день
        final current = getCurrentStreak() + 1;
        await _prefs.setInt(_currentStreakKey, current);
        streakIncreased = true;

        if (current > getBestStreak()) {
          await _prefs.setInt(_bestStreakKey, current);
        }

        // Даємо 1 заморозку кожні 7 днів стріку
        if (current % 7 == 0) {
          final freezes = getFreezesAvailable();
          await _prefs.setInt(_freezesAvailableKey, freezes + 1);
        }
      } else if (difference > 1) {
        // Якщо ми тут, то checkStreak не зміг врятувати стрік
        await _prefs.setInt(_currentStreakKey, 1);
        streakIncreased = true;
      }
    }

    // Оновлюємо дату останньої активності
    await _prefs.setString(_lastActivityKey, now.toIso8601String());
    
    return streakIncreased;
  }
}
