part of 'register_bloc.dart';

enum RegisterStatus { initial, loading, otpSent, error, verifyOtp, setPassword }

class RegisterState {
  final RegisterStatus status;
  final String? errorMessage;
  final String? message;
  final String? email;

  RegisterState._({
    required this.status,
    this.errorMessage,
    this.message,
    this.email
  });

  factory RegisterState.initial() => RegisterState._(status: RegisterStatus.initial);

  RegisterState copyWith({
    RegisterStatus? status,
    String? errorMessage,
    String? message,
    String? email
  }) {
    return RegisterState._(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      message: message ?? this.message,
      email: email ?? this.email
    );
  }
}
