import 'package:vems/features/auth/data/data_source/login_remote.dart';
import 'package:vems/features/auth/domain/repository/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemote loginRemote;
  LoginRepositoryImpl({required this.loginRemote});
  @override
  Future<void> requestLogin(String email, String password) async {
    await loginRemote.requestLogin(email, password);
  }
}
