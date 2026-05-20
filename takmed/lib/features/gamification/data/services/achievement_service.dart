import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/achievement.dart';

class AchievementService {
  final SharedPreferences _prefs;
  
  static const String _unlockedKey = 'achievements_unlocked';

  AchievementService(this._prefs);

  /// Повертає список ID розблокованих значків з датою розблокування
  Map<String, DateTime> getUnlockedAchievements() {
    final str = _prefs.getString(_unlockedKey);
    if (str == null) return {};
    
    try {
      final map = jsonDecode(str) as Map<String, dynamic>;
      return map.map((key, value) => MapEntry(key, DateTime.parse(value.toString())));
    } catch (e) {
      return {};
    }
  }

  /// Розблоковує значок із конкретною датою (для відновлення з хмари).
  Future<void> unlockAchievementAt(String achievementId, DateTime at) async {
    final unlocked = getUnlockedAchievements();
    if (unlocked.containsKey(achievementId)) return;
    unlocked[achievementId] = at;
    await _prefs.setString(
      _unlockedKey,
      jsonEncode(unlocked.map((k, v) => MapEntry(k, v.toIso8601String()))),
    );
  }

  /// Розблоковує новий значок. Повертає true, якщо значок розблоковано ВПЕРШЕ.
  Future<bool> unlockAchievement(String achievementId) async {
    final unlocked = getUnlockedAchievements();
    
    if (unlocked.containsKey(achievementId)) {
      return false; // Вже розблоковано
    }

    unlocked[achievementId] = DateTime.now();
    
    // Зберігаємо як JSON
    final jsonStr = jsonEncode(
      unlocked.map((key, value) => MapEntry(key, value.toIso8601String()))
    );
    await _prefs.setString(_unlockedKey, jsonStr);
    
    return true;
  }

  /// Отримує повний список значків з їх статусом розблокування
  List<Achievement> getAllAchievementsWithStatus() {
    final unlocked = getUnlockedAchievements();
    
    return allAchievements.map((a) {
      if (unlocked.containsKey(a.id)) {
        return a.copyWith(isUnlocked: true, unlockedAt: unlocked[a.id]);
      }
      return a;
    }).toList();
  }
}
