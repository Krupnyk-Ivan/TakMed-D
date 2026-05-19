import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_routes.dart';
import '../../features/ai_chat/ai_chat_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/auth/presentation/pages/password_reset_page.dart';
import '../../features/gamification/gamification_page.dart';
import '../../features/home/home_page.dart';
import '../../features/learning/presentation/pages/course_detail_page.dart';
import '../../features/learning/presentation/pages/theory_lesson_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/profile/profile_page.dart';
import '../../features/quiz/presentation/pages/quiz_page.dart';
import '../../features/quiz/presentation/pages/quiz_result_page.dart';
import '../../features/quiz/presentation/bloc/quiz_state.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/quiz/presentation/pages/quiz_history_page.dart';
import '../../features/march_educational/presentation/pages/march_educational_page.dart';
import '../../admin/presentation/pages/admin_layout.dart';
import '../../admin/presentation/pages/admin_dashboard_page.dart';
import '../../admin/presentation/pages/course_editor_page.dart';
import '../../admin/presentation/pages/lesson_editor_page.dart';
import '../../admin/presentation/pages/lessons_list_page.dart';
import '../../features/learning/learning_page.dart';
import '../widgets/app_shell_layout.dart';

/// Конфігурація маршрутизації застосунку TacMed.
class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  /// Єдиний екземпляр роутера.
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    routes: <RouteBase>[
      // Splash screen
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => _fadeTransitionPage(
          key: state.pageKey, child: const SplashPage(),
        ),
      ),
      // Онбординг
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) => _fadeTransitionPage(
          key: state.pageKey, child: const OnboardingPage(),
        ),
      ),
      // — Основні 5 вкладок BottomNav через StatefulShellRoute —
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShellLayout(navigationShell: navigationShell),
        branches: [
          // 1. Головна
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (context, state) => _noTransitionPage(
                  key: state.pageKey,
                  child: const HomePage(),
                ),
              ),
            ],
          ),
          // 2. Навчання — каталог курсів
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.learning,
                pageBuilder: (context, state) => _noTransitionPage(
                  key: state.pageKey,
                  child: const LearningPage(),
                ),
              ),
            ],
          ),
          // 3. MARCH тренування (освітній режим)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.marchEducational,
                pageBuilder: (context, state) => _noTransitionPage(
                  key: state.pageKey,
                  child: const MarchEducationalPage(),
                ),
              ),
            ],
          ),
          // 4. Гейміфікація
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.gamification,
                pageBuilder: (context, state) => _noTransitionPage(
                  key: state.pageKey,
                  child: const GamificationPage(),
                ),
              ),
            ],
          ),
          // 5. Профіль
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                pageBuilder: (context, state) => _noTransitionPage(
                  key: state.pageKey,
                  child: const ProfilePage(),
                ),
              ),
            ],
          ),
        ],
      ),
      // Авторизація
      GoRoute(
        path: AppRoutes.auth,
        redirect: (context, state) => AppRoutes.login,
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => _fadeTransitionPage(
          key: state.pageKey, child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        pageBuilder: (context, state) => _fadeTransitionPage(
          key: state.pageKey, child: const SignUpPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.passwordReset,
        pageBuilder: (context, state) => _fadeTransitionPage(
          key: state.pageKey, child: const PasswordResetPage(),
        ),
      ),
      // Курс — деталі
      GoRoute(
        path: AppRoutes.courseDetail,
        pageBuilder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return _fadeTransitionPage(
            key: state.pageKey, child: CourseDetailPage(courseId: id),
          );
        },
      ),
      // Урок
      GoRoute(
        path: AppRoutes.lesson,
        pageBuilder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return _fadeTransitionPage(
            key: state.pageKey, child: TheoryLessonPage(lessonId: id),
          );
        },
      ),
      // Вікторина
      GoRoute(
        path: AppRoutes.quiz,
        pageBuilder: (context, state) => _fadeTransitionPage(
          key: state.pageKey, child: const QuizPage(),
        ),
      ),
      GoRoute(
        path: '/quiz/result',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final result = extra?['state'] as QuizCompleted?;
          final lessonId = extra?['lessonId'] as int?;
          final courseId = extra?['courseId'] as int?;
          
          return _fadeTransitionPage(
            key: state.pageKey, child: QuizResultPage(
              result: result ?? const QuizCompleted(totalQuestions: 0, correctAnswers: 0, earnedXp: 0, weakTopics: []),
              lessonId: lessonId,
              courseId: courseId,
            ),
          );
        },
      ),
      // AI чат
      GoRoute(
        path: AppRoutes.aiChat,
        pageBuilder: (context, state) => _fadeTransitionPage(
          key: state.pageKey, child: const AiChatPage(),
        ),
      ),
      // Історія тестів
      GoRoute(
        path: AppRoutes.quizHistory,
        pageBuilder: (context, state) => _fadeTransitionPage(
          key: state.pageKey, child: const QuizHistoryPage(),
        ),
      ),
      // MARCH тренувальний режим
      GoRoute(
        path: AppRoutes.marchEducational,
        pageBuilder: (context, state) => _fadeTransitionPage(
          key: state.pageKey, child: const MarchEducationalPage(),
        ),
      ),
      // — Адмін-панель —
      GoRoute(
        path: '/admin/dashboard',
        pageBuilder: (context, state) => _fadeTransitionPage(
          key: state.pageKey,
          child: const AdminLayout(child: AdminDashboardPage()),
        ),
      ),
      GoRoute(
        path: '/admin/editor/course/:id/lessons',
        pageBuilder: (context, state) {
          final courseId = state.pathParameters['id'] ?? '';
          return _fadeTransitionPage(
            key: state.pageKey,
            child: AdminLayout(child: LessonsListPage(courseId: courseId)),
          );
        },
      ),
      GoRoute(
        path: '/admin/editor/course/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? 'new';
          return _fadeTransitionPage(
            key: state.pageKey,
            child: AdminLayout(child: CourseEditorPage(courseId: id)),
          );
        },
      ),
      GoRoute(
        path: '/admin/editor/lesson/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? 'new';
          final courseId = state.uri.queryParameters['courseId'] ?? '';
          return _fadeTransitionPage(
            key: state.pageKey,
            child: AdminLayout(child: LessonEditorPage(lessonId: id, courseId: courseId)),
          );
        },
      ),
    ],
  );

  /// Створює FadeTransition для плавних переходів між екранами.
  static CustomTransitionPage<void> _fadeTransitionPage({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: key, child: child,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  /// Без анімації — для перемикання вкладок у BottomNav.
  static NoTransitionPage<void> _noTransitionPage({
    required LocalKey key,
    required Widget child,
  }) {
    return NoTransitionPage<void>(key: key, child: child);
  }
}
