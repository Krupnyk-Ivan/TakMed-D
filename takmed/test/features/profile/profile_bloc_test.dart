import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:takmed/core/database/app_database.dart';
import 'package:takmed/core/errors/failures.dart';
import 'package:takmed/features/gamification/data/services/gamification_service.dart';
import 'package:takmed/features/gamification/data/services/streak_service.dart';
import 'package:takmed/features/profile/domain/entities/profile_entity.dart';
import 'package:takmed/features/profile/domain/usecases/get_profile_use_case.dart';
import 'package:takmed/features/profile/domain/usecases/update_profile_use_case.dart';
import 'package:takmed/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:takmed/features/profile/presentation/bloc/profile_event.dart';
import 'package:takmed/features/profile/presentation/bloc/profile_state.dart';

import 'profile_bloc_test.mocks.dart';

@GenerateMocks([
  GetProfileUseCase,
  UpdateProfileUseCase,
  SupabaseClient,
  GoTrueClient,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockGetProfileUseCase mockGetProfile;
  late MockUpdateProfileUseCase mockUpdateProfile;
  late MockSupabaseClient mockSupabase;
  late MockGoTrueClient mockAuth;
  late AppDatabase db;
  late GamificationService gamification;
  late StreakService streak;

  const baseProfile = ProfileEntity(
    id: 'user_123',
    email: 'test@example.com',
    name: 'Ivan',
    avatarUrl: null,
    track: 'military',
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    mockGetProfile = MockGetProfileUseCase();
    mockUpdateProfile = MockUpdateProfileUseCase();
    mockSupabase = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    when(mockSupabase.auth).thenReturn(mockAuth);
    when(mockAuth.currentUser).thenReturn(null);

    db = AppDatabase.forTesting(NativeDatabase.memory());
    gamification = GamificationService(prefs);
    streak = StreakService(prefs);
  });

  tearDown(() async {
    await db.close();
  });

  ProfileBloc buildBloc() => ProfileBloc(
        mockGetProfile,
        mockUpdateProfile,
        db.lessonDao,
        db.quizAttemptDao,
        gamification,
        streak,
        mockSupabase,
      );

  group('ProfileLoaded', () {
    blocTest<ProfileBloc, ProfileState>(
      'переходить у ready з profile і draft при успіху',
      build: () {
        when(mockGetProfile()).thenAnswer((_) async => const Right(baseProfile));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const ProfileLoaded()),
      skip: 1, // пропустити loading
      expect: () => [
        isA<ProfileState>()
            .having((s) => s.status, 'status', ProfileStatus.ready)
            .having((s) => s.profile, 'profile', baseProfile)
            .having((s) => s.draft, 'draft', baseProfile)
            .having((s) => s.stats.completedLessons, 'lessons', 0),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'переходить у error при невдачі',
      build: () {
        when(mockGetProfile()).thenAnswer(
          (_) async => const Left(AuthFailure('Немає сесії')),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(const ProfileLoaded()),
      skip: 1,
      expect: () => [
        isA<ProfileState>()
            .having((s) => s.status, 'status', ProfileStatus.error)
            .having((s) => s.errorMessage, 'errorMessage', 'Немає сесії'),
      ],
    );
  });

  group('Field changes', () {
    blocTest<ProfileBloc, ProfileState>(
      'ProfileNameChanged оновлює draft.name але не profile',
      build: () {
        when(mockGetProfile()).thenAnswer((_) async => const Right(baseProfile));
        return buildBloc();
      },
      seed: () => const ProfileState(
        status: ProfileStatus.ready,
        profile: baseProfile,
        draft: baseProfile,
      ),
      act: (bloc) => bloc.add(const ProfileNameChanged('Petro')),
      expect: () => [
        isA<ProfileState>()
            .having((s) => s.draft?.name, 'draft.name', 'Petro')
            .having((s) => s.profile?.name, 'profile.name', 'Ivan')
            .having((s) => s.hasUnsavedChanges, 'unsaved', true),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'ProfileAvatarUrlChanged з порожнім URL обнуляє avatarUrl',
      build: buildBloc,
      seed: () => const ProfileState(
        status: ProfileStatus.ready,
        profile: ProfileEntity(
          id: 'u1', email: 'e', name: 'I', avatarUrl: 'http://x.png',
        ),
        draft: ProfileEntity(
          id: 'u1', email: 'e', name: 'I', avatarUrl: 'http://x.png',
        ),
      ),
      act: (bloc) => bloc.add(const ProfileAvatarUrlChanged('   ')),
      expect: () => [
        isA<ProfileState>().having((s) => s.draft?.avatarUrl, 'avatarUrl', isNull),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'ProfileTrackChanged оновлює трек у draft',
      build: buildBloc,
      seed: () => const ProfileState(
        status: ProfileStatus.ready,
        profile: baseProfile,
        draft: baseProfile,
      ),
      act: (bloc) => bloc.add(const ProfileTrackChanged('civilian')),
      expect: () => [
        isA<ProfileState>().having((s) => s.draft?.track, 'track', 'civilian'),
      ],
    );
  });

  group('ProfileSaveRequested', () {
    blocTest<ProfileBloc, ProfileState>(
      'успішне збереження оновлює profile і ставить savedJustNow=true',
      build: () {
        when(mockUpdateProfile(any)).thenAnswer(
          (inv) async => Right(inv.positionalArguments.first as ProfileEntity),
        );
        return buildBloc();
      },
      seed: () => ProfileState(
        status: ProfileStatus.ready,
        profile: baseProfile,
        draft: baseProfile.copyWith(name: 'Petro'),
      ),
      act: (bloc) => bloc.add(const ProfileSaveRequested()),
      expect: () => [
        isA<ProfileState>().having((s) => s.status, 'status', ProfileStatus.saving),
        isA<ProfileState>()
            .having((s) => s.status, 'status', ProfileStatus.ready)
            .having((s) => s.profile?.name, 'profile.name', 'Petro')
            .having((s) => s.savedJustNow, 'savedJustNow', true),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'порожнє імʼя -> error без виклику updateProfile',
      build: () => buildBloc(),
      seed: () => ProfileState(
        status: ProfileStatus.ready,
        profile: baseProfile,
        draft: baseProfile.copyWith(name: '   '),
      ),
      act: (bloc) => bloc.add(const ProfileSaveRequested()),
      expect: () => [
        isA<ProfileState>()
            .having((s) => s.status, 'status', ProfileStatus.error)
            .having((s) => s.errorMessage, 'errorMessage', "Ім'я не може бути порожнім"),
      ],
      verify: (_) {
        verifyNever(mockUpdateProfile(any));
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'failure при збереженні -> error message',
      build: () {
        when(mockUpdateProfile(any)).thenAnswer(
          (_) async => const Left(UnknownFailure('No internet')),
        );
        return buildBloc();
      },
      seed: () => ProfileState(
        status: ProfileStatus.ready,
        profile: baseProfile,
        draft: baseProfile.copyWith(name: 'Petro'),
      ),
      act: (bloc) => bloc.add(const ProfileSaveRequested()),
      expect: () => [
        isA<ProfileState>().having((s) => s.status, 'status', ProfileStatus.saving),
        isA<ProfileState>()
            .having((s) => s.status, 'status', ProfileStatus.error)
            .having((s) => s.errorMessage, 'errorMessage', 'No internet'),
      ],
    );
  });
}
