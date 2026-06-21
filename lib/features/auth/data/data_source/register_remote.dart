import 'package:dio/dio.dart';

class RegisterRemote {
  final Dio dio;
  RegisterRemote({required this.dio});

  Future<String> getOtp(String email) async {
    var response = await dio.post(
      '/api/auth/register/',
      data: {'email': email},
    );
    return response.data['message'];
  }

  Future<String> verifyOtp(String email, String otp) async {
    var response = await dio.post(
      '/api/auth/verify-otp/',
      data: {'email': email, 'otp': otp},
    );
    return response.data['message'];
  }

  Future<String> setPassword(
    String email,
    String password,
    String confirmPassword,
  ) async {
    var response = await dio.post(
      '/api/auth/set-password/',
      data: {
        'email': email,
        'password': password,
        'confirm_password': confirmPassword,
      },
    );
    return response.data['message'];
  }
}
