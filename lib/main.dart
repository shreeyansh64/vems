import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vems/core/di/injection.dart';
import 'package:vems/features/auth/presentation/bloc/login_bloc.dart';
import 'package:vems/features/auth/presentation/bloc/register_bloc.dart';
import 'package:vems/features/auth/presentation/pages/login_page.dart';
import 'package:vems/features/auth/presentation/pages/register_email.dart';
import 'package:vems/features/auth/presentation/pages/register_set_password_page.dart';
import 'package:vems/features/auth/presentation/pages/register_verify_otp_page.dart';
import 'package:vems/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:vems/features/profile/presentation/pages/profile_page.dart';
import 'package:vems/features/vehicle/presentation/bloc/vehicle_bloc.dart';
import 'package:vems/features/vehicle/presentation/pages/vehicle_submit_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<RegisterBloc>()),
        BlocProvider(create: (_) => getIt<LoginBloc>()),
        BlocProvider(create: (_) => getIt<ProfileBloc>()),
        BlocProvider(create: (_) => getIt<VehicleBloc>()),
      ],
      child: MaterialApp(title: 'VEMS', home: const RegisterEmail()),
    );
  }
}
