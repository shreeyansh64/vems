part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, success, error }

class ProfileState {
  final ProfileStatus status;
  final String? error;

  ProfileState._({required this.status, this.error});

  factory ProfileState.initial() => ProfileState._(status: ProfileStatus.initial);

  ProfileState copyWith({ProfileStatus? status, String? error}) {
    return ProfileState._(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}