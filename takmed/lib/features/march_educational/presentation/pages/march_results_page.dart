import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/entities/march_item.dart';
import '../bloc/march_educational_bloc.dart';
import '../bloc/march_educational_event.dart';
import '../bloc/march_educational_state.dart';

class MarchResultsPage extends StatelessWidget {
  const MarchResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarchEducationalBloc, MarchEducationalState>(
      builder: (context, state) {
        final session = state.session;
        if (session == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final successRate = session.successRatePercent;
        final weakSpots = session.weakSpots;

        return Scaffold(
          backgroundColor: AppColors.darkBackground,
          appBar: AppBar(
            backgroundColor: AppColors.surfaceColor,
            title: const Text('Результат'),
            automaticallyImplyLeading: false,
          ),
          body: ListView(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            children: [
              _SuccessRateBlock(percent: successRate),
              const SizedBox(height: 24),
              _XpBlock(xp: state.totalXpAwarded),
              const SizedBox(height: 24),
              const _SectionLabel('Час по кроках'),
              const SizedBox(height: 8),
              _TimeAnalyticsBars(items: session.items),
              const SizedBox(height: 24),
              if (weakSpots.isNotEmpty) ...[
                const _SectionLabel('Що повторити'),
                const SizedBox(height: 8),
                _WeakSpotsBlock(items: session.items),
                const SizedBox(height: 24),
              ],
              _ActionButtons(),
            ],
          ),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          fontSize: AppDimensions.fontSizeLarge,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      );
}

class _SuccessRateBlock extends StatelessWidget {
  const _SuccessRateBlock({required this.percent});
  final int percent;

  Color get _color {
    if (percent >= 80) return AppColors.accentGreen;
    if (percent >= 50) return AppColors.warningOrange;
    return AppColors.errorRed;
  }

  String get _label {
    if (percent >= 80) return 'Чудово!';
    if (percent >= 50) return 'Можна краще';
    return 'Потрібне повторення';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: _color, width: 2),
      ),
      child: Row(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: percent / 100),
            duration: const Duration(milliseconds: 900),
            builder: (_, value, __) {
              return SizedBox(
                width: 88,
                height: 88,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: 8,
                        backgroundColor: AppColors.borderColor,
                        valueColor: AlwaysStoppedAnimation<Color>(_color),
                      ),
                    ),
                    Text(
                      '${(value * 100).round()}%',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _color,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Успішність',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _label,
                  style: TextStyle(
                    fontSize: AppDimensions.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                    color: _color,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Базується на правильних відповідях у тестах після кожного кроку.',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _XpBlock extends StatelessWidget {
  const _XpBlock({required this.xp});
  final int xp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warningOrange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(
          color: AppColors.warningOrange.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.bolt, color: AppColors.warningOrange, size: 28),
          const SizedBox(width: 8),
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: xp),
            duration: const Duration(milliseconds: 1200),
            builder: (_, v, __) => Text(
              '+$v XP',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.warningOrange,
              ),
            ),
          ),
          const Spacer(),
          const Text(
            'нараховано',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _TimeAnalyticsBars extends StatelessWidget {
  const _TimeAnalyticsBars({required this.items});
  final List<MarchItem> items;

  @override
  Widget build(BuildContext context) {
    // Знаходимо максимум для нормалізації шкали.
    int maxVal = 0;
    for (final it in items) {
      if (it.elapsedSeconds > maxVal) maxVal = it.elapsedSeconds;
      if (it.step.defaultMaxTimeSeconds > maxVal) {
        maxVal = it.step.defaultMaxTimeSeconds;
      }
    }
    if (maxVal == 0) maxVal = 1;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: Column(
        children: items.map((it) {
          final isOver = it.timeExceeded;
          final color = isOver
              ? AppColors.errorRed
              : AppColors.accentGreen;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  SizedBox(
                    width: 22,
                    child: Text(
                      it.step.code,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      it.step.label,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    '${_fmt(it.elapsedSeconds)} / ${_fmt(it.step.defaultMaxTimeSeconds)}',
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ]),
                const SizedBox(height: 4),
                // Дві штриховки: рекомендована (фон) + поточна (фронт)
                Stack(children: [
                  // Recommended
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: it.step.defaultMaxTimeSeconds / maxVal,
                      backgroundColor:
                          AppColors.borderColor.withValues(alpha: 0.4),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.borderColor,
                      ),
                      minHeight: 6,
                    ),
                  ),
                  // Actual
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (it.elapsedSeconds / maxVal).clamp(0.0, 1.0),
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 6,
                    ),
                  ),
                ]),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _fmt(int s) {
    final m = s ~/ 60;
    final r = s % 60;
    return '$m:${r.toString().padLeft(2, '0')}';
  }
}

class _WeakSpotsBlock extends StatelessWidget {
  const _WeakSpotsBlock({required this.items});
  final List<MarchItem> items;

  @override
  Widget build(BuildContext context) {
    final weak = items.where((it) => it.isWeakSpot).toList();
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.errorRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(
          color: AppColors.errorRed.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: weak.map((it) {
          final reasons = <String>[
            if (it.quizAnsweredCorrectly == false) 'помилка у тесті',
            if (it.heavilyOverTime) 'значно перевищено час',
          ].join(' · ');
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(children: [
              const Icon(Icons.priority_high,
                  color: AppColors.errorRed, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${it.step.code} — ${it.step.label}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  reasons,
                  style: const TextStyle(
                    color: AppColors.errorRed,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ]),
          );
        }).toList(),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Пройти ще раз'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {
              context
                  .read<MarchEducationalBloc>()
                  .add(const MarchSessionReset());
              Navigator.of(context).pop();
            },
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              // Закриваємо results + сторінку MarchEducationalPage
              Navigator.of(context).pop();
              if (context.mounted) context.pop();
            },
            child: const Text(
              'На головну',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ),
      ],
    );
  }
}
