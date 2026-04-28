import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/models/achievement.dart';

class AchievementGrid extends StatelessWidget {
  final List<Achievement> achievements;

  const AchievementGrid({super.key, required this.achievements});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final a = achievements[index];
        return GestureDetector(
          onTap: () => _showDetails(context, a),
          child: Opacity(
            opacity: a.isUnlocked ? 1.0 : 0.35,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: a.isUnlocked
                      ? AppColors.primaryRed.withValues(alpha: 0.5)
                      : AppColors.borderColor,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(a.icon, style: const TextStyle(fontSize: 36)),
                  const SizedBox(height: 6),
                  Text(
                    a.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: a.isUnlocked
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                  if (!a.isUnlocked) ...[
                    const SizedBox(height: 4),
                    const Icon(Icons.lock_outline,
                        size: 14, color: AppColors.textSecondary),
                  ] else if (a.unlockedAt != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(a.unlockedAt!),
                      style: const TextStyle(
                          fontSize: 9, color: AppColors.accentGreen),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDetails(BuildContext context, Achievement a) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color: AppColors.borderColor,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Text(a.icon, style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 12),
          Text(a.title,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text(a.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 15, color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          if (a.isUnlocked && a.unlockedAt != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.accentGreen.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('✅ Отримано ${_formatDate(a.unlockedAt!)}',
                  style: const TextStyle(
                      color: AppColors.accentGreen, fontWeight: FontWeight.w600)),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.borderColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('🔒 Ще не отримано',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
}
