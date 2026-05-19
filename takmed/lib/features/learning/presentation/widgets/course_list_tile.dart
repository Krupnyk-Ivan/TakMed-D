import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/entities/course_entity.dart';
import '../bloc/home_bloc.dart';

/// Картка курсу: назва, опис, прогрес, кнопка офлайн-завантаження.
/// Виноситься в окремий widget, щоб HomePage і LearningPage показували
/// курси в однаковому стилі.
class CourseListTile extends StatelessWidget {
  const CourseListTile({super.key, required this.course});
  final CourseEntity course;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/course/${course.id}'),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingXLarge),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                child: Text(
                  course.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              if (course.isDownloaded)
                const Icon(Icons.download_done,
                    color: AppColors.accentGreen, size: 20)
              else
                GestureDetector(
                  onTap: () => context
                      .read<HomeBloc>()
                      .add(HomeDownloadCourseRequested(course.id)),
                  child: const Icon(Icons.download_for_offline_outlined,
                      color: AppColors.textSecondary, size: 20),
                ),
            ]),
            const SizedBox(height: 6),
            Text(
              course.description,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: course.progressPercent,
                    backgroundColor: AppColors.borderColor,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      course.isCompleted
                          ? AppColors.accentGreen
                          : AppColors.primaryRed,
                    ),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${course.completedLessons}/${course.totalLessons}',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
