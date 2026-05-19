import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/di/injection_container.dart' as core_di;
import '../../core/config/supabase_config.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/sign_in_use_case.dart';
import '../../features/auth/domain/usecases/sign_up_use_case.dart';
import '../../features/auth/domain/usecases/password_reset_use_case.dart';
import '../../features/auth/domain/usecases/logout_use_case.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

final adminGetIt = GetIt.instance;

/// Ініціалізація залежностей спеціально для адмін-панелі.
Future<void> setupAdminDI() async {
  if (!SupabaseConfig.isConfigured) {
    throw StateError('Supabase не налаштовано.');
  }

  // Основна інфраструктура може бути перевикористана, 
  // але тут ми ініціалізуємо лише те, що необхідно для адмінки.
  
  await supabase.Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );
  
  // Якщо `core_di.getIt` ще не ініціалізований:
  if (!adminGetIt.isRegistered<supabase.SupabaseClient>()) {
    adminGetIt.registerSingleton<supabase.SupabaseClient>(
      supabase.Supabase.instance.client,
    );
  }
  
  if (!adminGetIt.isRegistered<FlutterSecureStorage>()) {
    adminGetIt.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  }

  // Реєстрація Auth
  if (!adminGetIt.isRegistered<AuthRemoteDataSource>()) {
    adminGetIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(adminGetIt<supabase.SupabaseClient>()),
    );
    adminGetIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        adminGetIt<AuthRemoteDataSource>(),
        adminGetIt<FlutterSecureStorage>(),
      ),
    );
    adminGetIt.registerLazySingleton<SignInUseCase>(
      () => SignInUseCase(adminGetIt<AuthRepository>()),
    );
    adminGetIt.registerLazySingleton<SignUpUseCase>(
      () => SignUpUseCase(adminGetIt<AuthRepository>()),
    );
    adminGetIt.registerLazySingleton<PasswordResetUseCase>(
      () => PasswordResetUseCase(adminGetIt<AuthRepository>()),
    );
    adminGetIt.registerLazySingleton<LogoutUseCase>(
      () => LogoutUseCase(adminGetIt<AuthRepository>()),
    );
    adminGetIt.registerFactory<AuthBloc>(
      () => AuthBloc(
        adminGetIt<SignInUseCase>(),
        adminGetIt<SignUpUseCase>(),
        adminGetIt<PasswordResetUseCase>(),
        adminGetIt<LogoutUseCase>(),
        adminGetIt<supabase.SupabaseClient>(),
      ),
    );
  }
}
