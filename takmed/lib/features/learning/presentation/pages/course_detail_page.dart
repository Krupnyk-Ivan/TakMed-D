import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/course_detail_bloc.dart';

/// Екран деталей курсу.
class CourseDetailPage extends StatelessWidget {
  const CourseDetailPage({super.key, required this.courseId});
  final int courseId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CourseDetailBloc>()..add(CourseDetailStarted(courseId)),
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent, elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary), onPressed: () => context.go('/')),
        ),
        body: BlocBuilder<CourseDetailBloc, CourseDetailState>(
          builder: (context, state) {
            if (state.status == CourseDetailStatus.loading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primaryRed));
            }
            return CustomScrollView(slivers: [
              // Header
              SliverToBoxAdapter(child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(state.course?.title ?? '', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(state.course?.description ?? '', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  // Progress
                  if (state.course != null) ...[
                    Row(children: [
                      Expanded(child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: state.course!.progressPercent, backgroundColor: AppColors.borderColor,
                          valueColor: const AlwaysStoppedAnimation(AppColors.primaryRed), minHeight: 8,
                        ),
                      )),
                      const SizedBox(width: 12),
                      Text('${(state.course!.progressPercent * 100).toInt()}%', style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                    ]),
                    if (state.course!.isDownloaded) Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(children: [
                        Icon(Icons.download_done, color: AppColors.accentGreen, size: 16),
                        const SizedBox(width: 4),
                        Text('Доступний офлайн', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.accentGreen)),
                      ]),
                    ),
                  ],
                ]),
              )),
              // Section
              SliverToBoxAdapter(child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Text('Уроки', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              )),
              // Lesson list
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList.separated(
                  itemCount: state.lessons.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final lesson = state.lessons[index];
                    final unlocked = state.isLessonUnlocked(index);
                    return GestureDetector(
                      onTap: unlocked ? () => context.go('/lesson/${lesson.id}') : null,
                      child: AnimatedOpacity(
                        duration: AppDimensions.animationMedium, opacity: unlocked ? 1.0 : 0.5,
                        child: Container(
                          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                          decoration: BoxDecoration(
                            color: lesson.isCompleted ? AppColors.accentGreen.withValues(alpha: 0.08) : AppColors.cardColor,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                            border: Border.all(color: lesson.isCompleted ? AppColors.accentGreen.withValues(alpha: 0.3) : AppColors.borderColor),
                          ),
                          child: Row(children: [
                            // Number
                            Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(
                                color: lesson.isCompleted ? AppColors.accentGreen.withValues(alpha: 0.2) : AppColors.surfaceColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(child: lesson.isCompleted
                                ? const Icon(Icons.check, color: AppColors.accentGreen, size: 20)
                                : Text('${index + 1}', style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold))),
                            ),
                            const SizedBox(width: 12),
                            // Emoji + title
                            Text(lesson.typeEmoji, style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 8),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(lesson.title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                              Text(lesson.formattedDuration, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                            ])),
                            // Lock/XP
                            if (!unlocked)
                              const Icon(Icons.lock_outline, color: AppColors.textSecondary, size: 20)
                            else
                              Text('+${lesson.xpReward} XP', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.accentGreen, fontWeight: FontWeight.bold)),
                          ]),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ]);
          },
        ),
      ),
    );
  }
}
