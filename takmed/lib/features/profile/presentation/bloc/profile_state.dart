import 'package:equatable/equatable.dart';
import '../../domain/entities/profile_entity.dart';

enum ProfileStatus { initial, loading, ready, saving, error }

/// Cтатистика для відображення на сторінці профілю.
class ProfileStats extends Equatable {
  const ProfileStats({
    this.completedLessons = 0,
    this.quizAttempts = 0,
    this.totalXp = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
  });

  final int completedLessons;
  final int quizAttempts;
  final int totalXp;
  final int currentStreak;
  final int bestStreak;

  @override
  List<Object?> get props =>
      [completedLessons, quizAttempts, totalXp, currentStreak, bestStreak];
}

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.draft,
    this.stats = const ProfileStats(),
    this.errorMessage,
    this.savedJustNow = false,
  });

  final ProfileStatus status;

  /// Останнє підтверджене сервером значення.
  final ProfileEntity? profile;

  /// Чернетка (для редагування полів перед натисканням "Зберегти").
  final ProfileEntity? draft;

  final ProfileStats stats;
  final String? errorMessage;
  final bool savedJustNow;

  bool get hasUnsavedChanges {
    if (profile == null || draft == null) return false;
    return profile != draft;
  }

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileEntity? profile,
    ProfileEntity? draft,
    ProfileStats? stats,
    String? errorMessage,
    bool clearError = false,
    bool? savedJustNow,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      draft: draft ?? this.draft,
      stats: stats ?? this.stats,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      savedJustNow: savedJustNow ?? this.savedJustNow,
    );
  }

  @override
  List<Object?> get props =>
      [status, profile, draft, stats, errorMessage, savedJustNow];
}
