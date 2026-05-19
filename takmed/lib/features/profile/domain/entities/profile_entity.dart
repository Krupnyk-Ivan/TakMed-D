import 'package:equatable/equatable.dart';

/// Доменна сутність профілю користувача.
class ProfileEntity extends Equatable {
  const ProfileEntity({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    this.track,
  });

  final String id;
  final String email;
  final String name;
  final String? avatarUrl;

  /// 'military' | 'civilian' | null (не вибрано)
  final String? track;

  ProfileEntity copyWith({
    String? name,
    String? avatarUrl,
    String? track,
    bool clearAvatar = false,
    bool clearTrack = false,
  }) {
    return ProfileEntity(
      id: id,
      email: email,
      name: name ?? this.name,
      avatarUrl: clearAvatar ? null : (avatarUrl ?? this.avatarUrl),
      track: clearTrack ? null : (track ?? this.track),
    );
  }

  @override
  List<Object?> get props => [id, email, name, avatarUrl, track];
}
