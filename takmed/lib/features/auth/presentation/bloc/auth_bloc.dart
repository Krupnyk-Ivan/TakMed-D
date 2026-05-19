import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../../core/constants/app_strings.dart';
import '../../data/models/auth_user_model.dart';
import '../../domain/usecases/sign_in_use_case.dart';
import '../../domain/usecases/sign_up_use_case.dart';
import '../../domain/usecases/password_reset_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// BLoC авторизації.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  /// Створює BLoC авторизації.
  AuthBloc(
    this._signInUseCase,
    this._signUpUseCase,
    this._passwordResetUseCase,
    this._logoutUseCase,
    this._supabaseClient,
  ) : super(const AuthState()) {
    on<AuthEmailChanged>(_onEmailChanged);
    on<AuthPasswordChanged>(_onPasswordChanged);
    on<AuthConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<AuthNameChanged>(_onNameChanged);
    on<AuthSignInSubmitted>(_onSignInSubmitted);
    on<AuthSignUpSubmitted>(_onSignUpSubmitted);
    on<AuthPasswordResetSubmitted>(_onPasswordResetSubmitted);
    on<AuthLogoutSubmitted>(_onLogoutSubmitted);
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthResetFormFields>(_onResetFormFields);
    on<AuthGuestModeRequested>(_onGuestModeRequested);
  }

  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final PasswordResetUseCase _passwordResetUseCase;
  final LogoutUseCase _logoutUseCase;
  final supabase.SupabaseClient _supabaseClient;

  /// Regex для валідації email.
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Мінімальна довжина пароля.
  static const int _minPasswordLength = 8;

  // — Валідація у реальному часі —

  String? _validateEmail(String email) {
    if (email.trim().isEmpty) return null; // не показуємо помилку поки порожнє
    if (!_emailRegex.hasMatch(email.trim())) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) return null;
    if (password.length < _minPasswordLength) {
      return AppStrings.passwordTooShort;
    }
    return null;
  }

  String? _validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) return null;
    if (password != confirmPassword) {
      return AppStrings.passwordMismatch;
    }
    return null;
  }

  void _onEmailChanged(AuthEmailChanged event, Emitter<AuthState> emit) {
    final error = _validateEmail(event.email);
    emit(state.copyWith(
      email: event.email,
      status: AuthStatus.initial,
      emailError: error,
      clearEmailError: error == null,
    ));
  }

  void _onPasswordChanged(AuthPasswordChanged event, Emitter<AuthState> emit) {
    final error = _validatePassword(event.password);
    emit(state.copyWith(
      password: event.password,
      status: AuthStatus.initial,
      passwordError: error,
      clearPasswordError: error == null,
    ));
  }

  void _onConfirmPasswordChanged(
    AuthConfirmPasswordChanged event,
    Emitter<AuthState> emit,
  ) {
    final error = _validateConfirmPassword(state.password, event.confirmPassword);
    emit(state.copyWith(
      confirmPassword: event.confirmPassword,
      status: AuthStatus.initial,
      confirmPasswordError: error,
      clearConfirmPasswordError: error == null,
    ));
  }

  void _onNameChanged(AuthNameChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(
      name: event.name,
      status: AuthStatus.initial,
      clearNameError: true,
    ));
  }

  Future<void> _onSignInSubmitted(
    AuthSignInSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    // Фінальна валідація
    if (state.email.trim().isEmpty) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: AppStrings.emailRequired,
      ));
      return;
    }

    if (_validateEmail(state.email) != null) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: AppStrings.invalidEmail,
      ));
      return;
    }

    if (state.password.trim().isEmpty) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: AppStrings.passwordRequired,
      ));
      return;
    }

    if (state.password.length < _minPasswordLength) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: AppStrings.passwordTooShort,
      ));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));

    final result = await _signInUseCase(
      SignInParams(email: state.email.trim(), password: state.password.trim()),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (user) => emit(
        state.copyWith(
          status: AuthStatus.success,
          errorMessage: null,
          user: user,
        ),
      ),
    );
  }

  Future<void> _onSignUpSubmitted(
    AuthSignUpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (state.name.trim().isEmpty) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: AppStrings.nameRequired,
      ));
      return;
    }

    if (state.email.trim().isEmpty) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: AppStrings.emailRequired,
      ));
      return;
    }

    if (_validateEmail(state.email) != null) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: AppStrings.invalidEmail,
      ));
      return;
    }

    if (state.password.trim().isEmpty) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: AppStrings.passwordRequired,
      ));
      return;
    }

    if (state.password.length < _minPasswordLength) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: AppStrings.passwordTooShort,
      ));
      return;
    }

    if (state.password != state.confirmPassword) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: AppStrings.passwordMismatch,
      ));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));

    final result = await _signUpUseCase(
      SignUpParams(
        email: state.email.trim(),
        password: state.password.trim(),
        name: state.name.trim(),
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (user) => emit(
        state.copyWith(
          status: AuthStatus.success,
          errorMessage: null,
          user: user,
        ),
      ),
    );
  }

  Future<void> _onPasswordResetSubmitted(
    AuthPasswordResetSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (state.email.trim().isEmpty) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: AppStrings.emailRequired,
      ));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));

    final result = await _passwordResetUseCase(
      PasswordResetParams(email: state.email.trim()),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) =>
          emit(state.copyWith(status: AuthStatus.success, errorMessage: null)),
    );
  }

  Future<void> _onLogoutSubmitted(
    AuthLogoutSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _logoutUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        const AuthState(status: AuthStatus.unauthenticated, errorMessage: null),
      ),
    );
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final session = _supabaseClient.auth.currentSession;
    final user = _supabaseClient.auth.currentUser;

    if (session != null && user != null) {
      final name = user.userMetadata?['name'] as String? ??
          (user.email?.split('@').first ?? 'User');

      String role = 'student';
      try {
        final profile = await _supabaseClient
            .from('profiles')
            .select('role')
            .eq('id', user.id)
            .single();
        role = profile['role'] as String? ?? 'student';
      } catch (_) {}

      emit(state.copyWith(
        status: AuthStatus.success,
        user: AuthUserModel(
          id: user.id,
          email: user.email ?? '',
          name: name,
          token: session.accessToken,
          role: role,
        ),
      ));
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  void _onResetFormFields(
    AuthResetFormFields event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthState());
  }

  void _onGuestModeRequested(
    AuthGuestModeRequested event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(
      status: AuthStatus.guest,
      user: const AuthUserModel(
        id: 'guest',
        email: '',
        name: 'Гість',
        token: '',
      ),
    ));
  }
}
