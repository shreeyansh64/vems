import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vems/features/auth/presentation/pages/login_page.dart';
import 'package:vems/features/dashboard/presentation/pages/dashboard_bottom_navbar.dart';
import 'package:vems/features/profile/presentation/pages/profile_page.dart';
import 'package:vems/features/session/presentation/bloc/session_bloc.dart';
import 'package:vems/scanner_page.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  void initState() {
    super.initState();
    context.read<SessionBloc>().add(CheckSessionEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        switch (state.status) {
          case SessionStatus.initial:
          case SessionStatus.loading:
            return const Scaffold(
              backgroundColor: Color(0xFFF4F7FC),
              body: Center(
                child: CupertinoActivityIndicator(
                  radius: 14,
                  color: Color(0xFF1E50E5),
                ),
              ),
            );
          case SessionStatus.authenticated:
            if (state.role == 'STAFF') return const ScannerPage(number: '');
            return const DashboardBottomNavbar();
          case SessionStatus.unauthenticated:
            return const LoginPage();
          case SessionStatus.profileIncomplete:
            return const ProfilePage();
        }
      },
    );
  }
}