import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vems/features/vehicle/domain/repository/vehicle_repository.dart';

part 'vehicle_event.dart';
part 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleRepository vehicleRepository;

  VehicleBloc({required this.vehicleRepository})
    : super(VehicleState.initial()) {
    on<SubmitVehicleEvent>(onSubmitVehicleEvent);
  }

  Future onSubmitVehicleEvent(
    SubmitVehicleEvent event,
    Emitter<VehicleState> emit,
  ) async {
    emit(state.copyWith(status: VehicleStatus.loading));
    try {
      var response = await vehicleRepository.submitVehicle(
        ownerName: event.ownerName,
        vehicleNumber: event.vehicleNumber,
        vehicleType: event.vehicleType,
        vehicleModel: event.vehicleModel,
        vehicleColor: event.vehicleColor,
        rcNumber: event.rcNumber,
      );
      emit(state.copyWith(status: VehicleStatus.success, id: response.id));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), status: VehicleStatus.error));
    }
  }
}
