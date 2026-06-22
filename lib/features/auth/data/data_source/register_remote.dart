import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class RegisterRemote {
  final Dio dio;
  RegisterRemote({required this.dio});

  Future<String> getOtp(String email) async {
    try {
      var response = await dio.post(
        '/api/auth/register/',
        data: {'email': email},
      );
      return response.data['message'];
    } on DioException catch (e) {
      debugPrint('ERROR: ${e.response?.data}');
      throw e.response?.data["message"] ?? e.response?.data["email"] ?? "Something went wrong";
    }
  }

  Future<String> verifyOtp(String email, String otp) async {
    try {
      var response = await dio.post(
        '/api/auth/verify-otp/',
        data: {'email': email, 'otp': otp},
      );
      return response.data['message'];
    } on DioException catch (e) {
      debugPrint(e.message);
      throw e.response?.data["message"] ?? "Something went wrong";
    }
  }

  Future<String> setPassword(
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      var response = await dio.post(
        '/api/auth/set-password/',
        data: {
          'email': email,
          'password': password,
          'confirm_password': confirmPassword,
        },
      );
      return response.data['message'];
    } on DioException catch (e) {
      throw e.response?.data["message"] ?? "Something went wrong";
    }
  }
}
