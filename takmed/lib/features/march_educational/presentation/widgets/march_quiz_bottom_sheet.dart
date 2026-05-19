import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../bloc/march_educational_bloc.dart';
import '../bloc/march_educational_event.dart';
import '../bloc/march_educational_state.dart';

/// Бошттом-шіт з мікро-квізом, який перериває потік після "Завершити крок".
class MarchQuizBottomSheet extends StatelessWidget {
  const MarchQuizBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MarchEducationalBloc, MarchEducationalState>(
      // Закриваємо bottom-sheet коли BLoC заявив, що quiz завершено
      // (activeQuiz=null) або сесія перейшла далі.
      listenWhen: (a, b) =>
          a.activeQuiz != null && b.activeQuiz == null,
      listener: (context, state) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      },
      buildWhen: (a, b) =>
          a.activeQuiz != b.activeQuiz ||
          a.status != b.status ||
          a.selectedQuizIndex != b.selectedQuizIndex,
      builder: (context, state) {
        final quiz = state.activeQuiz;
        if (quiz == null) return const SizedBox.shrink();

        final showFailed = state.status == MarchEducationalStatus.quizFailed;

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          decoration: const BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.borderColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        quiz.step.code,
                        style: const TextStyle(
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Перевірка знань',
                        style: TextStyle(
                          fontSize: AppDimensions.fontSizeLarge,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  quiz.question,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontSizeBase,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                ...List.generate(quiz.options.length, (i) {
                  final isSelected = state.selectedQuizIndex == i;
                  final isCorrect = i == quiz.correctIndex;
                  Color borderColor = AppColors.borderColor;
                  Color bgColor = AppColors.cardColor;

                  if (showFailed) {
                    if (isSelected && !isCorrect) {
                      borderColor = AppColors.errorRed;
                      bgColor = AppColors.errorRed.withValues(alpha: 0.15);
                    } else if (isCorrect) {
                      borderColor = AppColors.accentGreen;
                      bgColor = AppColors.accentGreen.withValues(alpha: 0.15);
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: showFailed
                          ? null
                          : () => context
                              .read<MarchEducationalBloc>()
                              .add(MarchQuizAnswered(i)),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMedium),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusMedium),
                          border: Border.all(color: borderColor, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                quiz.options[i],
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: AppDimensions.fontSizeMedium,
                                ),
                              ),
                            ),
                            if (showFailed && isCorrect)
                              const Icon(Icons.check_circle,
                                  color: AppColors.accentGreen, size: 18),
                            if (showFailed && isSelected && !isCorrect)
                              const Icon(Icons.cancel,
                                  color: AppColors.errorRed, size: 18),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                if (showFailed) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warningOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMedium),
                      border: Border.all(
                        color: AppColors.warningOrange.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline,
                            color: AppColors.warningOrange, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            quiz.explanation,
                            style: const TextStyle(
                              color: AppColors.warningOrange,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Зрозуміло, далі'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryRed,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () => context
                              .read<MarchEducationalBloc>()
                              .add(const MarchQuizDismissAfterFailure()),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
