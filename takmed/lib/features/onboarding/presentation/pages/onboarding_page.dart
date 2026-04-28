import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_routes.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import '../widgets/onboarding_slide.dart';
import '../widgets/track_selection_widget.dart';

/// Екран онбордингу (3 слайди).
class OnboardingPage extends StatefulWidget {
  /// Створює екран онбордингу.
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state.status == OnboardingStatus.completed) {
          context.go(AppRoutes.login);
        }
        if (state.status == OnboardingStatus.error &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.darkBackground,
          body: SafeArea(
            child: Column(
              children: [
                // Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                    child: TextButton(
                      onPressed: () => _goToLastPage(),
                      child: Text(
                        'Пропустити',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: AppDimensions.fontSizeMedium,
                        ),
                      ),
                    ),
                  ),
                ),
                // PageView
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (page) {
                      context
                          .read<OnboardingBloc>()
                          .add(OnboardingPageChanged(page));
                    },
                    children: [
                      // Слайд 1: Навчайся тактичній медицині
                      const OnboardingSlide(
                        icon: Icons.local_hospital_rounded,
                        title: 'Навчайся тактичній медицині',
                        description:
                            'Опануй навички першої допомоги в бойових '
                            'та екстремальних умовах з інтерактивними уроками',
                      ),
                      // Слайд 2: 5 хвилин на день
                      const OnboardingSlide(
                        icon: Icons.timer_rounded,
                        title: '5 хвилин на день рятують життя',
                        description:
                            'Короткі щоденні тренування допоможуть тобі '
                            'засвоїти критичні навички та бути готовим '
                            'до будь-якої ситуації',
                        iconColor: AppColors.accentGreen,
                      ),
                      // Слайд 3: Вибір треку
                      TrackSelectionWidget(
                        selectedTrack: state.selectedTrack,
                        onTrackSelected: (track) {
                          context
                              .read<OnboardingBloc>()
                              .add(OnboardingTrackSelected(track));
                        },
                      ),
                    ],
                  ),
                ),
                // Dot indicators + button
                Padding(
                  padding: const EdgeInsets.all(AppDimensions.padding3xLarge),
                  child: Column(
                    children: [
                      // Dot indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return AnimatedContainer(
                            duration: AppDimensions.animationMedium,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: state.currentPage == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: state.currentPage == index
                                  ? AppColors.primaryRed
                                  : AppColors.borderColor,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusCircular,
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: AppDimensions.spacerLarge),
                      // Action button
                      SizedBox(
                        width: double.infinity,
                        height: AppDimensions.buttonHeightXLarge,
                        child: ElevatedButton(
                          onPressed: state.isLastPage
                              ? (state.canComplete
                                  ? () => context
                                      .read<OnboardingBloc>()
                                      .add(const OnboardingCompleted())
                                  : null)
                              : () => _nextPage(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryRed,
                            disabledBackgroundColor:
                                AppColors.primaryRed.withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusLarge,
                              ),
                            ),
                          ),
                          child: Text(
                            state.isLastPage ? 'Почати навчання' : 'Далі',
                            style: const TextStyle(
                              fontSize: AppDimensions.fontSizeLarge,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: AppDimensions.animationMedium,
      curve: Curves.easeInOut,
    );
  }

  void _goToLastPage() {
    _pageController.animateToPage(
      2,
      duration: AppDimensions.animationMedium,
      curve: Curves.easeInOut,
    );
  }
}
