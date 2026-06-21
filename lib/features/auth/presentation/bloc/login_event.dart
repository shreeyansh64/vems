part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class RequestLoginEvent extends LoginEvent {
  final String email;
  final String password;

  RequestLoginEvent({required this.email, required this.password});
}
