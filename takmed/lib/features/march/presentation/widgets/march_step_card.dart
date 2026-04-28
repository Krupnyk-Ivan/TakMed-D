import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/models/march_step.dart';
import '../../domain/models/march_step_state.dart';

class MarchStepCard extends StatefulWidget {
  final MarchStep step;
  final MarchStepState stepState;
  final bool canActivate;
  final bool canComplete;
  final bool canRollback;

  /// Опис кроку з навчального контенту (seed data). Необов'язково.
  final String? description;

  final VoidCallback onStart;
  final VoidCallback onComplete;
  final VoidCallback onFail;
  final VoidCallback onSkip;
  final VoidCallback onRollback;

  const MarchStepCard({
    super.key,
    required this.step,
    required this.stepState,
    required this.canActivate,
    required this.canComplete,
    required this.canRollback,
    required this.onStart,
    required this.onComplete,
    required this.onFail,
    required this.onSkip,
    required this.onRollback,
    this.description,
  });

  @override
  State<MarchStepCard> createState() => _MarchStepCardState();
}

class _MarchStepCardState extends State<MarchStepCard> {
  Timer? _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _updateTimer();
  }

  @override
  void didUpdateWidget(covariant MarchStepCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.stepState != oldWidget.stepState) {
      _updateTimer();
    }
  }

  void _updateTimer() {
    _timer?.cancel();
    if (widget.stepState is StepInProgress) {
      final state = widget.stepState as StepInProgress;
      _remainingSeconds = state.remainingSeconds;
      
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() {
          _remainingSeconds = state.remainingSeconds;
          if (_remainingSeconds <= 0) {
            timer.cancel();
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Color _getCardColor() {
    final state = widget.stepState;
    if (state is StepCompleted) return AppColors.successGreen.withValues(alpha: 0.1);
    if (state is StepFailed) return AppColors.errorRed.withValues(alpha: 0.1);
    if (state is StepSkipped) return AppColors.warningOrange.withValues(alpha: 0.1);
    if (state is StepInProgress) return AppColors.infoBue.withValues(alpha: 0.1);
    return AppColors.cardColor;
  }

  Color _getBorderColor() {
    final state = widget.stepState;
    if (state is StepCompleted) return AppColors.successGreen;
    if (state is StepFailed) return AppColors.errorRed;
    if (state is StepSkipped) return AppColors.warningOrange;
    if (state is StepInProgress) return AppColors.infoBue;
    return AppColors.borderColor;
  }

  Widget _buildTimerBadge() {
    final state = widget.stepState;
    if (state is StepInProgress) {
      final isUrgent = _remainingSeconds <= 10;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isUrgent ? AppColors.errorRed : AppColors.infoBue,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          '$_remainingSeconds сек',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (state is StepCompleted) {
      return Text(
        '${state.elapsedSeconds} сек',
        style: const TextStyle(color: AppColors.successGreen, fontWeight: FontWeight.bold),
      );
    } else if (state is StepPending) {
      return Text(
        '${state.maxTimeSeconds} сек',
        style: const TextStyle(color: AppColors.textSecondary),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.stepState;
    
    return Card(
      color: _getCardColor(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        side: BorderSide(color: _getBorderColor(), width: state is StepInProgress ? 2 : 1),
      ),
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getBorderColor().withValues(alpha: 0.2),
                  foregroundColor: _getBorderColor(),
                  child: Text(
                    widget.step.code,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingMedium),
                Expanded(
                  child: Text(
                    widget.step.label,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                _buildTimerBadge(),
              ],
            ),
            // Опис із навчального контенту (показуємо коли крок активний або завершений)
            if (widget.description != null && state is! StepPending) ...[
              const SizedBox(height: AppDimensions.paddingSmall),
              Text(
                widget.description!,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppDimensions.fontSizeMedium,
                  height: AppDimensions.lineHeightMedium,
                ),
              ),
            ],
            if (state is StepCompleted && state.notes != null) ...[
              const SizedBox(height: AppDimensions.paddingSmall),
              Text(
                '📝 ${state.notes}',
                style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppDimensions.fontSizeSmall),
              ),
            ],
            if (state is StepFailed) ...[
              const SizedBox(height: AppDimensions.paddingSmall),
              Text(
                'Причина: ${state.reason}',
                style: const TextStyle(color: AppColors.errorRed),
              ),
            ],
            if (state is StepSkipped) ...[
              const SizedBox(height: AppDimensions.paddingSmall),
              Text(
                'Пропущено: ${state.reason}',
                style: const TextStyle(color: AppColors.warningOrange),
              ),
            ],
            const SizedBox(height: AppDimensions.paddingMedium),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final state = widget.stepState;
    
    if (state is StepPending) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: widget.canActivate ? widget.onSkip : null,
            child: const Text('Пропустити', style: TextStyle(color: AppColors.textSecondary)),
          ),
          const SizedBox(width: AppDimensions.paddingSmall),
          ElevatedButton(
            onPressed: widget.canActivate ? widget.onStart : null,
            child: const Text('Почати'),
          ),
        ],
      );
    } else if (state is StepInProgress) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: widget.canComplete ? widget.onFail : null,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.errorRed,
              side: const BorderSide(color: AppColors.errorRed),
            ),
            child: const Text('Провал'),
          ),
          const SizedBox(width: AppDimensions.paddingSmall),
          ElevatedButton(
            onPressed: widget.canComplete ? widget.onComplete : null,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.successGreen),
            child: const Text('Завершити'),
          ),
        ],
      );
    } else {
      // Completed, Failed, or Skipped
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (widget.canRollback)
            TextButton.icon(
              onPressed: widget.onRollback,
              icon: const Icon(Icons.undo, size: 18),
              label: const Text('Відкотити'),
              style: TextButton.styleFrom(foregroundColor: AppColors.warningOrange),
            ),
        ],
      );
    }
  }
}
