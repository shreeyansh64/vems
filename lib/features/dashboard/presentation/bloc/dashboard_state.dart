part of 'dashboard_bloc.dart';

enum DashboardStatus { initial, loading, success, error }

class DashboardState {
  final DashboardStatus status;
  final ProfileModel? profile;
  final List<DashboardRegistrationModel>? registration;
  final String? errorMessage;

  DashboardState._({
    required this.status,
    this.profile,
    this.registration,
    this.errorMessage,
  });

  factory DashboardState.initial() =>
      DashboardState._(status: DashboardStatus.initial);

  DashboardState copyWith({
    DashboardStatus? status,
    ProfileModel? profile,
    List<DashboardRegistrationModel>? registration,
    String? errorMessage,
  }) {
    return DashboardState._(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      registration: registration ?? this.registration,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}