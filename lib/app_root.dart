import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vems/features/auth/presentation/pages/login_page.dart';
import 'package:vems/features/dashboard/presentation/pages/dashboard_bottom_navbar.dart';
import 'package:vems/features/profile/presentation/pages/profile_page.dart';
import 'package:vems/features/session/presentation/bloc/session_bloc.dart';

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
              backgroundColor: Color(0xFF0D0D0D),
              body: Center(
                child: CupertinoActivityIndicator(
                  radius: 14,
                  color: Color(0xFFFFAB00),
                ),
              ),
            );
          case SessionStatus.unauthenticated:
            return const LoginPage();
          case SessionStatus.profileIncomplete:
            return const ProfilePage();
          case SessionStatus.authenticated:
            return const DashboardBottomNavbar();
        }
      },
    );
  }
}