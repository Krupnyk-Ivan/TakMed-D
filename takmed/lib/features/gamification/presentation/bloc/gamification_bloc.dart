import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/achievement_service.dart';
import '../../data/services/gamification_service.dart';
import '../../data/services/streak_reminder_service.dart';
import '../../data/services/streak_service.dart';
import '../../domain/models/achievement.dart';
import 'gamification_event.dart';
import 'gamification_state.dart';

class GamificationBloc extends Bloc<GamificationEvent, GamificationState> {
  final GamificationService _gamificationService;
  final StreakService _streakService;
  final AchievementService _achievementService;
  final StreakReminderService _reminderService;

  GamificationBloc(
    this._gamificationService,
    this._streakService,
    this._achievementService,
    this._reminderService,
  ) : super(const GamificationState()) {
    on<GamificationInitialized>(_onInitialized);
    on<GamificationLessonCompleted>(_onLessonCompleted);
    on<GamificationQuizCompleted>(_onQuizCompleted);
    on<GamificationEventsSeen>(_onEventsSeen);
  }

  Future<void> _onInitialized(
    GamificationInitialized event,
    Emitter<GamificationState> emit,
  ) async {
    await _streakService.checkStreak();
    final xpAwarded = await _gamificationService.awardDailyLoginXp();
    final streak = _streakService.getCurrentStreak();

    try {
      await _reminderService.scheduleDailyReminder(streak);
    } catch (_) {}

    final achievements = _achievementService.getAllAchievementsWithStatus();
    final newlyUnlocked = <Achievement>[];

    // Перевіряємо стрік-досягнення для тих хто вже має стрік (наприклад після перезапуску)
    if (streak >= 3) {
      if (await _achievementService.unlockAchievement('streak_3')) {
        newlyUnlocked.add(_findAchievement(achievements, 'streak_3'));
      }
    }
    if (streak >= 7) {
      if (await _achievementService.unlockAchievement('streak_7')) {
        newlyUnlocked.add(_findAchievement(achievements, 'streak_7'));
      }
    }
    if (streak >= 30) {
      if (await _achievementService.unlockAchievement('streak_30')) {
        newlyUnlocked.add(_findAchievement(achievements, 'streak_30'));
      }
    }

    emit(GamificationState(
      totalXp: _gamificationService.getTotalXp(),
      currentLevel: _gamificationService.getCurrentLevel(),
      streak: streak,
      bestStreak: _streakService.getBestStreak(),
      achievements: _achievementService.getAllAchievementsWithStatus(),
      newlyUnlocked: newlyUnlocked,
      leveledUp: false,
      xpAwarded: xpAwarded,
    ));
  }

  Future<void> _onLessonCompleted(
    GamificationLessonCompleted event,
    Emitter<GamificationState> emit,
  ) async {
    int totalXpAwarded = 0;
    bool leveledUp = false;

    // +10 XP за урок
    leveledUp |= await _gamificationService.awardXp(10);
    totalXpAwarded += 10;

    // Реєструємо активність (стрік)
    await _streakService.registerActivity();
    final newStreak = _streakService.getCurrentStreak();

    // +100 XP за кожні 7 днів стріку
    if (newStreak > 0 && newStreak % 7 == 0) {
      leveledUp |= await _gamificationService.awardXp(100);
      totalXpAwarded += 100;
    }

    // Відміняємо нагадування на сьогодні
    try {
      await _reminderService.cancelReminderForToday(newStreak);
    } catch (_) {}

    // Перевіряємо значки
    final newlyUnlocked = <Achievement>[];
    await _tryUnlock('first_lesson', newlyUnlocked);
    if (newStreak >= 3) await _tryUnlock('streak_3', newlyUnlocked);
    if (newStreak >= 7) await _tryUnlock('streak_7', newlyUnlocked);
    if (newStreak >= 30) await _tryUnlock('streak_30', newlyUnlocked);
    if (event.isAllCourseComplete) {
      if (event.courseRemoteId == 'mil-1') await _tryUnlock('march_complete', newlyUnlocked);
      if (event.courseRemoteId == 'mil-2') await _tryUnlock('tourniquet_master', newlyUnlocked);
      if (event.courseRemoteId == 'mil-3') await _tryUnlock('chest_seal_pro', newlyUnlocked);
      if (event.courseRemoteId == 'civ-2') await _tryUnlock('cpr_expert', newlyUnlocked);
      await _tryUnlock('veteran', newlyUnlocked);
    }
    if (event.isOffline) await _tryUnlock('offline_warrior', newlyUnlocked);
    if (event.totalCompletedLessons >= 5) await _tryUnlock('knowledge_seeker', newlyUnlocked);
    if (DateTime.now().hour >= 22) await _tryUnlock('night_owl', newlyUnlocked);

    emit(state.copyWith(
      totalXp: _gamificationService.getTotalXp(),
      currentLevel: _gamificationService.getCurrentLevel(),
      streak: newStreak,
      bestStreak: _streakService.getBestStreak(),
      achievements: _achievementService.getAllAchievementsWithStatus(),
      newlyUnlocked: newlyUnlocked,
      leveledUp: leveledUp,
      xpAwarded: totalXpAwarded,
    ));
  }

  Future<void> _onQuizCompleted(
    GamificationQuizCompleted event,
    Emitter<GamificationState> emit,
  ) async {
    int totalXpAwarded = event.earnedXp;
    bool leveledUp = false;

    // XP за правильні відповіді (вже підраховано в QuizBloc як earnedXp)
    leveledUp |= await _gamificationService.awardXp(event.earnedXp);

    // Бонус +50 за 100% результат
    final isPerfect = event.totalQuestions > 0 &&
        event.correctAnswers == event.totalQuestions;
    if (isPerfect) {
      leveledUp |= await _gamificationService.awardXp(50);
      totalXpAwarded += 50;
    }

    // Реєструємо активність
    await _streakService.registerActivity();
    final newStreak = _streakService.getCurrentStreak();

    // +100 XP за кожні 7 днів стріку
    if (newStreak > 0 && newStreak % 7 == 0) {
      leveledUp |= await _gamificationService.awardXp(100);
      totalXpAwarded += 100;
    }

    try {
      await _reminderService.cancelReminderForToday(newStreak);
    } catch (_) {}

    // Значки
    final newlyUnlocked = <Achievement>[];
    await _tryUnlock('first_quiz', newlyUnlocked);
    if (isPerfect) await _tryUnlock('perfect_quiz', newlyUnlocked);
    if (event.fastAnswerCount >= 10) await _tryUnlock('speed_demon', newlyUnlocked);
    if (newStreak >= 3) await _tryUnlock('streak_3', newlyUnlocked);
    if (newStreak >= 7) await _tryUnlock('streak_7', newlyUnlocked);
    if (newStreak >= 30) await _tryUnlock('streak_30', newlyUnlocked);

    emit(state.copyWith(
      totalXp: _gamificationService.getTotalXp(),
      currentLevel: _gamificationService.getCurrentLevel(),
      streak: newStreak,
      bestStreak: _streakService.getBestStreak(),
      achievements: _achievementService.getAllAchievementsWithStatus(),
      newlyUnlocked: newlyUnlocked,
      leveledUp: leveledUp,
      xpAwarded: totalXpAwarded,
    ));
  }

  void _onEventsSeen(GamificationEventsSeen event, Emitter<GamificationState> emit) {
    emit(state.copyWith(
      newlyUnlocked: const [],
      leveledUp: false,
      xpAwarded: 0,
    ));
  }

  Future<void> _tryUnlock(String id, List<Achievement> newlyUnlocked) async {
    if (await _achievementService.unlockAchievement(id)) {
      final all = _achievementService.getAllAchievementsWithStatus();
      final found = all.where((a) => a.id == id).firstOrNull;
      if (found != null) newlyUnlocked.add(found);
    }
  }

  Achievement _findAchievement(List<Achievement> list, String id) {
    return list.firstWhere((a) => a.id == id,
        orElse: () => Achievement(id: id, icon: '🏅', title: id, description: ''));
  }
}
