part of 'vehicle_bloc.dart';

enum VehicleStatus { initial, loading, success, error }

class VehicleState {
  final VehicleStatus status;
  final int? id;
  final int? user;
  final String? error;

  VehicleState._({required this.status, this.id, this.error, this.user});

  factory VehicleState.initial() =>
      VehicleState._(status: VehicleStatus.initial);

  VehicleState copyWith({
    VehicleStatus? status,
    int? id,
    int? user,
    String? error,
  }) {
    return VehicleState._(
      status: status ?? this.status,
      id: id ?? this.id,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}
