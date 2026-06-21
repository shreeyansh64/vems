import 'package:vems/features/auth/data/data_source/register_remote.dart';
import 'package:vems/features/auth/domain/repository/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterRemote registerRemote;
  RegisterRepositoryImpl({required this.registerRemote});

  @override
  Future<String> getOtp(String email) {
    return registerRemote.getOtp(email);
  }

  @override
  Future<String> setPassword(String email, String password) {
    return registerRemote.setPassword(email, password);
  }
  
  @override
  Future<String> verifyOtp(String email, String otp) {
    return registerRemote.verifyOtp(email, otp);
  }
  
}