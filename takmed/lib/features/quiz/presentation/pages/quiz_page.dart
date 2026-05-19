import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/quiz_bloc.dart';
import '../bloc/quiz_event.dart';
import '../bloc/quiz_state.dart';
import '../widgets/quiz_progress_bar.dart';
import '../widgets/question_card.dart';
import '../widgets/answer_button.dart';
import '../widgets/sequence_drag_widget.dart';
import '../widgets/explanation_panel.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/quiz_question.dart';

class QuizPage extends StatelessWidget {
  final int? lessonId;
  final int? courseId;

  const QuizPage({super.key, this.lessonId, this.courseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              getIt<QuizBloc>()
                ..add(StartQuiz(lessonId?.toString() ?? 'default_topic')),
      child: _QuizView(lessonId: lessonId, courseId: courseId),
    );
  }
}

class _QuizView extends StatelessWidget {
  final int? lessonId;
  final int? courseId;
  const _QuizView({this.lessonId, this.courseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вікторина'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _confirmExit(context),
        ),
      ),
      body: BlocConsumer<QuizBloc, QuizState>(
        listener: (context, state) {
          if (state is QuizCompleted) {
            context.go(
              '/quiz/result',
              extra: {
                'state': state,
                'lessonId': lessonId,
                'courseId': courseId,
              },
            );
          } else if (state is QuizError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is QuizAnswered) {
            // Show bottom sheet with explanation
            showModalBottomSheet(
              context: context,
              isDismissible: false,
              enableDrag: false,
              backgroundColor: Colors.transparent,
              builder:
                  (ctx) => ExplanationPanel(
                    isCorrect: state.isCorrect,
                    explanation:
                        state.progressState.currentQuestion.explanation,
                    onNext: () {
                      Navigator.of(ctx).pop();
                      context.read<QuizBloc>().add(const NextQuestion());
                    },
                  ),
            );
          }
        },
        builder: (context, state) {
          if (state is QuizLoading || state is QuizInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is QuizInProgress) {
            return _buildQuizBody(context, state, null);
          }

          if (state is QuizAnswered) {
            return _buildQuizBody(context, state.progressState, state);
          }

          return const Center(child: Text('Зачекайте...'));
        },
      ),
    );
  }

  Widget _buildQuizBody(
    BuildContext context,
    QuizInProgress state,
    QuizAnswered? answeredState,
  ) {
    final question = state.currentQuestion;
    final isAnswered = answeredState != null;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          QuizProgressBar(
            total: state.questions.length,
            current: state.currentIndex,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  QuestionCard(question: question),
                  const SizedBox(height: 24),

                  // Render options based on type
                  question.map(
                    multipleChoice:
                        (q) => Column(
                          children:
                              q.options.map((opt) {
                                bool isSelected =
                                    answeredState?.selectedAnswerId == opt.id;
                                bool? isCorrect;
                                if (isAnswered) {
                                  if (isSelected) { isCorrect = answeredState.isCorrect; }
                                  if (opt.id == q.correctId) { isCorrect = true; }
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: AnswerButton(
                                    text: opt.text,
                                    isSelected: isSelected,
                                    isCorrect: isCorrect,
                                    disabled: isAnswered,
                                    onTap: () {
                                      context.read<QuizBloc>().add(
                                        AnswerSelected(opt.id),
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                        ),
                    multiSelect:
                        (q) => _MultiSelectWidget(
                          question: q,
                          state: state,
                          answeredState: answeredState,
                        ),
                    trueFalse:
                        (q) => Column(
                          children: [
                            AnswerButton(
                              text: 'Правда',
                              isSelected:
                                  answeredState?.selectedAnswerId == 'true',
                              isCorrect:
                                  isAnswered
                                      ? (answeredState.selectedAnswerId ==
                                              'true'
                                          ? answeredState.isCorrect
                                          : q.correctAnswer == true)
                                      : null,
                              disabled: isAnswered,
                              onTap:
                                  () => context.read<QuizBloc>().add(
                                    const AnswerSelected('true'),
                                  ),
                            ),
                            const SizedBox(height: 12),
                            AnswerButton(
                              text: 'Міф',
                              isSelected:
                                  answeredState?.selectedAnswerId == 'false',
                              isCorrect:
                                  isAnswered
                                      ? (answeredState.selectedAnswerId ==
                                              'false'
                                          ? answeredState.isCorrect
                                          : q.correctAnswer == false)
                                      : null,
                              disabled: isAnswered,
                              onTap:
                                  () => context.read<QuizBloc>().add(
                                    const AnswerSelected('false'),
                                  ),
                            ),
                          ],
                        ),
                    sequence:
                        (q) => Column(
                          children: [
                            SequenceDragWidget(
                              items: q.items,
                              disabled: isAnswered,
                              isCorrect: answeredState?.isCorrect,
                              onReorder: (newOrder) {
                                context.read<QuizBloc>().add(
                                  SequenceReordered(newOrder),
                                );
                              },
                            ),
                            if (!isAnswered) ...[
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    // Provide current sequence order. SequenceDragWidget calls onReorder
                                    // but we need the initial or current state.
                                    // Actually, let's just dispatch AnswerSelected with 'submit_sequence'.
                                    // And let QuizBloc grab the last known sequence.
                                    context.read<QuizBloc>().add(
                                      const AnswerSelected('submit_sequence'),
                                    );
                                  },
                                  child: const Text(
                                    'Перевірити',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                    imageMatch:
                        (q) => Column(
                          children:
                              q.options.map((opt) {
                                bool isSelected =
                                    answeredState?.selectedAnswerId == opt.id;
                                bool? isCorrect;
                                if (isAnswered) {
                                  if (isSelected) { isCorrect = answeredState.isCorrect; }
                                  if (opt.id == q.correctId) { isCorrect = true; }
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: AnswerButton(
                                    text: opt.text,
                                    isSelected: isSelected,
                                    isCorrect: isCorrect,
                                    disabled: isAnswered,
                                    onTap: () {
                                      context.read<QuizBloc>().add(
                                        AnswerSelected(opt.id),
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmExit(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Вийти з тесту?'),
        content: const Text('Ваш прогрес буде втрачено.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Скасувати'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // Quiz відкривається як root-маршрут (`context.go('/quiz')`),
              // тож стек може бути порожнім — використовуємо безпечний fallback.
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            },
            child: const Text('Вийти'),
          ),
        ],
      ),
    );
  }
}

class _MultiSelectWidget extends StatelessWidget {
  const _MultiSelectWidget({
    required this.question,
    required this.state,
    required this.answeredState,
  });

  final MultiSelectQuestion question;
  final QuizInProgress state;
  final QuizAnswered? answeredState;

  @override
  Widget build(BuildContext context) {
    final isAnswered = answeredState != null;
    final selectedIds = isAnswered
        ? answeredState!.selectedAnswerIds
        : state.pendingSelectedIds;
    final correctIds = Set<String>.from(question.correctIds);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Оберіть усі правильні відповіді',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppDimensions.fontSizeMedium,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        ...question.options.map((opt) {
          final isSelected = selectedIds.contains(opt.id);
          final isCorrectOption = correctIds.contains(opt.id);

          Color borderColor = AppColors.borderColor;
          Color bgColor = Colors.transparent;
          Color textColor = AppColors.textPrimary;
          Widget? trailingIcon;

          if (isAnswered) {
            if (isCorrectOption) {
              borderColor = AppColors.accentGreen;
              bgColor = AppColors.accentGreen.withValues(alpha: 0.15);
              trailingIcon = const Icon(Icons.check_circle, color: AppColors.accentGreen);
            } else if (isSelected && !isCorrectOption) {
              borderColor = AppColors.errorRed;
              bgColor = AppColors.errorRed.withValues(alpha: 0.15);
              trailingIcon = const Icon(Icons.cancel, color: AppColors.errorRed);
            }
          } else if (isSelected) {
            borderColor = AppColors.primaryRed;
            bgColor = AppColors.primaryRed.withValues(alpha: 0.15);
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: isAnswered
                  ? null
                  : () => context.read<QuizBloc>().add(MultiSelectToggled(opt.id)),
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              child: AnimatedContainer(
                duration: AppDimensions.animationShort,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLarge,
                  vertical: AppDimensions.paddingMedium,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  border: Border.all(color: borderColor, width: 2),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: AppDimensions.animationShort,
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: isSelected && !isAnswered
                            ? AppColors.primaryRed
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isSelected && !isAnswered
                              ? AppColors.primaryRed
                              : AppColors.borderColor,
                          width: 2,
                        ),
                      ),
                      child: isSelected && !isAnswered
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        opt.text,
                        style: TextStyle(
                          fontSize: AppDimensions.fontSizeBase,
                          color: textColor,
                        ),
                      ),
                    ),
                    if (trailingIcon != null) trailingIcon,
                  ],
                ),
              ),
            ),
          );
        }),
        if (!isAnswered) ...[
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: state.pendingSelectedIds.isEmpty
                    ? AppColors.borderColor
                    : AppColors.primaryRed,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                ),
              ),
              onPressed: state.pendingSelectedIds.isEmpty
                  ? null
                  : () => context.read<QuizBloc>().add(const SubmitMultiSelect()),
              child: const Text(
                'Підтвердити відповідь',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
