import 'package:dio/dio.dart';
import 'package:vems/features/auth/domain/model/login_response.dart';

class LoginRemote {
  final Dio dio;

  LoginRemote({required this.dio});

  Future<LoginResponse> requestLogin(String email, String password) async {
    try {
      var response = await dio.post(
        '/api/auth/login/',
        data: {'email': email, 'password': password},
      );
      return LoginResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.response?.data["message"] ?? e.response?.data["email"] ?? "Something went wrong";
    }
  }
}
