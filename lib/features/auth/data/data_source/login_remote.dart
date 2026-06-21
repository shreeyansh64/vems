import 'package:dio/dio.dart';

class LoginRemote {
  final Dio dio;

  LoginRemote({required this.dio});

  Future<void> requestLogin(String email, String password) async {
    var response = await dio.post(
      '/api/auth/login/',
      data: {'email': email, 'password': password},
    );
  }
}
