import 'package:flutter/material.dart';
import 'package:vems/core/dependency_injection.dart';
import 'package:vems/features/auth/presentation/register_page.dart';

void main () {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VEMS',
      home: const RegisterPage(),
    );
  }
}