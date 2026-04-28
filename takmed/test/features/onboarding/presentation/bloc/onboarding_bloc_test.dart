import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:takmed/core/errors/failures.dart';
import 'package:takmed/features/onboarding/domain/entities/user_track.dart';
import 'package:takmed/features/onboarding/domain/usecases/save_track_use_case.dart';
import 'package:takmed/features/onboarding/domain/usecases/get_track_use_case.dart';
import 'package:takmed/features/onboarding/domain/usecases/complete_onboarding_use_case.dart';
import 'package:takmed/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:takmed/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:takmed/features/onboarding/presentation/bloc/onboarding_state.dart';

@GenerateNiceMocks([
  MockSpec<SaveTrackUseCase>(),
  MockSpec<GetTrackUseCase>(),
  MockSpec<CompleteOnboardingUseCase>(),
])
import 'onboarding_bloc_test.mocks.dart';

void main() {
  late MockSaveTrackUseCase mockSaveTrackUseCase;
  late MockGetTrackUseCase mockGetTrackUseCase;
  late MockCompleteOnboardingUseCase mockCompleteOnboardingUseCase;

  setUp(() {
    mockSaveTrackUseCase = MockSaveTrackUseCase();
    mockGetTrackUseCase = MockGetTrackUseCase();
    mockCompleteOnboardingUseCase = MockCompleteOnboardingUseCase();
  });

  OnboardingBloc createBloc() {
    return OnboardingBloc(
      mockSaveTrackUseCase,
      mockGetTrackUseCase,
      mockCompleteOnboardingUseCase,
    );
  }

  group('OnboardingBloc — початковий стан', () {
    test('початковий стан: page 0, no track, initial', () {
      final bloc = createBloc();
      expect(bloc.state.currentPage, 0);
      expect(bloc.state.selectedTrack, isNull);
      expect(bloc.state.status, OnboardingStatus.initial);
      expect(bloc.state.canComplete, isFalse);
      bloc.close();
    });
  });

  group('OnboardingBloc — навігація сторінок', () {
    blocTest<OnboardingBloc, OnboardingState>(
      'OnboardingPageChanged оновлює currentPage',
      build: createBloc,
      act: (bloc) => bloc.add(const OnboardingPageChanged(1)),
      expect: () => [
        isA<OnboardingState>()
            .having((s) => s.currentPage, 'currentPage', 1),
      ],
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'isLastPage == true коли currentPage == 2',
      build: createBloc,
      act: (bloc) => bloc.add(const OnboardingPageChanged(2)),
      expect: () => [
        isA<OnboardingState>()
            .having((s) => s.isLastPage, 'isLastPage', true),
      ],
    );
  });

  group('OnboardingBloc — вибір треку', () {
    blocTest<OnboardingBloc, OnboardingState>(
      'вибір military → зберігається та не скидається',
      build: () {
        when(mockSaveTrackUseCase(UserTrack.military))
            .thenAnswer((_) async => const Right(unit));
        return createBloc();
      },
      act: (bloc) =>
          bloc.add(const OnboardingTrackSelected(UserTrack.military)),
      expect: () => [
        // loading з вибраним треком
        isA<OnboardingState>()
            .having(
                (s) => s.selectedTrack, 'selectedTrack', UserTrack.military)
            .having((s) => s.status, 'status', OnboardingStatus.loading),
        // saved
        isA<OnboardingState>()
            .having(
                (s) => s.selectedTrack, 'selectedTrack', UserTrack.military)
            .having((s) => s.status, 'status', OnboardingStatus.initial),
      ],
      verify: (_) {
        verify(mockSaveTrackUseCase(UserTrack.military)).called(1);
      },
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'вибір civilian → зберігається',
      build: () {
        when(mockSaveTrackUseCase(UserTrack.civilian))
            .thenAnswer((_) async => const Right(unit));
        return createBloc();
      },
      act: (bloc) =>
          bloc.add(const OnboardingTrackSelected(UserTrack.civilian)),
      expect: () => [
        isA<OnboardingState>()
            .having(
                (s) => s.selectedTrack, 'selectedTrack', UserTrack.civilian)
            .having((s) => s.status, 'status', OnboardingStatus.loading),
        isA<OnboardingState>()
            .having(
                (s) => s.selectedTrack, 'selectedTrack', UserTrack.civilian)
            .having((s) => s.status, 'status', OnboardingStatus.initial),
      ],
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'помилка збереження треку → error',
      build: () {
        when(mockSaveTrackUseCase(any))
            .thenAnswer((_) async => const Left(CacheFailure('Cache error')));
        return createBloc();
      },
      act: (bloc) =>
          bloc.add(const OnboardingTrackSelected(UserTrack.military)),
      expect: () => [
        isA<OnboardingState>()
            .having((s) => s.status, 'status', OnboardingStatus.loading),
        isA<OnboardingState>()
            .having((s) => s.status, 'status', OnboardingStatus.error)
            .having(
                (s) => s.errorMessage, 'errorMessage', 'Cache error'),
      ],
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'canComplete == true після вибору треку',
      build: () {
        when(mockSaveTrackUseCase(any))
            .thenAnswer((_) async => const Right(unit));
        return createBloc();
      },
      act: (bloc) =>
          bloc.add(const OnboardingTrackSelected(UserTrack.military)),
      expect: () => [
        isA<OnboardingState>().having((s) => s.canComplete, 'canComplete', true),
        isA<OnboardingState>().having((s) => s.canComplete, 'canComplete', true),
      ],
    );
  });

  group('OnboardingBloc — відновлення треку', () {
    blocTest<OnboardingBloc, OnboardingState>(
      'OnboardingStarted відновлює збережений трек',
      build: () {
        when(mockGetTrackUseCase())
            .thenAnswer((_) async => const Right(UserTrack.military));
        return createBloc();
      },
      act: (bloc) => bloc.add(const OnboardingStarted()),
      expect: () => [
        isA<OnboardingState>()
            .having(
                (s) => s.selectedTrack, 'selectedTrack', UserTrack.military),
      ],
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'OnboardingStarted без збереженого треку — нічого не змінює',
      build: () {
        when(mockGetTrackUseCase())
            .thenAnswer((_) async => const Right(null));
        return createBloc();
      },
      act: (bloc) => bloc.add(const OnboardingStarted()),
      expect: () => <OnboardingState>[],
    );
  });

  group('OnboardingBloc — завершення', () {
    blocTest<OnboardingBloc, OnboardingState>(
      'OnboardingCompleted з треком → completed',
      build: () {
        when(mockCompleteOnboardingUseCase())
            .thenAnswer((_) async => const Right(unit));
        return createBloc();
      },
      seed: () => const OnboardingState(selectedTrack: UserTrack.civilian),
      act: (bloc) => bloc.add(const OnboardingCompleted()),
      expect: () => [
        isA<OnboardingState>()
            .having((s) => s.status, 'status', OnboardingStatus.loading),
        isA<OnboardingState>()
            .having((s) => s.status, 'status', OnboardingStatus.completed),
      ],
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'OnboardingCompleted без треку → ігнорується',
      build: createBloc,
      act: (bloc) => bloc.add(const OnboardingCompleted()),
      expect: () => <OnboardingState>[],
      verify: (_) {
        verifyNever(mockCompleteOnboardingUseCase());
      },
    );

    blocTest<OnboardingBloc, OnboardingState>(
      'OnboardingCompleted помилка → error',
      build: () {
        when(mockCompleteOnboardingUseCase())
            .thenAnswer((_) async => const Left(CacheFailure('Fail')));
        return createBloc();
      },
      seed: () => const OnboardingState(selectedTrack: UserTrack.military),
      act: (bloc) => bloc.add(const OnboardingCompleted()),
      expect: () => [
        isA<OnboardingState>()
            .having((s) => s.status, 'status', OnboardingStatus.loading),
        isA<OnboardingState>()
            .having((s) => s.status, 'status', OnboardingStatus.error)
            .having((s) => s.errorMessage, 'errorMessage', 'Fail'),
      ],
    );
  });
}
