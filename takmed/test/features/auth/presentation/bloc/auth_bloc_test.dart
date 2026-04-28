import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:takmed/core/errors/failures.dart';
import 'package:takmed/features/auth/data/models/auth_user_model.dart';
import 'package:takmed/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:takmed/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:takmed/features/auth/domain/usecases/password_reset_use_case.dart';
import 'package:takmed/features/auth/domain/usecases/logout_use_case.dart';
import 'package:takmed/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:takmed/features/auth/presentation/bloc/auth_event.dart';
import 'package:takmed/features/auth/presentation/bloc/auth_state.dart';

@GenerateNiceMocks([
  MockSpec<SignInUseCase>(),
  MockSpec<SignUpUseCase>(),
  MockSpec<PasswordResetUseCase>(),
  MockSpec<LogoutUseCase>(),
  MockSpec<supabase.SupabaseClient>(),
])
import 'auth_bloc_test.mocks.dart';

void main() {
  late MockSignInUseCase mockSignInUseCase;
  late MockSignUpUseCase mockSignUpUseCase;
  late MockPasswordResetUseCase mockPasswordResetUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockSupabaseClient mockSupabaseClient;

  setUp(() {
    mockSignInUseCase = MockSignInUseCase();
    mockSignUpUseCase = MockSignUpUseCase();
    mockPasswordResetUseCase = MockPasswordResetUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockSupabaseClient = MockSupabaseClient();
  });

  const tUser = AuthUserModel(
    id: 'test-id',
    email: 'test@test.com',
    name: 'Test User',
    token: 'test-token',
  );

  AuthBloc createBloc() {
    return AuthBloc(
      mockSignInUseCase,
      mockSignUpUseCase,
      mockPasswordResetUseCase,
      mockLogoutUseCase,
      mockSupabaseClient,
    );
  }

  group('AuthBloc — початковий стан', () {
    test('початковий стан — AuthStatus.initial', () {
      final bloc = createBloc();
      expect(bloc.state.status, AuthStatus.initial);
      expect(bloc.state.email, '');
      expect(bloc.state.password, '');
      expect(bloc.state.user, isNull);
      bloc.close();
    });
  });

  group('AuthBloc — зміна полів форми', () {
    blocTest<AuthBloc, AuthState>(
      'AuthEmailChanged оновлює email',
      build: createBloc,
      act: (bloc) => bloc.add(const AuthEmailChanged('user@mail.com')),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.email, 'email', 'user@mail.com')
            .having((s) => s.status, 'status', AuthStatus.initial),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'AuthEmailChanged з невалідним email встановлює emailError',
      build: createBloc,
      act: (bloc) => bloc.add(const AuthEmailChanged('bad-email')),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.email, 'email', 'bad-email')
            .having((s) => s.emailError, 'emailError', isNotNull),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'AuthEmailChanged з валідним email — emailError == null',
      build: createBloc,
      act: (bloc) => bloc.add(const AuthEmailChanged('valid@email.com')),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.emailError, 'emailError', isNull),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'AuthPasswordChanged оновлює password',
      build: createBloc,
      act: (bloc) => bloc.add(const AuthPasswordChanged('12345678')),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.password, 'password', '12345678')
            .having((s) => s.passwordError, 'passwordError', isNull),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'AuthPasswordChanged з коротким паролем — passwordError не null',
      build: createBloc,
      act: (bloc) => bloc.add(const AuthPasswordChanged('123')),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.password, 'password', '123')
            .having((s) => s.passwordError, 'passwordError', isNotNull),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'AuthConfirmPasswordChanged з невідповідним паролем — помилка',
      build: createBloc,
      seed: () => const AuthState(password: 'password1'),
      act: (bloc) =>
          bloc.add(const AuthConfirmPasswordChanged('password2')),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.confirmPasswordError, 'confirmPasswordError',
                isNotNull),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'AuthNameChanged оновлює name',
      build: createBloc,
      act: (bloc) => bloc.add(const AuthNameChanged('Тест')),
      expect: () => [
        isA<AuthState>().having((s) => s.name, 'name', 'Тест'),
      ],
    );
  });

  group('AuthBloc — SignIn', () {
    blocTest<AuthBloc, AuthState>(
      'SignIn success: loading → success',
      build: () {
        when(mockSignInUseCase(any))
            .thenAnswer((_) async => const Right(tUser));
        return createBloc();
      },
      seed: () => const AuthState(
        email: 'test@test.com',
        password: '12345678',
      ),
      act: (bloc) => bloc.add(const AuthSignInSubmitted()),
      expect: () => [
        isA<AuthState>().having((s) => s.status, 'status', AuthStatus.loading),
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.success)
            .having((s) => s.user, 'user', tUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'SignIn failure: loading → failure з повідомленням',
      build: () {
        when(mockSignInUseCase(any)).thenAnswer(
          (_) async => const Left(AuthFailure('Невірний пароль')),
        );
        return createBloc();
      },
      seed: () => const AuthState(
        email: 'test@test.com',
        password: '12345678',
      ),
      act: (bloc) => bloc.add(const AuthSignInSubmitted()),
      expect: () => [
        isA<AuthState>().having((s) => s.status, 'status', AuthStatus.loading),
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.failure)
            .having((s) => s.errorMessage, 'errorMessage', 'Невірний пароль'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'SignIn з порожнім email → failure без запиту до use case',
      build: createBloc,
      seed: () => const AuthState(email: '', password: '12345678'),
      act: (bloc) => bloc.add(const AuthSignInSubmitted()),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.failure)
            .having((s) => s.errorMessage, 'errorMessage', isNotNull),
      ],
      verify: (_) {
        verifyNever(mockSignInUseCase(any));
      },
    );

    blocTest<AuthBloc, AuthState>(
      'SignIn з невалідним email → failure',
      build: createBloc,
      seed: () => const AuthState(email: 'bad', password: '12345678'),
      act: (bloc) => bloc.add(const AuthSignInSubmitted()),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.failure),
      ],
      verify: (_) {
        verifyNever(mockSignInUseCase(any));
      },
    );

    blocTest<AuthBloc, AuthState>(
      'SignIn з коротким паролем (< 8) → failure',
      build: createBloc,
      seed: () => const AuthState(email: 'test@test.com', password: '123'),
      act: (bloc) => bloc.add(const AuthSignInSubmitted()),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.failure),
      ],
      verify: (_) {
        verifyNever(mockSignInUseCase(any));
      },
    );

    blocTest<AuthBloc, AuthState>(
      'SignIn network failure',
      build: () {
        when(mockSignInUseCase(any)).thenAnswer(
          (_) async => const Left(NetworkFailure('Немає мережі')),
        );
        return createBloc();
      },
      seed: () => const AuthState(
        email: 'test@test.com',
        password: '12345678',
      ),
      act: (bloc) => bloc.add(const AuthSignInSubmitted()),
      expect: () => [
        isA<AuthState>().having((s) => s.status, 'status', AuthStatus.loading),
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.failure)
            .having((s) => s.errorMessage, 'errorMessage', 'Немає мережі'),
      ],
    );
  });

  group('AuthBloc — SignUp', () {
    blocTest<AuthBloc, AuthState>(
      'SignUp success',
      build: () {
        when(mockSignUpUseCase(any))
            .thenAnswer((_) async => const Right(tUser));
        return createBloc();
      },
      seed: () => const AuthState(
        name: 'Test',
        email: 'test@test.com',
        password: '12345678',
        confirmPassword: '12345678',
      ),
      act: (bloc) => bloc.add(const AuthSignUpSubmitted()),
      expect: () => [
        isA<AuthState>().having((s) => s.status, 'status', AuthStatus.loading),
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.success)
            .having((s) => s.user, 'user', tUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'SignUp з порожнім іменем → failure',
      build: createBloc,
      seed: () => const AuthState(
        name: '',
        email: 'test@test.com',
        password: '12345678',
        confirmPassword: '12345678',
      ),
      act: (bloc) => bloc.add(const AuthSignUpSubmitted()),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.failure),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'SignUp з невідповідними паролями → failure',
      build: createBloc,
      seed: () => const AuthState(
        name: 'Test',
        email: 'test@test.com',
        password: '12345678',
        confirmPassword: 'different1',
      ),
      act: (bloc) => bloc.add(const AuthSignUpSubmitted()),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.failure)
            .having((s) => s.errorMessage, 'errorMessage',
                contains('не збігаються')),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'SignUp з коротким паролем → failure',
      build: createBloc,
      seed: () => const AuthState(
        name: 'Test',
        email: 'test@test.com',
        password: '123',
        confirmPassword: '123',
      ),
      act: (bloc) => bloc.add(const AuthSignUpSubmitted()),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.failure),
      ],
    );
  });

  group('AuthBloc — Guest Mode', () {
    blocTest<AuthBloc, AuthState>(
      'AuthGuestModeRequested → status guest',
      build: createBloc,
      act: (bloc) => bloc.add(const AuthGuestModeRequested()),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.guest)
            .having((s) => s.user, 'user', isNotNull)
            .having((s) => s.user?.id, 'user.id', 'guest'),
      ],
    );
  });

  group('AuthBloc — Logout', () {
    blocTest<AuthBloc, AuthState>(
      'Logout success → unauthenticated',
      build: () {
        when(mockLogoutUseCase())
            .thenAnswer((_) async => const Right(unit));
        return createBloc();
      },
      act: (bloc) => bloc.add(const AuthLogoutSubmitted()),
      expect: () => [
        isA<AuthState>().having((s) => s.status, 'status', AuthStatus.loading),
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.unauthenticated),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'Logout failure → error',
      build: () {
        when(mockLogoutUseCase()).thenAnswer(
          (_) async => const Left(AuthFailure('Помилка виходу')),
        );
        return createBloc();
      },
      act: (bloc) => bloc.add(const AuthLogoutSubmitted()),
      expect: () => [
        isA<AuthState>().having((s) => s.status, 'status', AuthStatus.loading),
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.failure)
            .having((s) => s.errorMessage, 'errorMessage', 'Помилка виходу'),
      ],
    );
  });

  group('AuthBloc — Reset', () {
    blocTest<AuthBloc, AuthState>(
      'AuthResetFormFields → початковий стан',
      build: createBloc,
      seed: () => const AuthState(
        email: 'test@test.com',
        password: '12345678',
        status: AuthStatus.success,
      ),
      act: (bloc) => bloc.add(const AuthResetFormFields()),
      expect: () => [
        const AuthState(),
      ],
    );
  });

  group('AuthBloc — AuthStatus enum', () {
    test('AuthStatus містить всі необхідні стани', () {
      expect(AuthStatus.values, containsAll([
        AuthStatus.initial,
        AuthStatus.loading,
        AuthStatus.success,
        AuthStatus.failure,
        AuthStatus.authenticated,
        AuthStatus.unauthenticated,
        AuthStatus.guest,
      ]));
    });
  });
}
