import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vems/features/dashboard/domain/model/vehicle_model.dart';
import 'package:vems/features/dashboard/presentation/bloc/dashboard_bloc.dart';

class MyVehiclesPage extends StatefulWidget {
  const MyVehiclesPage({super.key});

  @override
  State<MyVehiclesPage> createState() => _MyVehiclesPageState();
}

class _MyVehiclesPageState extends State<MyVehiclesPage> {
  static const Color _ground = Color(0xFFF4F7FC);
  static const Color _ink = Color(0xFF0C1A2E);
  static const Color _muted = Color(0xFF5A6B85);
  static const Color _hint = Color(0xFF9AA8BF);
  static const Color _hairline = Color(0xFFE4E9F2);
  static const Color _accent = Color(0xFF1E50E5);
  static const String _mono = 'monospace';

  @override
  void initState() {
    context.read<DashboardBloc>().add(GetVehiclesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _ground,
      appBar: AppBar(
        backgroundColor: _ground,
        foregroundColor: _ink,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'MY VEHICLES',
          style: TextStyle(
            fontFamily: _mono,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _ink,
            letterSpacing: 2.0,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: _hairline),
        ),
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state.status == DashboardStatus.loading) {
            return const Center(
              child: CupertinoActivityIndicator(
                radius: 14,
                color: _accent,
              ),
            );
          }

          if (state.status == DashboardStatus.error) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Something went wrong',
                style: const TextStyle(color: _muted, fontSize: 14),
              ),
            );
          }

          final vehicles = state.vehicles ?? [];

          if (vehicles.isEmpty) {
            return const Center(
              child: Text(
                'No vehicles added yet',
                style: TextStyle(color: _hint, fontSize: 14),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
            itemCount: vehicles.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final v = vehicles[index];
              return _VehicleCard(vehicle: v);
            },
          );
        },
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final VehicleModel vehicle;
  const _VehicleCard({required this.vehicle});

  static const Color _panel = Color(0xFF0C1A2E);
  static const Color _ink = Color(0xFF0C1A2E);
  static const Color _muted = Color(0xFF5A6B85);
  static const Color _hairline = Color(0xFFE4E9F2);
  static const Color _accent = Color(0xFF1E50E5);
  static const String _mono = 'monospace';

  IconData get _icon {
    switch (vehicle.vehicleType) {
      case 'CAR':
        return Icons.directions_car_rounded;
      case 'BIKE':
        return Icons.two_wheeler_rounded;
      case 'SCOOTY':
        return Icons.electric_scooter_rounded;
      default:
        return Icons.directions_car_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _accent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_icon, color: _accent, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle.vehicleNumber,
                  style: const TextStyle(
                    fontFamily: _mono,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _ink,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${vehicle.vehicleModel} · ${vehicle.vehicleColor}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: _muted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: _accent.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _accent.withValues(alpha: 0.18),
              ),
            ),
            child: Text(
              vehicle.vehicleType,
              style: const TextStyle(
                fontFamily: _mono,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: _accent,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}