import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/gamification/data/services/achievement_service.dart';
import '../../features/gamification/data/services/gamification_service.dart';
import '../../features/gamification/data/services/streak_service.dart';

/// Сервіс двосторонньої синхронізації гейміфікації з Supabase.
///
/// Стратегія злиття: беремо максимальні значення з обох джерел,
/// щоб прогрес з кількох пристроїв не затирався.
class GamificationCloudSync {
  GamificationCloudSync(
    this._client,
    this._gamification,
    this._streak,
    this._achievements,
  );

  final SupabaseClient _client;
  final GamificationService _gamification;
  final StreakService _streak;
  final AchievementService _achievements;

  static const _table = 'user_gamification';

  // ─── Push ────────────────────────────────────────────────────────────────────

  /// Зберігає поточний локальний стан у хмару (fire-and-forget).
  Future<void> pushToCloud() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final unlockedMap = _achievements.getUnlockedAchievements().map(
            (key, dt) => MapEntry(key, dt.toIso8601String()),
          );

      await _client.from(_table).upsert({
        'user_id': userId,
        'total_xp': _gamification.getTotalXp(),
        'current_streak': _streak.getCurrentStreak(),
        'best_streak': _streak.getBestStreak(),
        'last_activity_date': _streak.getLastActivityDate()?.toIso8601String(),
        'unlocked_achievements': jsonEncode(unlockedMap),
        'freezes_available': _streak.getFreezesAvailable(),
      });
    } catch (_) {
      // Fail-soft: дані вже збережені локально, спробуємо пізніше
    }
  }

  // ─── Pull ────────────────────────────────────────────────────────────────────

  /// Завантажує дані з хмари і зливає з локальними (max-wins стратегія).
  /// Повертає true, якщо локальний стан було оновлено.
  Future<bool> restoreFromCloud() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;

    try {
      final row = await _client
          .from(_table)
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (row == null) return false;

      bool changed = false;

      // XP: берем максимум
      final cloudXp = (row['total_xp'] as int?) ?? 0;
      final localXp = _gamification.getTotalXp();
      if (cloudXp > localXp) {
        await _gamification.setTotalXp(cloudXp);
        changed = true;
      }

      // Streak: берем максимум
      final cloudStreak = (row['current_streak'] as int?) ?? 0;
      final cloudBest = (row['best_streak'] as int?) ?? 0;
      if (cloudStreak > _streak.getCurrentStreak()) {
        await _streak.setCurrentStreak(cloudStreak);
        changed = true;
      }
      if (cloudBest > _streak.getBestStreak()) {
        await _streak.setBestStreak(cloudBest);
        changed = true;
      }

      // Freezes
      final cloudFreezes = (row['freezes_available'] as int?) ?? 0;
      if (cloudFreezes > _streak.getFreezesAvailable()) {
        await _streak.setFreezesAvailable(cloudFreezes);
        changed = true;
      }

      // Дата активності: беремо найновішу
      final cloudActivityStr = row['last_activity_date'] as String?;
      if (cloudActivityStr != null) {
        final cloudDate = DateTime.tryParse(cloudActivityStr);
        final localDate = _streak.getLastActivityDate();
        if (cloudDate != null &&
            (localDate == null || cloudDate.isAfter(localDate))) {
          await _streak.setLastActivityDate(cloudDate);
          changed = true;
        }
      }

      // Досягнення: union локальних і хмарних
      final cloudAchStr = row['unlocked_achievements'];
      if (cloudAchStr != null && cloudAchStr.toString().isNotEmpty) {
        try {
          final raw = jsonDecode(cloudAchStr.toString()) as Map<String, dynamic>;
          final localUnlocked = _achievements.getUnlockedAchievements();
          for (final entry in raw.entries) {
            if (!localUnlocked.containsKey(entry.key)) {
              await _achievements.unlockAchievementAt(
                entry.key,
                DateTime.tryParse(entry.value.toString()) ?? DateTime.now(),
              );
              changed = true;
            }
          }
        } catch (_) {}
      }

      return changed;
    } catch (_) {
      return false;
    }
  }
}
