import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/entities/user_track.dart';

/// Віджет вибору треку користувача.
class TrackSelectionWidget extends StatelessWidget {
  /// Створює віджет вибору треку.
  const TrackSelectionWidget({
    super.key,
    required this.selectedTrack,
    required this.onTrackSelected,
  });

  /// Поточний вибраний трек.
  final UserTrack? selectedTrack;

  /// Callback при виборі треку.
  final ValueChanged<UserTrack> onTrackSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.padding3xLarge,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Іконка
          const Icon(
            Icons.route_rounded,
            size: 72,
            color: AppColors.primaryRed,
          ),
          const SizedBox(height: AppDimensions.spacerLarge),
          // Заголовок
          Text(
            'Оберіть свій шлях',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacerSmall),
          Text(
            'Контент буде адаптований під ваш профіль',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacerXLarge),
          // Кнопка: Військовий/Медик
          _TrackButton(
            emoji: '🪖',
            label: 'Я боєць / медик',
            description: 'Тактична медицина для бойових умов',
            isSelected: selectedTrack == UserTrack.military,
            onTap: () => onTrackSelected(UserTrack.military),
          ),
          const SizedBox(height: AppDimensions.spacerMedium),
          // Кнопка: Цивільний
          _TrackButton(
            emoji: '🏥',
            label: 'Я цивільний',
            description: 'Базова перша допомога на кожен день',
            isSelected: selectedTrack == UserTrack.civilian,
            onTap: () => onTrackSelected(UserTrack.civilian),
          ),
        ],
      ),
    );
  }
}

/// Стилізована кнопка вибору треку.
class _TrackButton extends StatelessWidget {
  const _TrackButton({
    required this.emoji,
    required this.label,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppDimensions.animationMedium,
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
          child: AnimatedContainer(
            duration: AppDimensions.animationMedium,
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(AppDimensions.paddingXLarge),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryRed.withValues(alpha: 0.15)
                  : AppColors.cardColor,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
              border: Border.all(
                color: isSelected ? AppColors.primaryRed : AppColors.borderColor,
                width: isSelected ? 2.0 : 1.0,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primaryRed.withValues(alpha: 0.2),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 36)),
                const SizedBox(width: AppDimensions.spacerMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isSelected
                              ? AppColors.primaryRed
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.primaryRed,
                    size: AppDimensions.iconMedium,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
