part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}

class GetOTPEvent extends RegisterEvent {
  final String email;
  GetOTPEvent({required this.email});
}

class VerifyOtpEvent extends RegisterEvent {
  final String email;
  final String otp;
  VerifyOtpEvent({required this.email, required this.otp});
}

class SetPasswordEvent extends RegisterEvent {
  final String email;
  final String password;
  final String confirmPassword;
  SetPasswordEvent({required this.email, required this.password, required this.confirmPassword});
}
