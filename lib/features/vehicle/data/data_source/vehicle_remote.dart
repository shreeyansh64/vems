import 'package:dio/dio.dart';
import 'package:vems/features/vehicle/domain/model/vehicle_response.dart';

class VehicleRemote {
  final Dio dio;

  VehicleRemote({required this.dio});

  Future<VehicleResponse> submitVehicle({
    required String ownerName,
    required String vehicleNumber,
    required String vehicleType,
    required String vehicleModel,
    required String vehicleColor,
    required String rcNumber,
  }) async {
    var response = await dio.post(
      '/api/vehicles/',
      data: {
        "owner_name": ownerName,
        "vehicle_number": vehicleNumber,
        "vehicle_type": vehicleType,
        "vehicle_model": vehicleModel,
        "vehicle_color": vehicleColor,
        "rc_number": rcNumber,
      },
    );
    return VehicleResponse.fromJson(response as Map<String, dynamic>);
  }
}
