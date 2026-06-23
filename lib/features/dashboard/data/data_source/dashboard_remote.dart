import 'package:dio/dio.dart';
import 'package:vems/features/dashboard/domain/model/dashboard_registration_model.dart';
import 'package:vems/features/dashboard/domain/model/profile_model.dart';
import 'package:vems/features/dashboard/domain/model/vehicle_model.dart';

class DashboardRemote {
  final Dio dio;
  DashboardRemote({required this.dio});

  Future<ProfileModel> getProfile() async {
    try {
      final response = await dio.get('/api/users/profile/');
      return ProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Something went wrong';
    }
  }

  Future<List<DashboardRegistrationModel>> getRegistration() async {
    try {
      final response = await dio.get('/api/registrations/');
      final list = response.data as List<dynamic>;
      return list
          .map(
            (e) =>
                DashboardRegistrationModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      throw e.response?.data["message"] ?? "Something went wrong";
    }
  }

  Future<List<VehicleModel>> getVehicles() async {
    try {
      final response = await dio.get('/api/vehicles/');
      final list = response.data as List<dynamic>;
      return list
          .map((e) => VehicleModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Something went wrong';
    }
  }
}
