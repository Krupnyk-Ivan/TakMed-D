import '../../domain/entities/profile_entity.dart';

/// Data-модель профілю (мапиться з/у Supabase).
class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.email,
    required super.name,
    super.avatarUrl,
    super.track,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] as String? ?? '',
      email: map['email'] as String? ?? '',
      name: map['name'] as String? ?? '',
      avatarUrl: map['avatar_url'] as String?,
      track: map['track'] as String?,
    );
  }

  factory ProfileModel.fromEntity(ProfileEntity e) {
    return ProfileModel(
      id: e.id,
      email: e.email,
      name: e.name,
      avatarUrl: e.avatarUrl,
      track: e.track,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'name': name,
        'avatar_url': avatarUrl,
        'track': track,
      };
}
