import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

class ProfileLoaded extends ProfileEvent {
  const ProfileLoaded();
}

class ProfileNameChanged extends ProfileEvent {
  const ProfileNameChanged(this.name);
  final String name;
  @override
  List<Object?> get props => [name];
}

class ProfileAvatarUrlChanged extends ProfileEvent {
  const ProfileAvatarUrlChanged(this.url);
  final String url;
  @override
  List<Object?> get props => [url];
}

class ProfileTrackChanged extends ProfileEvent {
  const ProfileTrackChanged(this.track);
  final String track;
  @override
  List<Object?> get props => [track];
}

class ProfileSaveRequested extends ProfileEvent {
  const ProfileSaveRequested();
}

class ProfileStatsRequested extends ProfileEvent {
  const ProfileStatsRequested();
}
