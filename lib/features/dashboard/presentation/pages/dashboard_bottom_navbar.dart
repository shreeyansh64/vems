import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:vems/features/dashboard/presentation/pages/dashboard.dart';
import 'package:vems/features/dashboard/presentation/pages/dashboard_my_vehicles_page.dart';
import 'package:vems/features/dashboard/presentation/pages/dashboard_profile_page.dart';

class DashboardBottomNavbar extends StatefulWidget {
  const DashboardBottomNavbar({super.key});

  @override
  State<DashboardBottomNavbar> createState() => _DashboardBottomNavbarState();
}

class _DashboardBottomNavbarState extends State<DashboardBottomNavbar> {
  int _index = 0;

  final _pages = const [
    Dashboard(),
    MyVehiclesPage(),
    DashboardProfilePage(),
  ];

  static const Color _ground = Color(0xFFF4F7FC);
  static const Color _panel = Color(0xFF0C1A2E);
  static const Color _muted = Color(0xFF5A6B85);
  static const Color _hairline = Color(0xFFE4E9F2);
  static const Color _accent = Color(0xFF1E50E5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _ground,
      body: _pages[_index],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: _ground,
          border: Border(
            top: BorderSide(color: _hairline, width: 1.5),
          ),
          boxShadow: [
            BoxShadow(
              color: _panel.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: GNav(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          selectedIndex: _index,
          onTabChange: (i) => setState(() => _index = i),
          backgroundColor: _ground,
          color: _muted,
          activeColor: _accent,
          tabBackgroundColor: _accent.withValues(alpha: 0.08),
          gap: 8,
          iconSize: 22,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          tabs: const [
            GButton(icon: Icons.home_rounded, text: 'Home'),
            GButton(icon: Icons.directions_car_rounded, text: 'Vehicles'),
            GButton(icon: Icons.person_rounded, text: 'Profile'),
          ],
        ),
      ),
    );
  }
}