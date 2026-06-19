import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vems/features/auth/domain/repository/register_repository.dart';
import 'package:vems/features/auth/presentation/bloc/register_event.dart';
import 'package:vems/features/auth/presentation/bloc/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepository registerRepository;
  RegisterBloc({required this.registerRepository})
    : super(RegisterState.initial()) {
    on<GetOTPEvent>(onGetOTPEvent);
  }

  Future onGetOTPEvent(GetOTPEvent event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(status: RegisterStatus.loading));
    try {
      var getOTP = await registerRepository.GetOTP(event.email);
      emit(state.copyWith(status: RegisterStatus.otpSent, message: getOTP));
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
