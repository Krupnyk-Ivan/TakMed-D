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

  /// Екран навчання.
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
}
