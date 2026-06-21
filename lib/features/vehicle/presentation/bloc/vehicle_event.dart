part of 'vehicle_bloc.dart';

@immutable
abstract class VehicleEvent {}

class SubmitVehicleEvent extends VehicleEvent {
  final String ownerName;
  final String vehicleNumber;
  final String vehicleType;
  final String vehicleModel;
  final String vehicleColor;
  final String rcNumber;

  SubmitVehicleEvent({
    required this.ownerName,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.rcNumber,
  });
}