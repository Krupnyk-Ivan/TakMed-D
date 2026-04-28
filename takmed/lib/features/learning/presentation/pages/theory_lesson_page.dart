import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/lesson_content/checklist_content.dart';
import '../../domain/entities/lesson_content/theory_content.dart';
import '../widgets/content_block_renderer.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../domain/repositories/learning_repository.dart';
import '../../../../features/gamification/presentation/bloc/gamification_bloc.dart';
import '../../../../features/gamification/presentation/bloc/gamification_event.dart';
import '../../../../features/gamification/presentation/bloc/gamification_state.dart';
import '../../../../features/march/presentation/pages/march_checklist_page.dart';
import '../../../../features/quiz/presentation/pages/quiz_page.dart';
import 'generic_checklist_page.dart';

/// Екран теоретичного уроку.
class TheoryLessonPage extends StatefulWidget {
  const TheoryLessonPage({super.key, required this.lessonId});
  final int lessonId;

  @override
  State<TheoryLessonPage> createState() => _TheoryLessonPageState();
}

class _TheoryLessonPageState extends State<TheoryLessonPage> {
  LessonEntity? _lesson;
  TheoryContent? _content;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLesson();
  }

  @override
  void didUpdateWidget(covariant TheoryLessonPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.lessonId != oldWidget.lessonId) {
      setState(() => _loading = true);
      _loadLesson();
    }
  }

  Future<void> _loadLesson() async {
    final appDb = getIt<AppDatabase>();
    final lessonDB = await appDb.lessonDao.getLessonById(widget.lessonId);

    if (lessonDB != null && mounted) {
      final lesson = LessonEntity(
        id: lessonDB.id, remoteId: lessonDB.remoteId, courseId: lessonDB.courseId,
        type: lessonDB.type, title: lessonDB.title, contentJson: lessonDB.contentJson,
        durationSeconds: lessonDB.durationSeconds, orderIndex: lessonDB.orderIndex,
        isCompleted: lessonDB.isCompleted, xpReward: lessonDB.xpReward,
      );

      TheoryContent? content;
      try {
        final json = jsonDecode(lesson.contentJson) as Map<String, dynamic>;
        content = TheoryContent.fromJson(json);
      } catch (_) {}

      setState(() {
        _lesson = lesson;
        _content = content;
        _loading = false;
      });
    } else {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.darkBackground,
        body: Center(child: CircularProgressIndicator(color: AppColors.primaryRed)),
      );
    }

    if (_lesson == null || (_content == null && _lesson!.type != 'quiz')) {
      return Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(child: Text('Урок не знайдено',
            style: TextStyle(color: AppColors.textSecondary))),
      );
    }

    if (_lesson!.type == 'quiz') {
      return QuizPage(lessonId: _lesson!.id, courseId: _lesson!.courseId);
    }

    if (_lesson!.type == 'checklist') {
      return _buildChecklistPage(context);
    }

    return BlocListener<GamificationBloc, GamificationState>(
      listener: _handleGamificationEvents,
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent, elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
            onPressed: () => context.go('/course/${_lesson!.courseId}'),
          ),
          title: Text(_lesson!.title, style: const TextStyle(fontSize: 16)),
          actions: [
            if (_content!.keyTerms.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.menu_book_rounded, color: AppColors.primaryRed),
                onPressed: () => _showKeyTerms(context),
              ),
          ],
        ),
        body: Column(children: [
          Expanded(child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: _content!.blocks.length,
            itemBuilder: (context, index) =>
                ContentBlockRenderer(block: _content!.blocks[index]),
          )),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.surfaceColor,
              border: Border(top: BorderSide(color: AppColors.borderColor)),
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity, height: AppDimensions.buttonHeightXLarge,
                child: ElevatedButton(
                  onPressed: () => _completeAndNavigate(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge)),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      _lesson!.isCompleted ? 'Далі' : 'Завершити та продовжити',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, color: AppColors.textPrimary),
                  ]),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void _handleGamificationEvents(BuildContext context, GamificationState state) {
    if (state.leveledUp || state.newlyUnlocked.isNotEmpty) {
      // Показуємо банер першого нового значка
      if (state.newlyUnlocked.isNotEmpty) {
        final a = state.newlyUnlocked.first;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: [
            Text(a.icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, children: [
              Text('Нове досягнення!',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              Text(a.title, style: const TextStyle(color: Colors.white70)),
            ])),
          ]),
          backgroundColor: AppColors.cardColor,
          duration: const Duration(seconds: 3),
        ));
      }
      if (state.leveledUp) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('🏅 Новий рівень: ${state.currentLevel.title}!',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          backgroundColor: AppColors.warningOrange,
          duration: const Duration(seconds: 3),
        ));
      }
      getIt<GamificationBloc>().add(const GamificationEventsSeen());
    }
  }

  /// Парсить ChecklistContent та роутить до потрібної сторінки:
  /// • MARCH-чеклист (5 кроків M/A/R/C/H) → [MarchChecklistPage]
  /// • Решта → [GenericChecklistPage]
  Widget _buildChecklistPage(BuildContext context) {
    ChecklistContent? content;
    try {
      content = ChecklistContent.fromJson(
          jsonDecode(_lesson!.contentJson) as Map<String, dynamic>);
    } catch (_) {
      content = const ChecklistContent(steps: []);
    }

    final isMarch = _isMarchChecklist(content);

    if (isMarch) {
      return MarchChecklistPage(lesson: _lesson!, content: content);
    }
    return GenericChecklistPage(lesson: _lesson!, content: content);
  }

  /// Визначає, чи є контент чеклістом MARCH.
  /// Критерій: рівно 5 кроків, заголовки починаються з M, A, R, C, H.
  bool _isMarchChecklist(ChecklistContent content) {
    const codes = ['M', 'A', 'R', 'C', 'H'];
    if (content.steps.length != codes.length) return false;
    for (var i = 0; i < codes.length; i++) {
      if (!content.steps[i].title.startsWith(codes[i])) return false;
    }
    return true;
  }

  Future<void> _completeAndNavigate(BuildContext context) async {
    final repo = getIt<LearningRepository>();
    await repo.completeLesson(_lesson!.id, 100);

    // Збираємо дані для гейміфікації
    final db = getIt<AppDatabase>();
    final courseResult = await repo.getCourseById(_lesson!.courseId);
    final courseRemoteId = courseResult.fold((_) => '', (c) => c?.remoteId ?? '');

    final courseLessons = await db.lessonDao.getLessonsByCourse(_lesson!.courseId);
    final isAllCourseComplete =
        courseLessons.every((l) => l.isCompleted || l.id == _lesson!.id);

    final totalCompleted = await db.lessonDao.countAllCompletedLessons();

    bool isOffline = false;
    try {
      isOffline = !(await getIt<NetworkInfo>().isConnected);
    } catch (_) {}

    // Dispatch ПЕРЕД навігацією — context ще валідний
    getIt<GamificationBloc>().add(GamificationLessonCompleted(
      lessonId: _lesson!.id,
      courseRemoteId: courseRemoteId,
      isOffline: isOffline,
      isAllCourseComplete: isAllCourseComplete,
      totalCompletedLessons: totalCompleted + 1,
    ));

    final eitherNext = await repo.getNextLessonInCourse(_lesson!.courseId);
    if (!mounted) return;

    eitherNext.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Помилка: ${failure.message}')),
        );
      },
      (nextLesson) {
        if (nextLesson != null && nextLesson.id != _lesson!.id) {
          context.pushReplacement('/lesson/${nextLesson.id}');
        } else {
          context.pushReplacement('/course/${_lesson!.courseId}');
        }
      },
    );
  }

  void _showKeyTerms(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color: AppColors.borderColor,
                  borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 20),
          Text('📚 Ключові поняття',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ..._content!.keyTerms.map((term) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(children: [
              const Icon(Icons.circle, size: 6, color: AppColors.primaryRed),
              const SizedBox(width: 10),
              Text(term, style: Theme.of(context).textTheme.bodyLarge),
            ]),
          )),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }
}
