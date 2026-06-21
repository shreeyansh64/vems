import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vems/features/auth/domain/repository/register_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepository registerRepository;
  RegisterBloc({required this.registerRepository})
    : super(RegisterState.initial()) {
    on<GetOTPEvent>(onGetOTPEvent);
  }

  Future onGetOTPEvent(GetOTPEvent event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(status: RegisterStatus.loading));
    try {
      var getOTP = await registerRepository.getOtp(event.email);
      emit(
        state.copyWith(
          status: RegisterStatus.otpSent,
          message: getOTP,
          email: event.email,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RegisterStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future onVerifyOtpEvent(
    VerifyOtpEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: RegisterStatus.loading));
    try {
      var response = await registerRepository.verifyOtp(event.email, event.otp);
      emit(state.copyWith(status: RegisterStatus.verifyOtp, message: response));
    } catch (e) {
      emit(
        state.copyWith(
          status: RegisterStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future onSetPasswordEvent(
    SetPasswordEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: RegisterStatus.loading));
    try {
      var response = await registerRepository.setPassword(
        event.email,
        event.password,
        event.confirmPassword
      );
      emit(
        state.copyWith(status: RegisterStatus.setPassword, message: response),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RegisterStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
