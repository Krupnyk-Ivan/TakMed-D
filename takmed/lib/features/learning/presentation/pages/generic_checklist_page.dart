import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/di/injection_container.dart';
import '../../../gamification/presentation/bloc/gamification_bloc.dart';
import '../../../gamification/presentation/bloc/gamification_event.dart';
import '../../domain/entities/lesson_content/checklist_content.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../domain/repositories/learning_repository.dart';

/// Простий чеклист для не-MARCH уроків (CAT, Chest Seal, СЛР тощо).
/// Кроки виконуються послідовно — кожен наступний розблоковується
/// після відмітки попереднього.
class GenericChecklistPage extends StatefulWidget {
  final LessonEntity lesson;
  final ChecklistContent content;

  const GenericChecklistPage({
    super.key,
    required this.lesson,
    required this.content,
  });

  @override
  State<GenericChecklistPage> createState() => _GenericChecklistPageState();
}

class _GenericChecklistPageState extends State<GenericChecklistPage> {
  late List<bool> _checked;

  @override
  void initState() {
    super.initState();
    _checked = List.filled(widget.content.steps.length, false);
  }

  bool get _allDone => _checked.every((c) => c);

  int get _nextUnlocked {
    final idx = _checked.indexOf(false);
    return idx == -1 ? _checked.length : idx;
  }

  void _toggle(int index) {
    // Дозволяємо відмічати тільки поточний або попередні кроки
    if (index > _nextUnlocked) return;
    setState(() => _checked[index] = !_checked[index]);
  }

  Future<void> _finish() async {
    final repo = getIt<LearningRepository>();
    await repo.completeLesson(widget.lesson.id, 100);

    final courseRemoteId =
        widget.lesson.remoteId.split('-').take(2).join('-');
    getIt<GamificationBloc>().add(GamificationLessonCompleted(
      lessonId: widget.lesson.id,
      courseRemoteId: courseRemoteId,
      isOffline: false,
      isAllCourseComplete: false,
      totalCompletedLessons: 0,
    ));

    if (!mounted) return;
    context.go('/course/${widget.lesson.courseId}');
  }

  @override
  Widget build(BuildContext context) {
    final steps = widget.content.steps;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => context.go('/course/${widget.lesson.courseId}'),
        ),
        title: Text(widget.lesson.title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        // Лічильник виконаних кроків
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_checked.where((c) => c).length}/${steps.length}',
                style: TextStyle(
                  color: _allDone
                      ? AppColors.accentGreen
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Прогрес-бар
          LinearProgressIndicator(
            value: steps.isEmpty
                ? 0
                : _checked.where((c) => c).length / steps.length,
            backgroundColor: AppColors.borderColor,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.accentGreen),
            minHeight: 3,
          ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              itemCount: steps.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppDimensions.paddingSmall),
              itemBuilder: (context, index) {
                final step = steps[index];
                final isChecked = _checked[index];
                final isLocked = index > _nextUnlocked;

                return _StepTile(
                  index: index,
                  title: step.title,
                  description: step.description,
                  isChecked: isChecked,
                  isLocked: isLocked,
                  onTap: () => _toggle(index),
                );
              },
            ),
          ),

          // Кнопка завершення
          if (_allDone)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                child: SizedBox(
                  width: double.infinity,
                  height: AppDimensions.buttonHeightXLarge,
                  child: ElevatedButton(
                    onPressed: _finish,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentGreen,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusLarge)),
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
            ),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({
    required this.index,
    required this.title,
    required this.description,
    required this.isChecked,
    required this.isLocked,
    required this.onTap,
  });

  final int index;
  final String title;
  final String description;
  final bool isChecked;
  final bool isLocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: isChecked
            ? AppColors.accentGreen.withValues(alpha: 0.08)
            : isLocked
                ? AppColors.cardColor.withValues(alpha: 0.5)
                : AppColors.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(
          color: isChecked
              ? AppColors.accentGreen
              : isLocked
                  ? AppColors.borderColor.withValues(alpha: 0.4)
                  : AppColors.borderColor,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMedium,
            vertical: AppDimensions.paddingSmall),
        leading: GestureDetector(
          onTap: isLocked ? null : onTap,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: isChecked
                ? const Icon(Icons.check_circle,
                    color: AppColors.accentGreen, size: 28, key: ValueKey('checked'))
                : isLocked
                    ? const Icon(Icons.lock_outline,
                        color: AppColors.textSecondary, size: 24, key: ValueKey('locked'))
                    : Icon(Icons.radio_button_unchecked,
                        color: AppColors.primaryRed, size: 28, key: ValueKey('$index-unchecked')),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isLocked ? AppColors.textSecondary : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: AppDimensions.fontSizeBase,
            decoration: isChecked ? TextDecoration.lineThrough : null,
            decorationColor: AppColors.textSecondary,
          ),
        ),
        subtitle: description.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  description,
                  style: TextStyle(
                    color: isLocked
                        ? AppColors.textSecondary.withValues(alpha: 0.5)
                        : AppColors.textSecondary,
                    fontSize: AppDimensions.fontSizeMedium,
                    height: AppDimensions.lineHeightMedium,
                  ),
                ),
              )
            : null,
        onTap: isLocked ? null : onTap,
      ),
    );
  }
}
