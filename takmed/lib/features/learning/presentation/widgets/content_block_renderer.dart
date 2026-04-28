import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/entities/lesson_content/content_block.dart';

/// Рендерер блоків контенту уроку.
class ContentBlockRenderer extends StatelessWidget {
  const ContentBlockRenderer({super.key, required this.block});

  final ContentBlock block;

  @override
  Widget build(BuildContext context) {
    return switch (block) {
      TextBlock(:final text) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(text, style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            height: 1.7, color: AppColors.textPrimary,
          )),
        ),
      HeadingBlock(:final text, :final level) => Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(text, style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: level == 1 ? 24 : (level == 2 ? 20 : 18),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          )),
        ),
      ImageBlock(:final url, :final caption) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                child: Image.network(url, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180, color: AppColors.cardColor,
                    child: const Center(child: Icon(Icons.image_not_supported, color: AppColors.textSecondary, size: 48)),
                  ),
                ),
              ),
              if (caption != null) ...[
                const SizedBox(height: 6),
                Text(caption, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
              ],
            ],
          ),
        ),
      WarningBlock(:final text) => Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          decoration: BoxDecoration(
            color: AppColors.warningOrange.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            border: Border.all(color: AppColors.warningOrange.withValues(alpha: 0.4)),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.warningOrange, size: 22),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.warningOrange, height: 1.5))),
          ]),
        ),
      InfoBlock(:final text) => Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          decoration: BoxDecoration(
            color: AppColors.infoBue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            border: Border.all(color: AppColors.infoBue.withValues(alpha: 0.3)),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.info_outline, color: AppColors.infoBue, size: 22),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.infoBue, height: 1.5))),
          ]),
        ),
    };
  }
}
