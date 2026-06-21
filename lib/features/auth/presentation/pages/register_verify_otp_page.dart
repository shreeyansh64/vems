import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:vems/features/auth/presentation/bloc/register_bloc.dart';
import 'package:vems/features/auth/presentation/pages/register_set_password_page.dart';

class RegisterVerifyOtpPage extends StatefulWidget {
  const RegisterVerifyOtpPage({super.key});

  @override
  State<RegisterVerifyOtpPage> createState() => _RegisterVerifyOtpPageState();
}

class _RegisterVerifyOtpPageState extends State<RegisterVerifyOtpPage> {
  final otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.status == RegisterStatus.verifyOtp) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RegisterSetPasswordPage()),
          );
        } else if (state.status == RegisterStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Something went wrong')),
          );
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(title: Text("Verify OTP"), centerTitle: true),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: state.status == RegisterStatus.loading
                    ? CircularProgressIndicator()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Enter the OTP sent to ${context.read<RegisterBloc>().state.email}"),
                          SizedBox(height: 24),
                          Pinput(
                            length: 6,
                            controller: otpController,
                            onCompleted: (otp) {
                              context.read<RegisterBloc>().add(
                                VerifyOtpEvent(
                                  email: context.read<RegisterBloc>().state.email!,
                                  otp: otp,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}