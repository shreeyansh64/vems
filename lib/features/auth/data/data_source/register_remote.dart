import 'package:dio/dio.dart';

class RegisterRemote {
  final Dio dio;
  RegisterRemote({required this.dio});

  Future<String> GetOTP(String email) async {
    var response = await dio.post('/api/auth/register/', data: {'email': email});
    return response.data['message'];
  }
}