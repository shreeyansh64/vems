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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: _pages[_index],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          border: Border(
            top: BorderSide(color: Color(0xFF2A2A2A), width: 1),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: GNav(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          selectedIndex: _index,
          onTabChange: (i) => setState(() => _index = i),
          backgroundColor: const Color(0xFF1A1A1A),
          color: const Color(0xFF6B6B6B),
          activeColor: const Color(0xFFFFAB00),
          tabBackgroundColor: const Color(0xFF111111),
          gap: 10,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          tabs: const [
            GButton(icon: Icons.home_sharp, text: 'Home'),
            GButton(icon: Icons.directions_car_outlined, text: 'Vehicles'),
            GButton(icon: Icons.person, text: 'Profile'),
          ],
        ),
      ),
    );
  }
}