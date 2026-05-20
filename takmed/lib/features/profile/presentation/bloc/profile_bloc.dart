import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/database/daos/lesson_dao.dart';
import '../../../../core/database/daos/quiz_attempt_dao.dart';
import '../../../gamification/data/services/gamification_service.dart';
import '../../../gamification/data/services/streak_service.dart';
import '../../../onboarding/domain/entities/user_track.dart';
import '../../../onboarding/domain/usecases/save_track_use_case.dart';
import '../../domain/usecases/get_profile_use_case.dart';
import '../../domain/usecases/update_profile_use_case.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(
    this._getProfile,
    this._updateProfile,
    this._lessonDao,
    this._attemptDao,
    this._gamification,
    this._streak,
    this._supabaseClient,
    this._saveTrack,
  ) : super(const ProfileState()) {
    on<ProfileLoaded>(_onLoaded);
    on<ProfileNameChanged>(_onNameChanged);
    on<ProfileAvatarUrlChanged>(_onAvatarChanged);
    on<ProfileTrackChanged>(_onTrackChanged);
    on<ProfileSaveRequested>(_onSaveRequested);
    on<ProfileStatsRequested>(_onStatsRequested);
  }

  final GetProfileUseCase _getProfile;
  final UpdateProfileUseCase _updateProfile;
  final LessonDao _lessonDao;
  final QuizAttemptDao _attemptDao;
  final GamificationService _gamification;
  final StreakService _streak;
  final SupabaseClient _supabaseClient;
  final SaveTrackUseCase _saveTrack;

  Future<void> _onLoaded(ProfileLoaded event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading, clearError: true));

    final result = await _getProfile();
    final loaded = result.fold(
      (failure) {
        emit(state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        ));
        return false;
      },
      (profile) {
        emit(state.copyWith(
          status: ProfileStatus.ready,
          profile: profile,
          draft: profile,
        ));
        return true;
      },
    );

    if (loaded) add(const ProfileStatsRequested());
  }

  Future<void> _onStatsRequested(
    ProfileStatsRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final userId = _supabaseClient.auth.currentUser?.id ?? '';
    final completedLessons = await _lessonDao.countAllCompletedLessons();
    final quizAttempts = await _attemptDao.countAttemptsByUser(userId);
    final totalXp = _gamification.getTotalXp();
    final currentStreak = _streak.getCurrentStreak();
    final bestStreak = _streak.getBestStreak();

    emit(state.copyWith(
      stats: ProfileStats(
        completedLessons: completedLessons,
        quizAttempts: quizAttempts,
        totalXp: totalXp,
        currentStreak: currentStreak,
        bestStreak: bestStreak,
      ),
    ));
  }

  void _onNameChanged(ProfileNameChanged event, Emitter<ProfileState> emit) {
    final draft = state.draft;
    if (draft == null) return;
    emit(state.copyWith(
      draft: draft.copyWith(name: event.name),
      savedJustNow: false,
    ));
  }

  void _onAvatarChanged(
    ProfileAvatarUrlChanged event,
    Emitter<ProfileState> emit,
  ) {
    final draft = state.draft;
    if (draft == null) return;
    final trimmed = event.url.trim();
    emit(state.copyWith(
      draft: draft.copyWith(
        avatarUrl: trimmed.isEmpty ? null : trimmed,
        clearAvatar: trimmed.isEmpty,
      ),
      savedJustNow: false,
    ));
  }

  void _onTrackChanged(ProfileTrackChanged event, Emitter<ProfileState> emit) {
    final draft = state.draft;
    if (draft == null) return;
    emit(state.copyWith(
      draft: draft.copyWith(track: event.track),
      savedJustNow: false,
    ));
  }

  Future<void> _onSaveRequested(
    ProfileSaveRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null) return;

    if (draft.name.trim().isEmpty) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: "Ім'я не може бути порожнім",
      ));
      return;
    }

    emit(state.copyWith(status: ProfileStatus.saving, clearError: true));
    final result = await _updateProfile(draft);
    await result.fold(
      (failure) async => emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: failure.message,
      )),
      (profile) async {
        // Зберігаємо трек локально щоб HomeBloc підхопив нові курси
        if ((draft.track ?? '').isNotEmpty) {
          final track = UserTrack.values.firstWhere(
            (t) => t.name == draft.track,
            orElse: () => UserTrack.civilian,
          );
          await _saveTrack(track);
        }
        emit(state.copyWith(
          status: ProfileStatus.ready,
          profile: profile,
          draft: profile,
          savedJustNow: true,
          clearError: true,
        ));
      },
    );
  }
}
