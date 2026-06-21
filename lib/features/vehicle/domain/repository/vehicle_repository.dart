import 'package:vems/features/vehicle/domain/model/vehicle_response.dart';

abstract class VehicleRepository {
  Future<VehicleResponse> submitVehicle({
    required String ownerName,
    required String vehicleNumber,
    required String vehicleType,
    required String vehicleModel,
    required String vehicleColor,
    required String rcNumber
  });
}
