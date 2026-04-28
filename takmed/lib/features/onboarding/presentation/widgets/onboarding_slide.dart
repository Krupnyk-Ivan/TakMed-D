import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

/// Віджет слайду онбордингу.
class OnboardingSlide extends StatelessWidget {
  /// Створює слайд онбордингу.
  const OnboardingSlide({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.iconColor,
  });

  /// Іконка слайду.
  final IconData icon;

  /// Заголовок слайду.
  final String title;

  /// Опис слайду.
  final String description;

  /// Колір іконки (за замовчуванням primaryRed).
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.padding3xLarge,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Анімована іконка (placeholder замість Lottie)
          _AnimatedIcon(
            icon: icon,
            color: iconColor ?? AppColors.primaryRed,
          ),
          const SizedBox(height: AppDimensions.spacerXLarge),
          // Заголовок
          Text(
            title,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacerMedium),
          // Опис
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Анімований іконка-placeholder (пульсація).
class _AnimatedIcon extends StatefulWidget {
  const _AnimatedIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  State<_AnimatedIcon> createState() => _AnimatedIconState();
}

class _AnimatedIconState extends State<_AnimatedIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    widget.color.withValues(alpha: 0.3),
                    widget.color.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: Icon(
                widget.icon,
                size: 72,
                color: widget.color,
              ),
            ),
          ),
        );
      },
    );
  }
}
