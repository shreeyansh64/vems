import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vems/features/auth/presentation/pages/login_page.dart';
import 'package:vems/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:vems/features/dashboard/presentation/pages/dashboard_my_vehicles_page.dart';
import 'package:vems/features/profile/presentation/pages/profile_page.dart';
import 'package:vems/features/vehicle/presentation/pages/vehicle_submit_page.dart';

class DashboardProfilePage extends StatefulWidget {
  const DashboardProfilePage({super.key});

  @override
  State<DashboardProfilePage> createState() => _DashboardProfilePageState();
}

class _DashboardProfilePageState extends State<DashboardProfilePage> {
  static const Color _ground = Color(0xFFF4F7FC);
  static const Color _panel = Color(0xFF0C1A2E);
  static const Color _ink = Color(0xFF0C1A2E);
  static const Color _muted = Color(0xFF5A6B85);
  static const Color _hint = Color(0xFF9AA8BF);
  static const Color _field = Color(0xFFF7F9FD);
  static const Color _hairline = Color(0xFFE4E9F2);
  static const Color _accent = Color(0xFF1E50E5);
  static const Color _green = Color(0xFF34D399);
  static const Color _onPanelMuted = Color(0xFF8497B5);
  static const String _mono = 'monospace';

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(GetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.status == DashboardStatus.loading) {
          return const Scaffold(
            backgroundColor: _ground,
            body: Center(
              child: CupertinoActivityIndicator(radius: 14, color: _accent),
            ),
          );
        }

        final profile = state.profile;

        return Scaffold(
          backgroundColor: _ground,
          body: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                    center: Alignment(0.7, -1.2),
                    radius: 1.4,
                    colors: [Color(0xFF163056), _panel],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _panel.withValues(alpha: 0.30),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 28, 22, 28),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _accent.withValues(alpha: 0.5),
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 46,
                                backgroundColor: const Color(0xFF1E2D45),
                                backgroundImage: profile?.photo != null
                                    ? NetworkImage(profile!.photo!)
                                    : null,
                                child: profile?.photo == null
                                    ? const Icon(
                                        Icons.person_rounded,
                                        color: _onPanelMuted,
                                        size: 48,
                                      )
                                    : null,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        const ProfilePage(),
                                    transitionsBuilder:
                                        (_, animation, __, child) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: _accent,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: _panel, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _accent.withValues(alpha: 0.45),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.edit_rounded,
                                  size: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          profile != null
                              ? '${profile.firstName} ${profile.lastName}'
                              : '—',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: _green.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: _green.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const _Dot(color: _green, size: 6),
                              const SizedBox(width: 6),
                              Text(
                                profile?.studentNumber ?? '—',
                                style: const TextStyle(
                                  fontFamily: _mono,
                                  fontSize: 11,
                                  color: Color(0xFFBFF3D6),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 28, 22, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'VEHICLES',
                            style: TextStyle(
                              fontFamily: _mono,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _muted,
                              letterSpacing: 1.4,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(height: 1, color: _hairline),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _tile(
                        icon: Icons.directions_car_rounded,
                        label: 'My Vehicles',
                        onTap: () {
                          context.read<DashboardBloc>().add(GetVehiclesEvent());
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  const MyVehiclesPage(),
                              transitionsBuilder: (_, animation, __, child) =>
                                  FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      _tile(
                        icon: Icons.add_circle_outline_rounded,
                        label: 'Add Another Vehicle',
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  const VehicleSubmitPage(),
                              transitionsBuilder: (_, animation, __, child) =>
                                  FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () async {
                            const FlutterSecureStorage storage =
                                FlutterSecureStorage();
                            await storage.delete(key: 'access_token');
                            await storage.delete(key: 'refresh_token');
                            Navigator.pushAndRemoveUntil(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => const LoginPage(),
                                transitionsBuilder: (_, animation, __, child) =>
                                    FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    ),
                              ),
                              (route) => false,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFFDC2626),
                              width: 1.3,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            backgroundColor: const Color(
                              0xFFDC2626,
                            ).withValues(alpha: 0.05),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout_rounded,
                                color: Color(0xFFDC2626),
                                size: 17,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  color: Color(0xFFDC2626),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _hairline, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: _panel.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _accent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: _accent, size: 18),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _ink,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded, color: _hint, size: 20),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  final double size;
  const _Dot({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
