import 'package:camera/camera.dart';
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
import 'package:vems/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:vems/features/documents/presentation/bloc/document_bloc.dart';
import 'package:vems/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:vems/features/session/presentation/bloc/session_bloc.dart';
import 'package:vems/features/vehicle/presentation/bloc/vehicle_bloc.dart';
import 'package:vems/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await availableCameras();
  await dotenv.load(fileName: ".env");
  setup();
  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
        BlocProvider(create: (_) => getIt<DocumentBloc>()),
        BlocProvider(create: (_) => getIt<DashboardBloc>()),
        BlocProvider(create: (_) => getIt<SessionBloc>()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'VEMS',
        home: RegisterSetPasswordPage(),
      ),
    );
  }
}
