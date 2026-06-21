import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vems/features/auth/domain/repository/login_repository.dart';


part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState>{
   final LoginRepository loginRepository;
   final FlutterSecureStorage storage = FlutterSecureStorage();

  LoginBloc({required this.loginRepository}) : super(LoginState.initial()){
    on<RequestLoginEvent>(onRequestLoginEvent);
  }

  Future onRequestLoginEvent(RequestLoginEvent event, Emitter<LoginState> emit)async{
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      var response = await loginRepository.requestLogin(event.email, event.password);
      await storage.write(key: 'access_token', value: response.accessToken);
      await storage.write(key: 'refresh_token', value: response.refreshToken);
      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), status: LoginStatus.error));
    }
  }
}