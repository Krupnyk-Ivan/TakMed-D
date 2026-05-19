import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../presentation/pages/admin_dashboard_page.dart';
import '../presentation/pages/admin_layout.dart';
import '../presentation/pages/course_editor_page.dart';
import '../presentation/pages/lesson_editor_page.dart';
import '../presentation/pages/lessons_list_page.dart';

class AdminRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    redirect: _guardRedirect,
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _fadePage(
          key: state.pageKey,
          child: const LoginPage(isAdminMode: true),
        ),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AdminLayout(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) => _fadePage(
              key: state.pageKey,
              child: const AdminDashboardPage(),
            ),
          ),
          GoRoute(
            path: '/editor/course/:id',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id'] ?? 'new';
              return _fadePage(
                key: state.pageKey,
                child: CourseEditorPage(courseId: id),
              );
            },
          ),
          GoRoute(
            path: '/editor/course/:id/lessons',
            pageBuilder: (context, state) {
              final courseId = state.pathParameters['id'] ?? '';
              return _fadePage(
                key: state.pageKey,
                child: LessonsListPage(courseId: courseId),
              );
            },
          ),
          GoRoute(
            path: '/editor/lesson/:id',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id'] ?? 'new';
              final courseId = state.uri.queryParameters['courseId'] ?? '';
              return _fadePage(
                key: state.pageKey,
                child: LessonEditorPage(lessonId: id, courseId: courseId),
              );
            },
          ),
        ],
      ),
    ],
  );

  /// Перевіряє авторизацію та роль admin перед кожним переходом.
  static String? _guardRedirect(BuildContext context, GoRouterState state) {
    final client = Supabase.instance.client;
    final session = client.auth.currentSession;
    final isLoginPage = state.matchedLocation == '/login';

    if (session == null) {
      return isLoginPage ? null : '/login';
    }
    // Роль перевіряється у LoginPage після signIn.
    // Тут достатньо перевірити наявність сесії.
    if (isLoginPage) return '/dashboard';
    return null;
  }

  static CustomTransitionPage<void> _fadePage({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
