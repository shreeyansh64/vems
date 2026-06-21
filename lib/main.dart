import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vems/core/dependency_injection.dart';
import 'package:vems/features/auth/presentation/bloc/register_bloc.dart';
import 'package:vems/features/auth/presentation/pages/register_email.dart';

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
      providers: [BlocProvider(create: (_) => getIt<RegisterBloc>())],
      child: MaterialApp(title: 'VEMS', home: const RegisterEmail()),
    );
  }
}
