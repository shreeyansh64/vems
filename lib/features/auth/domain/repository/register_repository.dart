abstract class RegisterRepository {
  Future<String> getOtp(String email);
  Future<String> verifyOtp(String email, String otp);
  Future<String> setPassword(String email, String password, String confirmPassword);
}