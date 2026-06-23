part of 'dashboard_bloc.dart';

enum DashboardStatus { initial, loading, success, error }

class DashboardState {
  final DashboardStatus status;
  final ProfileModel? profile;
  final String? errorMessage;

  DashboardState._({
    required this.status,
    this.profile,
    this.errorMessage,
  });

  factory DashboardState.initial() =>
      DashboardState._(status: DashboardStatus.initial);

  DashboardState copyWith({
    DashboardStatus? status,
    ProfileModel? profile,
    String? errorMessage,
  }) {
    return DashboardState._(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}