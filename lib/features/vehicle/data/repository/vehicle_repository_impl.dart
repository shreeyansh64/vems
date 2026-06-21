import 'package:vems/features/vehicle/data/data_source/vehicle_remote.dart';
import 'package:vems/features/vehicle/domain/model/vehicle_response.dart';
import 'package:vems/features/vehicle/domain/repository/vehicle_repository.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleRemote vehicleRemote;

  VehicleRepositoryImpl({required this.vehicleRemote});
  @override
  Future<VehicleResponse> submitVehicle({
    required String ownerName,
    required String vehicleNumber,
    required String vehicleType,
    required String vehicleModel,
    required String vehicleColor,
    required String rcNumber,
  }) {
    return vehicleRemote.submitVehicle(
      ownerName: ownerName,
      vehicleNumber: vehicleNumber,
      vehicleType: vehicleType,
      vehicleModel: vehicleModel,
      vehicleColor: vehicleColor,
      rcNumber: rcNumber,
    );
  }
}
