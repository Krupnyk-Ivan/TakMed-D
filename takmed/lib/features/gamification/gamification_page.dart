import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import 'presentation/bloc/gamification_bloc.dart';
import 'presentation/bloc/gamification_state.dart';
import 'presentation/widgets/achievement_grid.dart';
import 'presentation/widgets/xp_progress_card.dart';

/// Екран гейміфікації: XP, рівень, стрік, значки.
class GamificationPage extends StatelessWidget {
  const GamificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Досягнення та Прогрес'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<GamificationBloc, GamificationState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              // XP / Рівень / Стрік
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: XpProgressCard(
                    totalXp: state.totalXp,
                    currentLevel: state.currentLevel,
                    streak: state.streak,
                    bestStreak: state.bestStreak,
                  ),
                ),
              ),

              // Рекорд стріку
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderColor),
                    ),
                    child: Row(children: [
                      const Text('🏆', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        const Text('Рекорд стріку',
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 12)),
                        Text('${state.bestStreak} днів',
                            style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ]),
                      const Spacer(),
                      Column(crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                        const Text('Поточний стрік',
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 12)),
                        Row(children: [
                          const Text('🔥', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 4),
                          Text('${state.streak} днів',
                              style: const TextStyle(
                                  color: AppColors.warningOrange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ]),
                      ]),
                    ]),
                  ),
                ),
              ),

              // Заголовок значків
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                  child: Row(children: [
                    Text('Значки',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${state.achievements.where((a) => a.isUnlocked).length}/${state.achievements.length}',
                        style: const TextStyle(
                            color: AppColors.primaryRed,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                    ),
                  ]),
                ),
              ),

              // Сітка значків
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: state.achievements.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: CircularProgressIndicator(
                                color: AppColors.primaryRed),
                          ),
                        )
                      : AchievementGrid(achievements: state.achievements),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        },
      ),
    );
  }
}
