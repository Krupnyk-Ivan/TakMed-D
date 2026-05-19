import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/user_level.dart';

class GamificationService {
  final SharedPreferences _prefs;

  static const String _xpKey = 'gamification_total_xp';
  static const String _lastLoginDateKey = 'gamification_last_login_date';
  static const String _completedCoursesKey = 'gamification_completed_courses';

  GamificationService(this._prefs);

  int getTotalXp() => _prefs.getInt(_xpKey) ?? 0;

  UserLevel getCurrentLevel() => UserLevel.getLevelForXp(getTotalXp());

  /// Нараховує XP та повертає true, якщо користувач отримав новий рівень.
  Future<bool> awardXp(int amount) async {
    final currentXp = getTotalXp();
    final currentLevel = UserLevel.getLevelForXp(currentXp);
    final newXp = currentXp + amount;
    await _prefs.setInt(_xpKey, newXp);
    final newLevel = UserLevel.getLevelForXp(newXp);
    return newLevel.id > currentLevel.id;
  }

  /// Нараховує +5 XP за щоденний вхід (один раз на день).
  /// Повертає 5 якщо XP нараховано, 0 якщо вже нараховано сьогодні.
  Future<int> awardDailyLoginXp() async {
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month}-${today.day}';
    if (_prefs.getString(_lastLoginDateKey) == todayStr) return 0;
    await _prefs.setString(_lastLoginDateKey, todayStr);
    await awardXp(5);
    return 5;
  }

  int getCompletedCoursesCount() {
    final set = _prefs.getStringList(_completedCoursesKey) ?? [];
    return set.length;
  }

  Future<void> markCourseCompleted(String courseRemoteId) async {
    final set = (_prefs.getStringList(_completedCoursesKey) ?? []).toSet();
    set.add(courseRemoteId);
    await _prefs.setStringList(_completedCoursesKey, set.toList());
  }

  Future<void> resetXp() async {
    await _prefs.setInt(_xpKey, 0);
  }
}
