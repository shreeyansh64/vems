import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vems/features/auth/domain/repository/login_repository.dart';


part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState>{
   final LoginRepository loginRepository;

  LoginBloc({required this.loginRepository}) : super(LoginState.initial()){
    on<RequestLoginEvent>(onRequestLoginEvent);
  }

  Future<void> onRequestLoginEvent(LoginEvent event, Emmiter<LoginState> emit)async{
    
  }
}