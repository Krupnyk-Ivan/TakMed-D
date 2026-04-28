import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../config/supabase_config.dart';
import '../database/app_database.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/sign_in_use_case.dart';
import '../../features/auth/domain/usecases/sign_up_use_case.dart';
import '../../features/auth/domain/usecases/password_reset_use_case.dart';
import '../../features/auth/domain/usecases/logout_use_case.dart';
import '../../features/auth/domain/usecases/token_refresh_use_case.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/onboarding/data/datasources/onboarding_local_data_source.dart';
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../features/onboarding/domain/usecases/save_track_use_case.dart';
import '../../features/onboarding/domain/usecases/get_track_use_case.dart';
import '../../features/onboarding/domain/usecases/complete_onboarding_use_case.dart';
import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart';
import '../../features/quiz/data/repositories/quiz_repository.dart';
import '../../features/quiz/presentation/bloc/quiz_bloc.dart';
import '../database/daos/progress_dao.dart';
import '../../features/splash/presentation/bloc/splash_bloc.dart';
import '../../features/learning/domain/repositories/learning_repository.dart';
import '../../features/learning/data/datasources/learning_remote_data_source.dart';
import '../../features/learning/data/repositories/learning_repository_impl.dart';
import '../../features/learning/domain/usecases/get_courses_by_track_usecase.dart';
import '../../features/learning/domain/usecases/get_lessons_by_course_usecase.dart';
import '../../features/learning/domain/usecases/complete_lesson_usecase.dart';
import '../../features/learning/domain/usecases/download_course_offline_usecase.dart';
import '../../features/learning/domain/usecases/get_next_lesson_usecase.dart';
import '../../features/learning/presentation/bloc/home_bloc.dart';
import '../../features/learning/presentation/bloc/course_detail_bloc.dart';
import '../../features/gamification/data/services/gamification_service.dart';
import '../../features/gamification/data/services/streak_service.dart';
import '../../features/gamification/data/services/achievement_service.dart';
import '../../features/gamification/data/services/streak_reminder_service.dart';
import '../../features/gamification/presentation/bloc/gamification_bloc.dart';

/// Ініціалізація залежностей (Dependency Injection)
final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  if (!SupabaseConfig.isConfigured) {
    throw StateError(
      'Supabase не налаштовано. Запусти: flutter run -d SM --dart-define-from-file=.env.json',
    );
  }

  await supabase.Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );
  getIt.registerSingleton<supabase.SupabaseClient>(
    supabase.Supabase.instance.client,
  );

  final appDatabase = AppDatabase();
  getIt.registerSingleton<AppDatabase>(appDatabase);
  getIt.registerSingleton<ProgressDao>(appDatabase.progressDao);

  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  const secureStorage = FlutterSecureStorage();
  getIt.registerSingleton<FlutterSecureStorage>(secureStorage);

  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
    ),
  );
  getIt.registerSingleton<Dio>(dio);

  final apiClient = ApiClient();
  getIt.registerSingleton<ApiClient>(apiClient);
  getIt.registerSingleton<Dio>(apiClient.dio, instanceName: 'api_dio');

  final connectivity = Connectivity();
  getIt.registerSingleton<Connectivity>(connectivity);
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt<Connectivity>()),
  );

  setupAuthDI();
  setupOnboardingDI();
  setupSplashDI();
  // Gamification ПЕРЕД Learning (HomeBloc залежить від gamification сервісів)
  setupGamificationDI();
  setupLearningDI();
  setupQuizDI();

  await appDatabase.seedIfEmpty();

  // Ініціалізуємо notification plugin після реєстрації сервісів
  try {
    await getIt<StreakReminderService>().initialize();
  } catch (_) {}
}

void setupAuthDI() {
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<supabase.SupabaseClient>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<FlutterSecureStorage>(),
    ),
  );
  getIt.registerLazySingleton<SignInUseCase>(
    () => SignInUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<SignUpUseCase>(
    () => SignUpUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<PasswordResetUseCase>(
    () => PasswordResetUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<TokenRefreshUseCase>(
    () => TokenRefreshUseCase(getIt<AuthRepository>()),
  );
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      getIt<SignInUseCase>(),
      getIt<SignUpUseCase>(),
      getIt<PasswordResetUseCase>(),
      getIt<LogoutUseCase>(),
      getIt<supabase.SupabaseClient>(),
    ),
  );
}

void setupOnboardingDI() {
  getIt.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(getIt<OnboardingLocalDataSource>()),
  );
  getIt.registerLazySingleton<SaveTrackUseCase>(
    () => SaveTrackUseCase(getIt<OnboardingRepository>()),
  );
  getIt.registerLazySingleton<GetTrackUseCase>(
    () => GetTrackUseCase(getIt<OnboardingRepository>()),
  );
  getIt.registerLazySingleton<CompleteOnboardingUseCase>(
    () => CompleteOnboardingUseCase(getIt<OnboardingRepository>()),
  );
  getIt.registerFactory<OnboardingBloc>(
    () => OnboardingBloc(
      getIt<SaveTrackUseCase>(),
      getIt<GetTrackUseCase>(),
      getIt<CompleteOnboardingUseCase>(),
    ),
  );
}

void setupSplashDI() {
  getIt.registerFactory<SplashBloc>(
    () => SplashBloc(
      getIt<OnboardingRepository>(),
      getIt<AuthRepository>(),
      getIt<LearningRepository>(),
    ),
  );
}

void setupGamificationDI() {
  getIt.registerLazySingleton<GamificationService>(
    () => GamificationService(getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<StreakService>(
    () => StreakService(getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<AchievementService>(
    () => AchievementService(getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<StreakReminderService>(
    () => StreakReminderService(),
  );
  // lazySingleton — один і той же екземпляр у BlocProvider та getIt<>() в initState
  getIt.registerLazySingleton<GamificationBloc>(
    () => GamificationBloc(
      getIt<GamificationService>(),
      getIt<StreakService>(),
      getIt<AchievementService>(),
      getIt<StreakReminderService>(),
    ),
  );
}

void setupLearningDI() {
  getIt.registerLazySingleton<LearningRemoteDataSource>(
    () => LearningRemoteDataSourceImpl(getIt<supabase.SupabaseClient>()),
  );
  getIt.registerLazySingleton<LearningRepository>(
    () => LearningRepositoryImpl(
      getIt<AppDatabase>(),
      getIt<LearningRemoteDataSource>(),
      getIt<NetworkInfo>(),
      getIt<SharedPreferences>(),
      getIt<supabase.SupabaseClient>(),
    ),
  );
  getIt.registerLazySingleton<GetCoursesByTrackUseCase>(
    () => GetCoursesByTrackUseCase(getIt<LearningRepository>()),
  );
  getIt.registerLazySingleton<GetLessonsByCourseUseCase>(
    () => GetLessonsByCourseUseCase(getIt<LearningRepository>()),
  );
  getIt.registerLazySingleton<CompleteLessonUseCase>(
    () => CompleteLessonUseCase(getIt<LearningRepository>()),
  );
  getIt.registerLazySingleton<DownloadCourseOfflineUseCase>(
    () => DownloadCourseOfflineUseCase(getIt<LearningRepository>()),
  );
  getIt.registerLazySingleton<GetNextLessonUseCase>(
    () => GetNextLessonUseCase(getIt<LearningRepository>()),
  );

  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(
      getIt<GetCoursesByTrackUseCase>(),
      getIt<GetNextLessonUseCase>(),
      getIt<GetTrackUseCase>(),
      getIt<DownloadCourseOfflineUseCase>(),
      getIt<GamificationService>(),
      getIt<StreakService>(),
    ),
  );

  getIt.registerFactory<CourseDetailBloc>(
    () => CourseDetailBloc(
      getIt<GetLessonsByCourseUseCase>(),
      getIt<CompleteLessonUseCase>(),
      getIt<LearningRepository>(),
    ),
  );
}

void setupHomeDI() {
  // Covered by setupLearningDI
}

void setupQuizDI() {
  getIt.registerLazySingleton<QuizRepository>(
    () => QuizRepository(getIt<AppDatabase>()),
  );
  getIt.registerFactory<QuizBloc>(
    () => QuizBloc(getIt<QuizRepository>(), getIt<ProgressDao>()),
  );
}

void setupAiChatDI() {}

void setupProfileDI() {}
