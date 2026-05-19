import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/entities/march_item.dart';

/// Велика картка кроку у списку — для locked / completed / failedQuiz станів.
/// Активна картка має окремий widget [MarchActiveCard].
class MarchStepCard extends StatelessWidget {
  const MarchStepCard({super.key, required this.item});
  final MarchItem item;

  @override
  Widget build(BuildContext context) {
    final isLocked = item.status == MarchItemStatus.locked;
    final isCompleted = item.status == MarchItemStatus.completed;
    final isFailed = item.status == MarchItemStatus.failedQuiz;

    final Color accent = isCompleted
        ? AppColors.accentGreen
        : isFailed
            ? AppColors.warningOrange
            : AppColors.textSecondary;

    return Opacity(
      opacity: isLocked ? 0.5 : 1.0,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLarge,
          vertical: AppDimensions.paddingSmall,
        ),
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          border: Border.all(color: accent.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            _LetterCircle(letter: item.step.code, color: accent),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.step.label,
                    style: const TextStyle(
                      fontSize: AppDimensions.fontSizeBase,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _subtitle(item),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            _TrailingIcon(
              isLocked: isLocked,
              isCompleted: isCompleted,
              isFailed: isFailed,
            ),
          ],
        ),
      ),
    );
  }

  String _subtitle(MarchItem item) {
    if (item.status == MarchItemStatus.locked) {
      return 'Заблоковано — спочатку попередні кроки';
    }
    if (item.status == MarchItemStatus.completed) {
      return 'Завершено за ${_formatSec(item.elapsedSeconds)} '
          '(рек. ${_formatSec(item.step.defaultMaxTimeSeconds)})';
    }
    if (item.status == MarchItemStatus.failedQuiz) {
      return 'Завершено з помилкою у тесті';
    }
    return '';
  }

  static String _formatSec(int s) {
    final m = s ~/ 60;
    final r = s % 60;
    return '$m:${r.toString().padLeft(2, '0')}';
  }
}

class _LetterCircle extends StatelessWidget {
  const _LetterCircle({required this.letter, required this.color});
  final String letter;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.15),
          border: Border.all(color: color, width: 2),
        ),
        alignment: Alignment.center,
        child: Text(
          letter,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: color,
          ),
        ),
      );
}

class _TrailingIcon extends StatelessWidget {
  const _TrailingIcon({
    required this.isLocked,
    required this.isCompleted,
    required this.isFailed,
  });
  final bool isLocked;
  final bool isCompleted;
  final bool isFailed;

  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return const Icon(Icons.check_circle, color: AppColors.accentGreen);
    }
    if (isFailed) {
      return const Icon(Icons.error_outline, color: AppColors.warningOrange);
    }
    if (isLocked) {
      return const Icon(Icons.lock_outline, color: AppColors.textSecondary);
    }
    return const SizedBox.shrink();
  }
}
