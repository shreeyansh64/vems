import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vems/features/auth/presentation/bloc/register_bloc.dart';
import 'package:vems/features/auth/presentation/pages/dashboard.dart';

class RegisterSetPasswordPage extends StatefulWidget {
  const RegisterSetPasswordPage({super.key});

  @override
  State<RegisterSetPasswordPage> createState() =>
      _RegisterSetPasswordPageState();
}

class _RegisterSetPasswordPageState extends State<RegisterSetPasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool obscurePassword = false;
  bool obscureConfirmPassword = false;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.status == RegisterStatus.setPassword) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<RegisterBloc>(),
                child: Dashboard(),
              ),
            ),
          );
        } else if (state.status == RegisterStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Something went wrong'),
            ),
          );
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(title: Text("Set Password"), centerTitle: true),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: state.status == RegisterStatus.loading
                    ? CupertinoActivityIndicator()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            controller: passwordController,
                            obscureText: obscurePassword,
                            decoration: InputDecoration(
                              label: Text("Password"),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                                icon: obscurePassword
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          TextFormField(
                            controller: confirmPasswordController,
                            obscureText: obscureConfirmPassword,
                            decoration: InputDecoration(
                              label: Text("Confirm Password"),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscureConfirmPassword =
                                        !obscureConfirmPassword;
                                  });
                                },
                                icon: obscureConfirmPassword
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (passwordController.text.trim() !=
                                  confirmPasswordController.text.trim()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Passwords don't match"),
                                  ),
                                );
                                return;
                              }
                              context.read<RegisterBloc>().add(
                                SetPasswordEvent(
                                  email: state.email!,
                                  password: passwordController.text.trim(),
                                  confirmPassword: confirmPasswordController
                                      .text
                                      .trim(),
                                ),
                              );
                            },
                            child: Text("Set Password"),
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
