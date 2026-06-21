import 'package:vems/features/auth/domain/model/login_response.dart';

abstract class LoginRepository {
  Future<LoginResponse> requestLogin(String email, String password);
}