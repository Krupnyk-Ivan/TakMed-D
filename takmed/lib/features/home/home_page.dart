import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../auth/presentation/bloc/auth_bloc.dart';
import '../auth/presentation/bloc/auth_event.dart';
import '../auth/presentation/bloc/auth_state.dart';
import '../gamification/presentation/widgets/xp_progress_card.dart';
import '../learning/presentation/bloc/home_bloc.dart';

/// Головний екран TacMed.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.unauthenticated) {
            context.go(AppRoutes.login);
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.loading ||
                state.status == HomeStatus.initial) {
              return const Center(
                  child: CircularProgressIndicator(color: AppColors.primaryRed));
            }
            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildHeader(context, state)),
                  // Гейміфікація Dashboard
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                      child: XpProgressCard(
                        totalXp: state.totalXp,
                        currentLevel: state.currentLevel,
                        streak: state.streak,
                        bestStreak: state.bestStreak,
                      ),
                    ),
                  ),
                  if (state.nextLesson != null)
                    SliverToBoxAdapter(child: _buildNextLessonCard(context, state)),
                  SliverToBoxAdapter(child: _buildMarchChecklistCard(context)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                      child: Text('Модулі',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList.separated(
                      itemCount: state.courses.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          _buildCourseCard(context, state, index),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HomeState state) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${AppStrings.welcome} 👋',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  state.track == 'military'
                      ? '🪖 Трек: Боєць/Медик'
                      : '🏥 Трек: Цивільний',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          // Кнопка переходу на сторінку досягнень
          IconButton(
            icon: const Icon(Icons.emoji_events_outlined,
                color: AppColors.warningOrange, size: 26),
            onPressed: () => context.push(AppRoutes.gamification),
            tooltip: 'Досягнення',
          ),
          // Logout
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textSecondary),
            onPressed: () =>
                context.read<AuthBloc>().add(const AuthLogoutSubmitted()),
          ),
        ],
      ),
    );
  }

  Widget _buildNextLessonCard(BuildContext context, HomeState state) {
    final lesson = state.nextLesson!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => context.go('/lesson/${lesson.id}'),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingXLarge),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF1A2332), Color(0xFF0F1923)]),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
            border: Border.all(
                color: AppColors.primaryRed.withValues(alpha: 0.3)),
          ),
          child: Row(children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                  child: Text(lesson.typeEmoji,
                      style: const TextStyle(fontSize: 24))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Продовжити навчання',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(lesson.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  Text(lesson.formattedDuration,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.play_circle_fill,
                color: AppColors.primaryRed, size: 36),
          ]),
        ),
      ),
    );
  }

  Widget _buildMarchChecklistCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: GestureDetector(
        onTap: () => context.push(AppRoutes.marchChecklist),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingXLarge),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
            border: Border.all(color: AppColors.primaryRed.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryRed.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                  child: Icon(Icons.medical_services, color: AppColors.primaryRed, size: 28)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Практика',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('Протокол MARCH',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: AppColors.textSecondary, size: 16),
          ]),
        ),
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, HomeState state, int index) {
    final course = state.courses[index];
    return GestureDetector(
      onTap: () => context.go('/course/${course.id}'),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingXLarge),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
              child: Text(course.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
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
          Text(course.description,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
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
            Text('${course.completedLessons}/${course.totalLessons}',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.textSecondary)),
          ]),
        ]),
      ),
    );
  }
}
