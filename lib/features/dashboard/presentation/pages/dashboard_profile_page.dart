import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vems/features/auth/presentation/pages/login_page.dart';
import 'package:vems/features/dashboard/domain/model/profile_model.dart';
import 'package:vems/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:vems/features/profile/presentation/pages/profile_page.dart';
import 'package:vems/features/vehicle/presentation/pages/vehicle_submit_page.dart';

class DashboardProfilePage extends StatefulWidget {
  const DashboardProfilePage({super.key});

  @override
  State<DashboardProfilePage> createState() => _DashboardProfilePageState();
}

class _DashboardProfilePageState extends State<DashboardProfilePage> {
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
            backgroundColor: Color(0xFF0D0D0D),
            body: Center(
              child: CupertinoActivityIndicator(
                radius: 14,
                color: Color(0xFFFFAB00),
              ),
            ),
          );
        }

        final profile = state.profile;

        return Scaffold(
          backgroundColor: const Color(0xFF0D0D0D),
          body: Column(
            children: [
              // ── Profile hero header ───────────────────────────────────
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF1C1A14), Color(0xFF0D0D0D)],
                  ),
                  border: Border(
                    bottom: BorderSide(color: Color(0xFF1E1E1E), width: 1),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 36, 24, 32),
                    child: Column(
                      children: [
                        // Avatar
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(
                                    0xFFFFAB00,
                                  ).withOpacity(0.5),
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 46,
                                backgroundColor: const Color(0xFF2A2A2A),
                                backgroundImage: profile?.photo != null
                                    ? NetworkImage(profile!.photo!)
                                    : null,
                                child: profile?.photo == null
                                    ? const Icon(
                                        Icons.person,
                                        color: Color(0xFF6B6B6B),
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
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFAB00),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 14,
                                  color: Color(0xFF0D0D0D),
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
                            color: Color(0xFFE0E0E0),
                            letterSpacing: 0.2,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Student number badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF2A2A2A)),
                          ),
                          child: Text(
                            profile?.studentNumber ?? '—',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B6B6B),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Body ─────────────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section label + divider
                      Row(
                        children: [
                          const Text(
                            'VEHICLES',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4A4A4A),
                              letterSpacing: 1.4,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: const Color(0xFF1E1E1E),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      _tile(
                        icon: Icons.directions_car_outlined,
                        label: 'My Vehicles',
                        onTap: () {},
                      ),

                      const SizedBox(height: 10),

                      _tile(
                        icon: Icons.add_circle_outline,
                        label: 'Add Another Vehicle',
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  const VehicleSubmitPage(),
                              transitionsBuilder: (_, animation, __, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                      ),

                      const Spacer(),

                      // Logout button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () async {
                            final FlutterSecureStorage storage =
                                FlutterSecureStorage();
                            await storage.delete(key: 'access_token');
                            await storage.delete(key: 'refresh_token');
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => const LoginPage(),
                                transitionsBuilder: (_, animation, __, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFFCF6679),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            backgroundColor: const Color(
                              0xFFCF6679,
                            ).withOpacity(0.05),
                          ),
                          child: const Text(
                            'Logout',
                            style: TextStyle(
                              color: Color(0xFFCF6679),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
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
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1E1E1E)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFAB00).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFFFFAB00), size: 18),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE0E0E0),
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Color(0xFF3A3A3A), size: 20),
          ],
        ),
      ),
    );
  }
}
