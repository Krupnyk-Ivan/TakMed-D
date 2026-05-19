import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../bloc/profile_state.dart';

/// Карта зі статистикою користувача: уроки, тести, XP, стрік.
class ProfileStatsCard extends StatelessWidget {
  const ProfileStatsCard({super.key, required this.stats});

  final ProfileStats stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Моя статистика',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeLarge,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacerMedium),
          Row(
            children: [
              Expanded(
                child: _StatCell(
                  icon: Icons.menu_book_outlined,
                  iconColor: AppColors.accentGreen,
                  label: 'Уроки',
                  value: '${stats.completedLessons}',
                ),
              ),
              Expanded(
                child: _StatCell(
                  icon: Icons.quiz_outlined,
                  iconColor: AppColors.infoBue,
                  label: 'Тести',
                  value: '${stats.quizAttempts}',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacerMedium),
          Row(
            children: [
              Expanded(
                child: _StatCell(
                  icon: Icons.bolt,
                  iconColor: AppColors.warningOrange,
                  label: 'XP',
                  value: '${stats.totalXp}',
                ),
              ),
              Expanded(
                child: _StatCell(
                  icon: Icons.local_fire_department,
                  iconColor: AppColors.primaryRed,
                  label: 'Стрік',
                  value: '${stats.currentStreak} дн.',
                  subValue: stats.bestStreak > 0
                      ? 'рекорд ${stats.bestStreak}'
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.subValue,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String? subValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: AppDimensions.fontSizeLarge,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
              if (subValue != null)
                Text(
                  subValue!,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
