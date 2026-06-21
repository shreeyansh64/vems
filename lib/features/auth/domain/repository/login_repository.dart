abstract class LoginRepository {
  Future<void> requestLogin(String email, String password);
}