part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class RequestLogin extends LoginEvent {
  final String email;
  final String password;

  RequestLogin({required this.email, required this.password});
}
