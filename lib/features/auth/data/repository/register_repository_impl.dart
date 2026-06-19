import 'package:vems/features/auth/data/data_source/register_remote.dart';
import 'package:vems/features/auth/domain/repository/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterRemote registerRemote;
  RegisterRepositoryImpl({required this.registerRemote});

  @override
  Future<String> GetOTP(String email) {
    return registerRemote.GetOTP(email);
  }
  
}