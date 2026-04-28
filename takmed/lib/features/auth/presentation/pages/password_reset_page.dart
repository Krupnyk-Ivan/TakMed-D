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

/// Екран скидання пароля.
class PasswordResetPage extends StatelessWidget {
  /// Створює екран скидання пароля.
  const PasswordResetPage({super.key});

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
        title: const Text(AppStrings.forgotPassword),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Лист скидання пароля надіслано на email'),
              ),
            );
            Future<void>.delayed(const Duration(seconds: 2), () {
              if (context.mounted) {
                context.go(AppRoutes.login);
              }
            });
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
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.padding3xLarge,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppDimensions.spacerXLarge),
                  Text(
                    AppStrings.forgotPassword,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.spacerMedium),
                  Text(
                    'Введіть email вашого облікового запису, '
                    'і ми надішлемо вам лист для скидання пароля',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.spacerXLarge),
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
                  const SizedBox(height: AppDimensions.spacerXLarge),
                  SizedBox(
                    height: AppDimensions.buttonHeightXLarge,
                    child: ElevatedButton(
                      onPressed: state.status == AuthStatus.loading
                          ? null
                          : () {
                              context.read<AuthBloc>().add(
                                    const AuthPasswordResetSubmitted(),
                                  );
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
                          : const Text('Скинути пароль'),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacerMedium),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.login),
                    child: const Text(
                      AppStrings.back,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
