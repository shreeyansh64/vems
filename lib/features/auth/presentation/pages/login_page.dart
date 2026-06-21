import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vems/features/auth/presentation/bloc/login_bloc.dart';
import 'package:vems/features/auth/presentation/pages/dashboard.dart';
import 'package:vems/features/profile/presentation/pages/profile_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<LoginBloc>(),
                child: ProfilePage(),
              ),
            ),
          );
        } else if (state.status == LoginStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error ?? "Something went wrong")),
          );
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(title: Text("Login"), centerTitle: true),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: state.status == LoginStatus.loading
                    ? CupertinoActivityIndicator()
                    : Column(
                        children: <Widget>[
                          TextFormField(
                            controller: emailController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email required";
                              }
                              if (!value.endsWith("@akgec.ac.in")) {
                                return "Only @akgec.ac.in allowed";
                              }
                              return null;
                            },
                            decoration: InputDecoration(label: Text("Email")),
                          ),
                          SizedBox(height: 30),
                          TextFormField(
                            controller: passwordController,
                            obscureText: obscurePassword,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password required";
                              }
                              return null;
                            },
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
                          ElevatedButton(
                            onPressed: () {
                              if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                                return;
                              }
                              context.read<LoginBloc>().add(
                                RequestLoginEvent(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                ),
                              );
                            },
                            child: Text("Log in"),
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
