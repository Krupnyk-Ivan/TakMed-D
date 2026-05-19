import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:takmed/features/auth/domain/repositories/auth_repository.dart';
import 'package:takmed/features/learning/domain/entities/course_entity.dart';
import 'package:takmed/features/learning/domain/entities/lesson_entity.dart';
import 'package:takmed/features/learning/domain/repositories/learning_repository.dart';
import 'package:takmed/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:takmed/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:takmed/features/splash/presentation/bloc/splash_event.dart';
import 'package:takmed/features/splash/presentation/bloc/splash_state.dart';
import 'package:takmed/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

@GenerateNiceMocks([
  MockSpec<OnboardingRepository>(),
  MockSpec<AuthRepository>(),
])
import 'splash_bloc_test.mocks.dart';

void main() {
  late MockOnboardingRepository mockOnboardingRepository;
  late MockAuthRepository mockAuthRepository;
  late LearningRepository learningRepository;

  setUp(() {
    mockOnboardingRepository = MockOnboardingRepository();
    mockAuthRepository = MockAuthRepository();
    learningRepository = _NoopLearningRepository();
  });

  SplashBloc createBloc() {
    return SplashBloc(
      mockOnboardingRepository,
      mockAuthRepository,
      learningRepository,
    );
  }

  group('SplashBloc — початковий стан', () {
    test('початковий стан — SplashStatus.initial', () {
      final bloc = createBloc();
      expect(bloc.state.status, SplashStatus.initial);
      bloc.close();
    });
  });

  group('SplashBloc — навігація', () {
    blocTest<SplashBloc, SplashState>(
      'немає сесії → navigateToLogin (онбординг не перевіряється)',
      build: () {
        when(
          mockAuthRepository.isAuthenticated(),
        ).thenAnswer((_) async => false);
        return createBloc();
      },
      act: (bloc) => bloc.add(const SplashStarted()),
      wait: const Duration(seconds: 2),
      expect: () => [
        isA<SplashState>().having((s) => s.status, 'status', SplashStatus.checking),
        isA<SplashState>().having((s) => s.status, 'status', SplashStatus.navigateToLogin),
      ],
      verify: (_) {
        verify(mockAuthRepository.isAuthenticated()).called(1);
        verifyNever(mockOnboardingRepository.isOnboardingCompleted());
      },
    );

    blocTest<SplashBloc, SplashState>(
      'є сесія + онбординг пройдений → navigateToHome',
      build: () {
        when(mockAuthRepository.isAuthenticated()).thenAnswer((_) async => true);
        when(mockAuthRepository.getCurrentUser()).thenAnswer((_) async => null);
        when(mockOnboardingRepository.isOnboardingCompleted())
            .thenAnswer((_) async => true);
        return createBloc();
      },
      act: (bloc) => bloc.add(const SplashStarted()),
      wait: const Duration(seconds: 2),
      expect: () => [
        isA<SplashState>().having((s) => s.status, 'status', SplashStatus.checking),
        isA<SplashState>().having((s) => s.status, 'status', SplashStatus.navigateToHome),
      ],
    );

    blocTest<SplashBloc, SplashState>(
      'є сесія + онбординг НЕ пройдений → navigateToOnboarding',
      build: () {
        when(mockAuthRepository.isAuthenticated()).thenAnswer((_) async => true);
        when(mockAuthRepository.getCurrentUser()).thenAnswer((_) async => null);
        when(mockOnboardingRepository.isOnboardingCompleted())
            .thenAnswer((_) async => false);
        return createBloc();
      },
      act: (bloc) => bloc.add(const SplashStarted()),
      wait: const Duration(seconds: 2),
      expect: () => [
        isA<SplashState>().having((s) => s.status, 'status', SplashStatus.checking),
        isA<SplashState>().having((s) => s.status, 'status', SplashStatus.navigateToOnboarding),
      ],
      verify: (_) {
        verify(mockAuthRepository.isAuthenticated()).called(1);
        verify(mockOnboardingRepository.isOnboardingCompleted()).called(1);
      },
    );
  });
}

class _NoopLearningRepository implements LearningRepository {
  @override
  Future<Either<Failure, Unit>> completeLesson(int lessonId, int score) async {
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> downloadCourseOffline(int courseId) async {
    return const Right(unit);
  }

  @override
  Future<Either<Failure, CourseEntity?>> getCourseById(int id) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, LessonEntity?>> getNextLesson() async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, LessonEntity?>> getNextLessonInCourse(
    int courseId,
  ) async {
    return const Right(null);
  }

  @override
  Future<void> seedIfEmpty() async {}

  @override
  Future<Either<Failure, Unit>> syncWithServer() async {
    return const Right(unit);
  }

  @override
  Stream<List<CourseEntity>> watchCoursesByTrack(String track) {
    return const Stream<List<CourseEntity>>.empty();
  }

  @override
  Stream<List<LessonEntity>> watchLessonsByCourse(int courseId) {
    return const Stream<List<LessonEntity>>.empty();
  }
}
