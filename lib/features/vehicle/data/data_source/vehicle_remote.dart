import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
    try {
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
      return VehicleResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint("STATUS: ${e.response!.statusCode}");
        debugPrint("DATA: ${e.response!.data}");
      } else {
        debugPrint("NO RESPONSE FROM SERVER");
        debugPrint("ERROR: ${e.message}");
      }
      throw e.response?.data["message"] ??
          e.response?.data["vehicle_number"] ??
          e.response?.data["vehicle_type"] ??
          e.response?.data["<field>"] ??
          "Something went wrong";
    }
  }
}
