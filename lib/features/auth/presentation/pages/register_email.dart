import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vems/features/auth/presentation/bloc/register_bloc.dart';
import 'package:vems/features/auth/presentation/pages/register_verify_otp_page.dart';

class RegisterEmail extends StatefulWidget {
  const RegisterEmail({super.key});

  @override
  State<RegisterEmail> createState() => _RegisterEmailState();
}

class _RegisterEmailState extends State<RegisterEmail> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.status == RegisterStatus.otpSent) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RegisterVerifyOtpPage()),
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
            appBar: AppBar(centerTitle: true, title: const Text('Register Page')),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: state.status == RegisterStatus.loading
                    ? CupertinoActivityIndicator()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(hintText: 'Email'),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              context.read<RegisterBloc>().add(
                                GetOTPEvent(email: emailController.text.trim()),
                              );
                            },
                            child: Text("Get OTP"),
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