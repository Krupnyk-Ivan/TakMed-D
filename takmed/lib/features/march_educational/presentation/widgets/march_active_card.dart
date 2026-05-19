import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_routes.dart';
import '../../domain/entities/march_item.dart';
import '../bloc/march_educational_bloc.dart';
import '../bloc/march_educational_event.dart';

/// Велика активна картка з таймером, шпаргалкою та кнопками
/// "Завершити крок" / "Запитати ШІ".
class MarchActiveCard extends StatelessWidget {
  const MarchActiveCard({super.key, required this.item, required this.hintExpanded});

  final MarchItem item;
  final bool hintExpanded;

  @override
  Widget build(BuildContext context) {
    final elapsed = item.elapsedSeconds;
    final recommended = item.step.defaultMaxTimeSeconds;
    final ratio = (elapsed / recommended).clamp(0.0, 1.5);
    final isOver = elapsed > recommended;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLarge,
        vertical: AppDimensions.paddingSmall,
      ),
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: AppColors.primaryRed, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryRed.withValues(alpha: 0.15),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: літера + назва
          Row(children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryRed.withValues(alpha: 0.2),
                border: Border.all(color: AppColors.primaryRed, width: 2),
              ),
              alignment: Alignment.center,
              child: Text(
                item.step.code,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryRed,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'АКТИВНИЙ КРОК',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1.2,
                      color: AppColors.primaryRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.step.label,
                    style: const TextStyle(
                      fontSize: AppDimensions.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 16),
          // Таймер: рекомендований vs поточний
          _TimerBlock(
            elapsed: elapsed,
            recommended: recommended,
            ratio: ratio,
            isOver: isOver,
          ),
          const SizedBox(height: 14),
          // Шпаргалка (collapsible)
          _CheatSheet(item: item, expanded: hintExpanded),
          const SizedBox(height: 14),
          // Дії
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.auto_awesome, size: 16),
                label: const Text('Запитати ШІ'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accentGreen,
                  side: const BorderSide(color: AppColors.accentGreen),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => context.push(AppRoutes.aiChat),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Завершити крок'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  context
                      .read<MarchEducationalBloc>()
                      .add(const MarchStepCompleteRequested());
                },
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class _TimerBlock extends StatelessWidget {
  const _TimerBlock({
    required this.elapsed,
    required this.recommended,
    required this.ratio,
    required this.isOver,
  });
  final int elapsed;
  final int recommended;
  final double ratio;
  final bool isOver;

  @override
  Widget build(BuildContext context) {
    final barColor =
        isOver ? AppColors.errorRed : AppColors.accentGreen;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _fmt(elapsed),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFeatures: const [FontFeature.tabularFigures()],
                color: isOver ? AppColors.errorRed : AppColors.textPrimary,
              ),
            ),
            Text(
              'рек. ${_fmt(recommended)}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: ratio.clamp(0.0, 1.0),
            backgroundColor: AppColors.borderColor,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
            minHeight: 6,
          ),
        ),
        if (isOver) ...[
          const SizedBox(height: 4),
          Text(
            'Перевищили рекомендований час на ${_fmt(elapsed - recommended)}',
            style: const TextStyle(fontSize: 11, color: AppColors.errorRed),
          ),
        ],
      ],
    );
  }

  static String _fmt(int s) {
    final m = s ~/ 60;
    final r = s % 60;
    return '$m:${r.toString().padLeft(2, '0')}';
  }
}

class _CheatSheet extends StatelessWidget {
  const _CheatSheet({required this.item, required this.expanded});
  final MarchItem item;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            onTap: () => context
                .read<MarchEducationalBloc>()
                .add(const MarchHintToggled()),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(children: [
                const Icon(Icons.lightbulb_outline,
                    color: AppColors.warningOrange, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Шпаргалка',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  expanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.textSecondary,
                ),
              ]),
            ),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Text(
                _cheatTextFor(item),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _cheatTextFor(MarchItem item) {
    switch (item.step.code) {
      case 'M':
        return '• Турнікет CAT на 2–3 см вище рани, не на суглоб.\n'
            '• Затягуй до зупинки кровотечі та зникнення дистального пульсу.\n'
            '• Запиши час накладання маркером на турнікеті.\n'
            '• Якщо одного недостатньо — другий вище першого.';
      case 'A':
        return '• Підозра на травму шиї → jaw thrust, без розгинання голови.\n'
            '• Sniffing position для дорослих без травми.\n'
            '• NPA (назофарингеальний повітровід) — для несвідомих з прохідним носом.\n'
            '• Уникай OPA у пацієнта зі збереженим блювотним рефлексом.';
      case 'R':
        return '• Look–Listen–Feel: грудна клітка, дихальні шуми, сатурація.\n'
            '• Перевір симетричність екскурсії грудної клітки.\n'
            '• Шукай ознаки напруженого пневмотораксу → голкова декомпресія.\n'
            '• Проникаюче поранення грудної клітки → chest seal.';
      case 'C':
        return '• Перевір пульс, capillary refill, артеріальний тиск.\n'
            '• Шукай приховані кровотечі: живіт, таз, стегно.\n'
            '• Ознаки шоку → інфузія за протоколом (TXA при необхідності).\n'
            '• Тазовий пояс — при підозрі на перелом тазу.';
      case 'H':
        return '• Ізолюй від холодної поверхні.\n'
            '• Зніми мокрий одяг, термоковдра/Hypothermia Prevention Kit.\n'
            '• Перевір TBI: GCS, зіниці, ознаки lateralizing deficit.\n'
            '• НЕ нагрівай швидко алкоголем чи розтиранням.';
    }
    return 'Слідуй протоколу TCCC.';
  }
}
