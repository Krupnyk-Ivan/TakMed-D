import 'package:equatable/equatable.dart';
import '../../domain/models/achievement.dart';
import '../../domain/models/user_level.dart';

class GamificationState extends Equatable {
  final int totalXp;
  final UserLevel currentLevel;
  final int streak;
  final int bestStreak;
  final List<Achievement> achievements;
  final List<Achievement> newlyUnlocked;
  final bool leveledUp;
  final int xpAwarded;

  const GamificationState({
    this.totalXp = 0,
    this.currentLevel = UserLevel.recruit,
    this.streak = 0,
    this.bestStreak = 0,
    this.achievements = const [],
    this.newlyUnlocked = const [],
    this.leveledUp = false,
    this.xpAwarded = 0,
  });

  GamificationState copyWith({
    int? totalXp,
    UserLevel? currentLevel,
    int? streak,
    int? bestStreak,
    List<Achievement>? achievements,
    List<Achievement>? newlyUnlocked,
    bool? leveledUp,
    int? xpAwarded,
  }) {
    return GamificationState(
      totalXp: totalXp ?? this.totalXp,
      currentLevel: currentLevel ?? this.currentLevel,
      streak: streak ?? this.streak,
      bestStreak: bestStreak ?? this.bestStreak,
      achievements: achievements ?? this.achievements,
      newlyUnlocked: newlyUnlocked ?? this.newlyUnlocked,
      leveledUp: leveledUp ?? this.leveledUp,
      xpAwarded: xpAwarded ?? this.xpAwarded,
    );
  }

  @override
  List<Object?> get props => [
        totalXp, currentLevel, streak, bestStreak,
        achievements, newlyUnlocked, leveledUp, xpAwarded,
      ];
}
