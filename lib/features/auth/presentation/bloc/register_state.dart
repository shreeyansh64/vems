enum RegisterStatus { initial, loading, otpSent, error }

class RegisterState {
  final RegisterStatus status;
  final String? errorMessage;
  final String? message;

  RegisterState._({
    required this.status,
    this.errorMessage,
    this.message,
  });

  factory RegisterState.initial() => RegisterState._(status: RegisterStatus.initial);

  RegisterState copyWith({
    RegisterStatus? status,
    String? errorMessage,
    String? message,
  }) {
    return RegisterState._(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      message: message ?? this.message,
    );
  }
}
