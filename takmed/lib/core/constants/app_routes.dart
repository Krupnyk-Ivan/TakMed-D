/// Централізовані маршрути застосунку TacMed.
class AppRoutes {
  /// Splash screen.
  static const String splash = '/splash';

  /// Онбординг.
  static const String onboarding = '/onboarding';

  /// Головний екран.
  static const String home = '/';

  /// Екран входу.
  static const String login = '/auth/login';

  /// Екран реєстрації.
  static const String register = '/auth/sign-up';

  /// Скидання пароля.
  static const String passwordReset = '/auth/password-reset';

  /// Екран авторизації (redirect на login).
  static const String auth = '/auth';

  /// Екран навчання (вкладка BottomNav: повний каталог курсів).
  static const String learning = '/learning';

  /// Деталі курсу.
  static const String courseDetail = '/course/:id';

  /// Екран уроку.
  static const String lesson = '/lesson/:id';

  /// Екран вікторини.
  static const String quiz = '/quiz';

  /// Екран AI-чату.
  static const String aiChat = '/ai-chat';

  /// Екран гейміфікації.
  static const String gamification = '/gamification';

  /// Екран профілю.
  static const String profile = '/profile';

  /// Екран чекліста MARCH.
  static const String marchChecklist = '/march-checklist';

  /// Історія спроб тестів.
  static const String quizHistory = '/quiz/history';

  /// Освітній (тренувальний) режим MARCH.
  static const String marchEducational = '/march-educational';

  // — Адмін-панель —

  /// Головна адмін-панелі.
  static const String adminDashboard = '/admin/dashboard';

  /// Редактор курсу.
  static const String adminCourseEditor = '/admin/editor/course/:id';

  /// Список уроків курсу.
  static const String adminLessonsList = '/admin/editor/course/:id/lessons';

  /// Редактор уроку.
  static const String adminLessonEditor = '/admin/editor/lesson/:id';
}
