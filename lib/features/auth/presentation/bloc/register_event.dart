abstract class RegisterEvent {}

class GetOTPEvent extends RegisterEvent {
  final String email;
  GetOTPEvent({required this.email});
}
