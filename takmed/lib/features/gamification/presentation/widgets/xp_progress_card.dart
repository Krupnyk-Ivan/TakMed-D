import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../domain/models/user_level.dart';

class XpProgressCard extends StatelessWidget {
  final int totalXp;
  final UserLevel currentLevel;
  final int streak;
  final int bestStreak;

  const XpProgressCard({
    super.key,
    required this.totalXp,
    required this.currentLevel,
    required this.streak,
    required this.bestStreak,
  });

  @override
  Widget build(BuildContext context) {
    final nextLevel = currentLevel.nextLevel;
    final double progress = nextLevel == null
        ? 1.0
        : (totalXp - currentLevel.minXp) /
            (nextLevel.minXp - currentLevel.minXp).clamp(1, double.infinity);

    return GestureDetector(
      onTap: () => context.push(AppRoutes.gamification),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Рівень
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(children: [
                    const Text('🏅', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(currentLevel.title,
                        style: const TextStyle(
                            color: AppColors.primaryRed,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                  ]),
                ),
                const Spacer(),
                // Стрік
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warningOrange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(children: [
                    const Text('🔥', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 4),
                    Text('$streak',
                        style: const TextStyle(
                            color: AppColors.warningOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                  ]),
                ),
                const SizedBox(width: 8),
                // XP
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(children: [
                    const Text('⚡', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text('$totalXp XP',
                        style: const TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                  ]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Прогрес-бар до наступного рівня
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: AppColors.borderColor,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              nextLevel != null
                  ? 'До рівня "${nextLevel.title}": ${nextLevel.minXp - totalXp} XP'
                  : '🎖️ Максимальний рівень досягнуто!',
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
