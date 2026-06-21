part of 'vehicle_bloc.dart';

enum VehicleStatus { initial, loading, success, error }

class VehicleState {
  final VehicleStatus status;
  final int? id;
  final String? error;

  VehicleState._({required this.status, this.id , this.error});

  factory VehicleState.initial() => VehicleState._(status: VehicleStatus.initial);

  VehicleState copyWith({VehicleStatus? status, int? id, String? error}) {
    return VehicleState._(
      status: status ?? this.status,
      id: id ?? this.id,
      error: error ?? this.error,
    );
  }
}