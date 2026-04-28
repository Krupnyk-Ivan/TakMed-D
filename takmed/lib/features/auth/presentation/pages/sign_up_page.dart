import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// Екран реєстрації нового користувача.
class SignUpPage extends StatelessWidget {
  /// Створює екран реєстрації.
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => context.go(AppRoutes.login),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(AppStrings.signUpSuccess)),
            );
            context.go(AppRoutes.home);
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
                    const SizedBox(height: AppDimensions.spacerMedium),
                    Text(
                      AppStrings.register,
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    // Ім'я
                    TextField(
                      onChanged: (value) {
                        context.read<AuthBloc>().add(AuthNameChanged(value));
                      },
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        labelText: AppStrings.profile,
                        hintText: AppStrings.nameHint,
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: AppColors.textSecondary,
                        ),
                        errorText: state.nameError,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacerMedium),
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
                        helperText: 'Мінімум 8 символів',
                        helperStyle: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacerMedium),
                    // Підтвердження пароля
                    TextField(
                      onChanged: (value) {
                        context
                            .read<AuthBloc>()
                            .add(AuthConfirmPasswordChanged(value));
                      },
                      obscureText: true,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        labelText: AppStrings.confirmPassword,
                        hintText: 'Повторіть пароль',
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.textSecondary,
                        ),
                        errorText: state.confirmPasswordError,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacerXLarge),
                    // Кнопка реєстрації
                    SizedBox(
                      height: AppDimensions.buttonHeightXLarge,
                      child: ElevatedButton(
                        onPressed: state.status == AuthStatus.loading
                            ? null
                            : () {
                                context
                                    .read<AuthBloc>()
                                    .add(const AuthSignUpSubmitted());
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
                            : const Text(AppStrings.signUp),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacerLarge),
                    // Вже є акаунт?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Вже маєте акаунт?',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        TextButton(
                          onPressed: () => context.go(AppRoutes.login),
                          child: const Text(
                            AppStrings.signIn,
                            style: TextStyle(
                              color: AppColors.primaryRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
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
