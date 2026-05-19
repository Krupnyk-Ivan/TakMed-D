import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/entities/lesson_content/content_block.dart';

/// Рендерер блоків контенту уроку.
///
/// Використовує pattern-matching на sealed [ContentBlock].
/// Кожен тип блоку — окремий приватний віджет для тестування.
class ContentBlockRenderer extends StatelessWidget {
  const ContentBlockRenderer({super.key, required this.block});

  final ContentBlock block;

  @override
  Widget build(BuildContext context) {
    return switch (block) {
      TextBlock(:final text) => _TextBlockWidget(text: text),
      HeadingBlock(:final text, :final level) => _HeadingBlockWidget(text: text, level: level),
      ImageBlock(:final url, :final caption) => _ImageBlockWidget(url: url, caption: caption),
      WarningBlock(:final text) => _AlertBlockWidget(
          text: text,
          color: AppColors.warningOrange,
          icon: Icons.warning_amber_rounded,
        ),
      InfoBlock(:final text) => _AlertBlockWidget(
          text: text,
          color: AppColors.infoBue,
          icon: Icons.info_outline,
        ),
    };
  }
}

// ─── Block widgets ────────────────────────────────────────────

class _TextBlockWidget extends StatelessWidget {
  const _TextBlockWidget({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.7,
                color: AppColors.textPrimary,
              ),
        ),
      );
}

class _HeadingBlockWidget extends StatelessWidget {
  const _HeadingBlockWidget({required this.text, required this.level});
  final String text;
  final int level;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: level == 1 ? 24 : (level == 2 ? 20 : 18),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
        ),
      );
}

class _ImageBlockWidget extends StatelessWidget {
  const _ImageBlockWidget({required this.url, this.caption});
  final String url;
  final String? caption;

  static const _placeholderHeight = 200.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            child: _buildImage(),
          ),
          if (caption != null && caption!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              caption!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImage() {
    final isNetwork = url.startsWith('http://') || url.startsWith('https://');

    if (!isNetwork || url.trim().isEmpty) {
      return _placeholder(Icons.image_not_supported);
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, __) => SizedBox(
        height: _placeholderHeight,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryRed.withValues(alpha: 0.7),
            strokeWidth: 2,
          ),
        ),
      ),
      errorWidget: (_, __, ___) => _placeholder(Icons.broken_image_outlined),
    );
  }

  Widget _placeholder(IconData icon) => Container(
        height: _placeholderHeight,
        color: AppColors.cardColor,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.textSecondary, size: 48),
              const SizedBox(height: 8),
              const Text(
                'Зображення недоступне',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
      );
}

class _AlertBlockWidget extends StatelessWidget {
  const _AlertBlockWidget({
    required this.text,
    required this.color,
    required this.icon,
  });
  final String text;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: color,
                      height: 1.5,
                    ),
              ),
            ),
          ],
        ),
      );
}
