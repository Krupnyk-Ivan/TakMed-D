import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../onboarding/domain/repositories/onboarding_repository.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// Після успішної авторизації — якщо онбординг ще не пройдений, ведемо туди;
/// інакше — на головну.
Future<void> _goAfterAuth(BuildContext context) async {
  final completed =
      await getIt<OnboardingRepository>().isOnboardingCompleted();
  if (!context.mounted) return;
  context.go(completed ? AppRoutes.home : AppRoutes.onboarding);
}

/// Екран входу користувача.
class LoginPage extends StatelessWidget {
  /// Створює екран входу.
  const LoginPage({super.key, this.isAdminMode = false});

  /// Чи відображається сторінка в режимі адмін-панелі.
  final bool isAdminMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(AppStrings.signInSuccess)),
            );
            if (state.user?.role == 'admin') {
              context.go(AppRoutes.adminDashboard);
            } else {
              _goAfterAuth(context);
            }
          } else if (state.status == AuthStatus.guest) {
            if (isAdminMode) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Гостьовий вхід заборонений для адмін-панелі.'),
                  backgroundColor: AppColors.errorRed,
                ),
              );
              context.read<AuthBloc>().add(const AuthResetFormFields());
            } else {
              _goAfterAuth(context);
            }
          } else if (state.status == AuthStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? AppStrings.error),
                backgroundColor: AppColors.errorRed,
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.padding3xLarge,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60),
                    // Логотип
                    Icon(
                      Icons.medical_services_rounded,
                      size: 64,
                      color: AppColors.primaryRed,
                    ),
                    const SizedBox(height: AppDimensions.spacerMedium),
                    Text(
                      AppStrings.appName,
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.spacerSmall),
                    Text(
                      AppStrings.welcome,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    // Email
                    TextField(
                      onChanged: (value) {
                        context.read<AuthBloc>().add(AuthEmailChanged(value));
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        labelText: AppStrings.email,
                        hintText: AppStrings.emailHint,
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: AppColors.textSecondary,
                        ),
                        errorText: state.emailError,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacerMedium),
                    // Пароль
                    TextField(
                      onChanged: (value) {
                        context
                            .read<AuthBloc>()
                            .add(AuthPasswordChanged(value));
                      },
                      obscureText: true,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        labelText: AppStrings.password,
                        hintText: AppStrings.passwordHint,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.textSecondary,
                        ),
                        errorText: state.passwordError,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacerSmall),
                    // Забули пароль?
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.go(AppRoutes.passwordReset),
                        child: const Text(
                          AppStrings.forgotPassword,
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacerLarge),
                    // Кнопка входу
                    SizedBox(
                      height: AppDimensions.buttonHeightXLarge,
                      child: ElevatedButton(
                        onPressed: state.status == AuthStatus.loading
                            ? null
                            : () {
                                context
                                    .read<AuthBloc>()
                                    .add(const AuthSignInSubmitted());
                              },
                        child: state.status == AuthStatus.loading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.textPrimary,
                                ),
                              )
                            : const Text(AppStrings.signIn),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacerMedium),
                    if (!isAdminMode)
                      SizedBox(
                        height: AppDimensions.buttonHeightXLarge,
                        child: OutlinedButton(
                          onPressed: () {
                            context
                                .read<AuthBloc>()
                                .add(const AuthGuestModeRequested());
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.borderColor),
                          ),
                          child: const Text(
                            AppStrings.continueWithoutAccount,
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                      ),
                    if (!isAdminMode)
                      const SizedBox(height: AppDimensions.spacerLarge),
                    // Реєстрація
                    if (!isAdminMode)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Ще не маєте акаунту?',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          TextButton(
                            onPressed: () => context.go(AppRoutes.register),
                            child: const Text(
                              AppStrings.signUp,
                              style: TextStyle(
                                color: AppColors.primaryRed,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (!isAdminMode)
                      const SizedBox(height: AppDimensions.spacerMedium),
                    // Demo hint
                    Text(
                      AppStrings.demoCredentialsHint,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary.withValues(alpha: 0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.spacerLarge),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
