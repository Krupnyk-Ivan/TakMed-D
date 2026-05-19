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
                  SliverToBoxAdapter(child: _buildMarchTrainingCard(context)),
                  SliverToBoxAdapter(child: _buildAiChatCard(context)),
                  SliverToBoxAdapter(child: _buildAllCoursesLink(context, state)),
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

  Widget _buildMarchTrainingCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: GestureDetector(
        onTap: () => context.push(AppRoutes.marchEducational),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingXLarge),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
            border: Border.all(
              color: AppColors.warningOrange.withValues(alpha: 0.4),
            ),
          ),
          child: Row(children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.warningOrange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.school_outlined,
                    color: AppColors.warningOrange, size: 26),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Тренування',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.warningOrange,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'MARCH-симулятор з мікро-квізами',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
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

  Widget _buildAiChatCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: GestureDetector(
        onTap: () => context.push(AppRoutes.aiChat),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingXLarge),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
            border: Border.all(
              color: AppColors.accentGreen.withValues(alpha: 0.4),
            ),
          ),
          child: Row(children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.accentGreen.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.auto_awesome,
                    color: AppColors.accentGreen, size: 26),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ШІ-помічник',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.accentGreen,
                            fontWeight: FontWeight.w600,
                          )),
                  const SizedBox(height: 4),
                  Text('Питай про MARCH, TCCC, першу допомогу',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          )),
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

  Widget _buildAllCoursesLink(BuildContext context, HomeState state) {
    final totalCourses = state.courses.length;
    final completed = state.courses.where((c) => c.isCompleted).length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: GestureDetector(
        onTap: () => context.go(AppRoutes.learning),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingXLarge),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Row(children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.accentGreen.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.library_books_outlined,
                    color: AppColors.accentGreen, size: 26),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Каталог курсів',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    totalCourses == 0
                        ? 'Курси для твого треку ще додають'
                        : 'Пройдено $completed з $totalCourses',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
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
}
