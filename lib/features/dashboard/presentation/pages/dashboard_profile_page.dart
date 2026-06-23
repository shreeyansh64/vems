import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vems/features/dashboard/presentation/bloc/dashboard_bloc.dart';

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
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 32),

                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 48,
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
                      GestureDetector(
                        onTap: () {
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

                  const SizedBox(height: 14),

                  Text(
                    profile != null
                        ? '${profile.firstName} ${profile.lastName}'
                        : '—',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFE0E0E0),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    profile?.studentNumber ?? '—',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B6B6B),
                    ),
                  ),

                  const SizedBox(height: 40),

                  _tile(
                    icon: Icons.directions_car_outlined,
                    label: 'My Vehicles',
                    onTap: () {
                    },
                  ),

                  const SizedBox(height: 12),

                  _tile(
                    icon: Icons.add_circle_outline,
                    label: 'Add Another Vehicle',
                    onTap: () {
                    },
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFCF6679)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Color(0xFFCF6679),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
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
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFFFAB00), size: 20),
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
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF6B6B6B),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}