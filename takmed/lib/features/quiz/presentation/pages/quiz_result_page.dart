import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';
import '../bloc/quiz_state.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/quiz_attempt_dao.dart';
import '../../../../core/di/injection_container.dart';
import '../../../gamification/presentation/bloc/gamification_bloc.dart';
import '../../../gamification/presentation/bloc/gamification_event.dart';
import '../../../gamification/presentation/bloc/gamification_state.dart';
import '../../../learning/domain/repositories/learning_repository.dart';

class QuizResultPage extends StatefulWidget {
  final QuizCompleted result;
  final int? lessonId;
  final int? courseId;

  const QuizResultPage({
    super.key,
    required this.result,
    this.lessonId,
    this.courseId,
  });

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));

    final isPerfect = widget.result.correctAnswers == widget.result.totalQuestions &&
        widget.result.totalQuestions > 0;
    if (isPerfect) _confettiController.play();

    // Зберігаємо прогрес уроку
    if (widget.lessonId != null) {
      getIt<LearningRepository>().completeLesson(widget.lessonId!, widget.result.earnedXp);
    }

    // Нараховуємо гейміфікацію (async lookup courseRemoteId, потім dispatch)
    _dispatchGamification();
  }

  Future<void> _dispatchGamification() async {
    String courseRemoteId = '';
    int totalQuizAttempts = 0;

    if (widget.courseId != null) {
      try {
        final db = getIt<AppDatabase>();
        final course = await db.courseDao.getCourseById(widget.courseId!);
        courseRemoteId = course?.remoteId ?? '';
      } catch (_) {}
    }

    try {
      final dao = getIt<QuizAttemptDao>();
      totalQuizAttempts = await dao.countAttemptsByUser('');
    } catch (_) {}

    getIt<GamificationBloc>().add(GamificationQuizCompleted(
      totalQuestions: widget.result.totalQuestions,
      correctAnswers: widget.result.correctAnswers,
      earnedXp: widget.result.earnedXp,
      courseRemoteId: courseRemoteId,
      fastAnswerCount: widget.result.fastAnswerCount,
      totalQuizAttempts: totalQuizAttempts,
    ));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percent = widget.result.totalQuestions > 0
        ? (widget.result.correctAnswers / widget.result.totalQuestions * 100).round()
        : 0;

    return BlocListener<GamificationBloc, GamificationState>(
      listener: (ctx, state) {
        if (state.leveledUp) {
          _confettiController.play();
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: Text(
              '🏅 Новий рівень: ${state.currentLevel.title}!',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            backgroundColor: AppColors.warningOrange,
            duration: const Duration(seconds: 4),
          ));
        }
        if (state.newlyUnlocked.isNotEmpty) {
          for (final a in state.newlyUnlocked) {
            ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
              content: Row(children: [
                Text(a.icon, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Нове досягнення!',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white)),
                      Text(a.title,
                          style: const TextStyle(color: Colors.white70)),
                    ])),
              ]),
              backgroundColor: AppColors.cardColor,
              duration: const Duration(seconds: 3),
            ));
          }
        }
        if (state.leveledUp || state.newlyUnlocked.isNotEmpty) {
          getIt<GamificationBloc>().add(const GamificationEventsSeen());
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
                    const SizedBox(height: 24),
                    Text(
                      'Результат: $percent%',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.result.correctAnswers} з ${widget.result.totalQuestions} правильних відповідей',
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // XP нарахування з анімацією countup
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.amber),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.bolt, color: Colors.amber, size: 32),
                          const SizedBox(width: 12),
                          TweenAnimationBuilder<int>(
                            tween: IntTween(begin: 0, end: widget.result.earnedXp),
                            duration: const Duration(milliseconds: 1200),
                            builder: (_, value, __) => Text(
                              '+$value XP',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    if (widget.result.weakTopics.isNotEmpty) ...[
                      const Text(
                        'Зверни увагу на ці теми:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.result.weakTopics.map((topic) => Chip(
                          label: Text(topic),
                          backgroundColor: Colors.red.withValues(alpha: 0.2),
                          side: const BorderSide(color: Colors.red),
                        )).toList(),
                      ),
                    ],

                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        if (widget.courseId != null) {
                          final repo = getIt<LearningRepository>();
                          final next =
                              await repo.getNextLessonInCourse(widget.courseId!);
                          if (!mounted) return;
                          next.fold(
                            (failure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Помилка: ${failure.message}')));
                              context.pushReplacement('/course/${widget.courseId}');
                            },
                            (nextLesson) {
                              if (nextLesson != null &&
                                  nextLesson.id != widget.lessonId) {
                                context
                                    .pushReplacement('/lesson/${nextLesson.id}');
                              } else {
                                context.pushReplacement(
                                    '/course/${widget.courseId}');
                              }
                            },
                          );
                        } else {
                          context.go(AppRoutes.home);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        widget.courseId != null ? 'Продовжити' : 'На головну',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    if (percent < 100 && widget.courseId == null) ...[
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.quiz),
                        child: const Text('Спробувати ще раз',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ],
                    const SizedBox(height: 8),
                    TextButton.icon(
                      icon: const Icon(Icons.history, color: AppColors.textSecondary),
                      label: const Text(
                        'Історія спроб',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      onPressed: () => context.push(AppRoutes.quizHistory),
                    ),
                  ],
                ),
              ),
            ),
            // Confetti для 100% та level-up
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Colors.amber, Colors.orange, AppColors.accentGreen,
                  AppColors.primaryRed, Colors.purple,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
