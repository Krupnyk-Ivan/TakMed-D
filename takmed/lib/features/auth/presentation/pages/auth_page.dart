import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// Екран авторизації TacMed.
class AuthPage extends StatelessWidget {
  /// Створює екран авторизації.
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AuthView();
  }
}

/// Внутрішнє представлення екрана авторизації.
class _AuthView extends StatelessWidget {
  /// Створює представлення екрана авторизації.
  const _AuthView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state.status == AuthStatus.failure && state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }

        if (state.status == AuthStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppStrings.signInSuccess)),
          );
          context.go(AppRoutes.home);
        }
      },
      builder: (BuildContext context, AuthState state) {
        final bool isLoading = state.status == AuthStatus.loading;

        return Scaffold(
          appBar: AppBar(title: const Text(AppStrings.login)),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged:
                      (String value) =>
                          context.read<AuthBloc>().add(AuthEmailChanged(value)),
                  decoration: const InputDecoration(
                    labelText: AppStrings.email,
                    hintText: AppStrings.emailHint,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  obscureText: true,
                  onChanged:
                      (String value) => context.read<AuthBloc>().add(
                        AuthPasswordChanged(value),
                      ),
                  decoration: const InputDecoration(
                    labelText: AppStrings.password,
                    hintText: AppStrings.passwordHint,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed:
                      isLoading
                          ? null
                          : () => context.read<AuthBloc>().add(
                            const AuthSignInSubmitted(),
                          ),
                  child:
                      isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Text(AppStrings.signIn),
                ),
                const SizedBox(height: 12),
                const Text(AppStrings.demoCredentialsHint),
              ],
            ),
          ),
        );
      },
    );
  }
}
