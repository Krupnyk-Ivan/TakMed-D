import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import 'presentation/bloc/home_bloc.dart';
import 'presentation/widgets/course_list_tile.dart';

/// Екран навчання — повний каталог курсів за треком користувача.
///
/// Перевикористовує `HomeBloc.courses` (стрім вже налаштований при старті).
class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceColor,
        title: const Text(AppStrings.learning),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.loading ||
              state.status == HomeStatus.initial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryRed),
            );
          }

          if (state.courses.isEmpty) {
            return _buildEmpty(context);
          }

          return SafeArea(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              itemCount: state.courses.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppDimensions.spacerSmall),
              itemBuilder: (context, index) =>
                  CourseListTile(course: state.courses[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.padding3xLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.library_books_outlined,
                  size: 64, color: AppColors.textSecondary),
              const SizedBox(height: AppDimensions.spacerMedium),
              const Text(
                'Курси для твого треку ще додають',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppDimensions.fontSizeLarge,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'Перевір трек у профілі (Військовий / Цивільний)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.7),
                  fontSize: AppDimensions.fontSizeMedium,
                ),
              ),
            ],
          ),
        ),
      );
}
