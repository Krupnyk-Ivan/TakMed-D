import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/models/user_level.dart';

/// Повноекранний overlay при підвищенні рівня.
/// Показує конфеті + анімований текст нового рівня.
class LevelUpOverlay extends StatefulWidget {
  final UserLevel newLevel;
  final VoidCallback onDismiss;

  const LevelUpOverlay({
    super.key,
    required this.newLevel,
    required this.onDismiss,
  });

  @override
  State<LevelUpOverlay> createState() => _LevelUpOverlayState();
}

class _LevelUpOverlayState extends State<LevelUpOverlay>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confetti;
  late AnimationController _scaleCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 4))..play();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = CurvedAnimation(parent: _scaleCtrl, curve: Curves.elasticOut);
    _scaleCtrl.forward();
  }

  @override
  void dispose() {
    _confetti.dispose();
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onDismiss,
      child: Container(
        color: Colors.black.withValues(alpha: 0.85),
        child: Stack(
          children: [
            // Конфеті зверху
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confetti,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                numberOfParticles: 40,
                colors: const [
                  AppColors.primaryRed, Colors.amber,
                  AppColors.accentGreen, Colors.orange, Colors.purple,
                ],
              ),
            ),
            // Контент по центру
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: _scaleAnim,
                    child: const Text('🏅', style: TextStyle(fontSize: 80)),
                  ),
                  const SizedBox(height: 16),
                  ScaleTransition(
                    scale: _scaleAnim,
                    child: Text(
                      'НОВИЙ РІВЕНЬ!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryRed,
                        letterSpacing: 3,
                        shadows: [
                          Shadow(
                            color: AppColors.primaryRed.withValues(alpha: 0.5),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ScaleTransition(
                    scale: _scaleAnim,
                    child: Text(
                      widget.newLevel.title,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextButton(
                    onPressed: widget.onDismiss,
                    child: const Text(
                      'Далі →',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
