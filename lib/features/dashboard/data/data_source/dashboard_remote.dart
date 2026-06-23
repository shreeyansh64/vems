import 'package:dio/dio.dart';
import 'package:vems/features/dashboard/domain/model/dashboard_registration_model.dart';
import 'package:vems/features/dashboard/domain/model/profile_model.dart';

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

  Future<DashboardRegistrationModel> getRegistration() async {
    try {
      final response = await dio.get('/api/registrations/');
      return DashboardRegistrationModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.response?.data["message"] ?? "Something went wrong";
    }
  }
}