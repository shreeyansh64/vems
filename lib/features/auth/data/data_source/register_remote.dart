import 'package:dio/dio.dart';

class RegisterRemote {
  final Dio dio;
  RegisterRemote({required this.dio});

  Future<String> getOtp(String email) async {
    var response = await dio.post('/api/auth/register/', data: {'email': email});
    return response.data['message'];
  }

  Future<String> verifyOtp(String email, String otp) async {
    var response = await dio.post('/api/auth/register/', data: {'email': email});
    return response.data['message'];
  }

  Future<String> setPassword(String email,  String password) async {
    var response = await dio.post('/api/auth/register/', data: {'email': email});
    return response.data['message'];
  }
}