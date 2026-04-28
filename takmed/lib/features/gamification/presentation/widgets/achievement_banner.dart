import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/models/achievement.dart';

/// Slide-in банер знизу екрану при розблокуванні нового значка.
class AchievementBanner extends StatefulWidget {
  final Achievement achievement;
  final VoidCallback onDismiss;

  const AchievementBanner({
    super.key,
    required this.achievement,
    required this.onDismiss,
  });

  @override
  State<AchievementBanner> createState() => _AchievementBannerState();
}

class _AchievementBannerState extends State<AchievementBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    _ctrl.forward();

    // Авто-приховати через 3 секунди
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _ctrl.reverse().then((_) {
          if (mounted) widget.onDismiss();
        });
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primaryRed.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(widget.achievement.icon,
                style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🎉 Нове досягнення!',
                      style: TextStyle(
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                  Text(widget.achievement.title,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 15)),
                  Text(widget.achievement.description,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.textSecondary, size: 18),
              onPressed: () {
                _ctrl.reverse().then((_) {
                  if (mounted) widget.onDismiss();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
