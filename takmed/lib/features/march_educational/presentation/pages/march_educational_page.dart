import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/march_item.dart';
import '../bloc/march_educational_bloc.dart';
import '../bloc/march_educational_event.dart';
import '../bloc/march_educational_state.dart';
import '../widgets/march_active_card.dart';
import '../widgets/march_quiz_bottom_sheet.dart';
import '../widgets/march_step_card.dart';
import 'march_results_page.dart';

class MarchEducationalPage extends StatelessWidget {
  const MarchEducationalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MarchEducationalBloc>(
      create: (_) =>
          getIt<MarchEducationalBloc>()..add(const MarchSessionStarted()),
      child: const _MarchView(),
    );
  }
}

class _MarchView extends StatelessWidget {
  const _MarchView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceColor,
        title: const Text('MARCH — тренування'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _confirmExit(context),
        ),
      ),
      body: BlocConsumer<MarchEducationalBloc, MarchEducationalState>(
        // Слухаємо тільки 2 переходи: поява quiz та поява saved-стану.
        listenWhen: (a, b) {
          final quizOpened = a.activeQuiz == null && b.activeQuiz != null;
          final justSaved =
              a.status != b.status && b.status == MarchEducationalStatus.saved;
          return quizOpened || justSaved;
        },
        listener: (context, state) async {
          if (state.activeQuiz != null &&
              (state.status == MarchEducationalStatus.quizActive ||
                  state.status == MarchEducationalStatus.quizFailed)) {
            // Викликаємо тільки ОДИН раз. Закриває себе сам через
            // BlocListener всередині MarchQuizBottomSheet.
            await showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: false,
              backgroundColor: Colors.transparent,
              builder: (_) => BlocProvider.value(
                value: context.read<MarchEducationalBloc>(),
                child: const MarchQuizBottomSheet(),
              ),
            );
            return;
          }

          if (state.status == MarchEducationalStatus.saved) {
            await Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => BlocProvider.value(
                  value: context.read<MarchEducationalBloc>(),
                  child: const MarchResultsPage(),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final session = state.session;
          if (session == null ||
              state.status == MarchEducationalStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildList(context, state);
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, MarchEducationalState state) {
    final items = state.session!.items;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall),
      itemCount: items.length + 1,
      itemBuilder: (context, idx) {
        if (idx == 0) {
          return _Header(state: state);
        }
        final item = items[idx - 1];
        if (item.status == MarchItemStatus.active) {
          return MarchActiveCard(
            item: item,
            hintExpanded: state.hintExpanded,
          );
        }
        return MarchStepCard(item: item);
      },
    );
  }

  Future<void> _confirmExit(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardColor,
        title: const Text('Вийти з тренування?'),
        content: const Text('Поточний прогрес не буде збережено.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Скасувати'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Вийти'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) context.pop();
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.state});
  final MarchEducationalState state;

  @override
  Widget build(BuildContext context) {
    final session = state.session!;
    final activeIndex = session.activeIndex;
    final progress = activeIndex == -1
        ? 1.0
        : (activeIndex / session.items.length).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Освітній режим',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 1.4,
              color: AppColors.accentGreen,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Пройди 5 кроків протоколу MARCH',
            style: TextStyle(
              fontSize: AppDimensions.fontSizeLarge,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Після кожного кроку — короткий тест.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.borderColor,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.accentGreen,
              ),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}
