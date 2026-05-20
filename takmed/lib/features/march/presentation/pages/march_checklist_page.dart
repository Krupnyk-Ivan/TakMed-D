import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/di/injection_container.dart';
import '../../../gamification/presentation/bloc/gamification_bloc.dart';
import '../../../gamification/presentation/bloc/gamification_event.dart';
import '../../../learning/domain/entities/lesson_content/checklist_content.dart';
import '../../../learning/domain/entities/lesson_entity.dart';
import '../../../learning/domain/repositories/learning_repository.dart';
import '../../domain/models/march_step.dart';
import '../bloc/march_bloc.dart';
import '../bloc/march_checklist_state.dart';
import '../bloc/march_event.dart';
import '../widgets/march_step_card.dart';

/// Інтерактивний чеклист протоколу MARCH.
///
/// Два режими:
/// • [lesson] == null → standalone (з головного екрану, без збереження прогресу)
/// • [lesson] != null → урок (з описами кроків, збереженням прогресу, кнопкою завершення)
class MarchChecklistPage extends StatefulWidget {
  /// Урок-джерело. Якщо null — standalone режим.
  final LessonEntity? lesson;

  /// Контент із seed data (описи кроків). Необов'язково.
  final ChecklistContent? content;

  const MarchChecklistPage({super.key, this.lesson, this.content});

  @override
  State<MarchChecklistPage> createState() => _MarchChecklistPageState();
}

class _MarchChecklistPageState extends State<MarchChecklistPage> {
  late List<MarchStep> _displayOrder;

  @override
  void initState() {
    super.initState();
    // Створюємо випадковий порядок відображення кроків
    _displayOrder = List<MarchStep>.from(MarchStep.values)..shuffle();
  }

  void _resetOrder() {
    setState(() {
      _displayOrder.shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MarchBloc()..add(const MarchStarted()),
      child: _MarchChecklistView(
        lesson: widget.lesson,
        content: widget.content,
        displayOrder: _displayOrder,
        onResetOrder: _resetOrder,
      ),
    );
  }
}

// ─── View ─────────────────────────────────────────────────────────────────────

class _MarchChecklistView extends StatelessWidget {
  const _MarchChecklistView({
    this.lesson,
    this.content,
    required this.displayOrder,
    required this.onResetOrder,
  });

  final LessonEntity? lesson;
  final ChecklistContent? content;
  final List<MarchStep> displayOrder;
  final VoidCallback onResetOrder;

  void _showSkipDialog(BuildContext context, MarchStep step) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardColor,
        title: const Text('Пропустити крок'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Вкажіть причину...',
            hintStyle: TextStyle(color: AppColors.textSecondary),
          ),
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Скасувати'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<MarchBloc>().add(MarchStepSkipRequested(
                    step: step,
                    reason: controller.text.isNotEmpty
                        ? controller.text
                        : 'Клінічне рішення',
                  ));
              Navigator.pop(ctx);
            },
            child: const Text('Підтвердити'),
          ),
        ],
      ),
    );
  }

  void _showFailDialog(BuildContext context, MarchStep step) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardColor,
        title: const Text('Невдача на кроці'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Вкажіть причину...',
            hintStyle: TextStyle(color: AppColors.textSecondary),
          ),
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Скасувати'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed),
            onPressed: () {
              context.read<MarchBloc>().add(MarchStepFailureReported(
                    step: step,
                    reason: controller.text.isNotEmpty
                        ? controller.text
                        : 'Не вдалося виконати',
                  ));
              Navigator.pop(ctx);
            },
            child: const Text('Підтвердити'),
          ),
        ],
      ),
    );
  }

  /// Завершити урок і перейти назад до курсу.
  Future<void> _finishLesson(BuildContext context, int successRate) async {
    if (lesson == null) return;
    final repo = getIt<LearningRepository>();
    await repo.completeLesson(lesson!.id, successRate);

    // Нараховуємо гейміфікацію
    final courseRemoteId =
        lesson!.remoteId.split('-').take(2).join('-'); // 'mil-1' тощо
    getIt<GamificationBloc>().add(GamificationLessonCompleted(
      lessonId: lesson!.id,
      courseRemoteId: courseRemoteId,
      isOffline: false,
      isAllCourseComplete: false,
      totalCompletedLessons: 0,
    ));

    if (!context.mounted) return;
    context.go('/course/${lesson!.courseId}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () {
            if (lesson != null) {
              context.go('/course/${lesson!.courseId}');
            } else if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: Text(
          lesson?.title ?? 'Протокол MARCH',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: [
          Builder(builder: (ctx) => IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textSecondary),
            tooltip: 'Скинути',
            onPressed: () {
              onResetOrder();
              ctx.read<MarchBloc>()
                ..add(const MarchReset())
                ..add(const MarchStarted());
            },
          )),
        ],
      ),
      body: BlocConsumer<MarchBloc, MarchChecklistState>(
        listenWhen: (previous, current) =>
            current.validationError != null &&
            previous.validationError != current.validationError,
        listener: (context, state) {
          if (state.validationError != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.validationError!),
              backgroundColor: AppColors.errorRed,
              behavior: SnackBarBehavior.floating,
            ));
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              _buildStatusHeader(state),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  itemCount: displayOrder.length,
                  itemBuilder: (context, index) {
                    final step = displayOrder[index];
                    final stepState = state.steps[step]!;
                    
                    // Знаходимо оригінальний індекс кроку для отримання правильного опису
                    final originalIndex = MarchStep.values.indexOf(step);

                    // Беремо опис із контенту якщо є (за ОРИГІНАЛЬНИМ індексом кроку)
                    final description = (content != null &&
                            originalIndex < content!.steps.length)
                        ? content!.steps[originalIndex].description
                        : null;

                    return MarchStepCard(
                      step: step,
                      stepState: stepState,
                      description: description,
                      canActivate: state.canActivate(step),
                      canComplete: state.canComplete(step),
                      canRollback: state.canRollback(step),
                      onStart: () => context
                          .read<MarchBloc>()
                          .add(MarchStepStartRequested(step)),
                      onComplete: () => context
                          .read<MarchBloc>()
                          .add(MarchStepCompletionRequested(step: step)),
                      onFail: () => _showFailDialog(context, step),
                      onSkip: () => _showSkipDialog(context, step),
                      onRollback: () => context
                          .read<MarchBloc>()
                          .add(MarchRollbackRequested(step)),
                    );
                  },
                ),
              ),
              // Кнопка завершення уроку (тільки в режимі уроку + коли все виконано)
              if (lesson != null &&
                  state.overallStatus == MarchOverallStatus.completed)
                _buildFinishButton(context, state.successRate),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusHeader(MarchChecklistState state) {
    final (color, text, icon) = switch (state.overallStatus) {
      MarchOverallStatus.idle => (
          AppColors.textSecondary,
          'Очікування',
          Icons.hourglass_empty,
        ),
      MarchOverallStatus.inProgress => (
          AppColors.infoBue,
          'Виконується',
          Icons.local_hospital,
        ),
      MarchOverallStatus.completed => (
          AppColors.successGreen,
          'Завершено ✓',
          Icons.check_circle,
        ),
      MarchOverallStatus.partiallyFailed => (
          AppColors.warningOrange,
          'Частково неуспішно',
          Icons.warning,
        ),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.paddingSmall,
          horizontal: AppDimensions.paddingMedium),
      color: color.withValues(alpha: 0.1),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: color, size: AppDimensions.iconSmall),
        const SizedBox(width: AppDimensions.paddingSmall),
        Text(
          text.toUpperCase(),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: AppDimensions.fontSizeSmall,
            letterSpacing: 1.2,
          ),
        ),
      ]),
    );
  }

  Widget _buildFinishButton(BuildContext context, int successRate) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: SizedBox(
          width: double.infinity,
          height: AppDimensions.buttonHeightXLarge,
          child: ElevatedButton(
            onPressed: () => _finishLesson(context, successRate),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.successGreen,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusLarge)),
            ),
            child: const Text(
              '✅ Завершити урок',
              style: TextStyle(
                  fontSize: AppDimensions.fontSizeBase,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
