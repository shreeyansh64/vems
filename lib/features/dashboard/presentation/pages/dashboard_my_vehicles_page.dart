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

  @override
  void initState() {
    context.read<DashboardBloc>().add(GetVehiclesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        foregroundColor: const Color(0xFFE0E0E0),
        title: const Text(
          'My Vehicles',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFF1E1E1E)),
        ),
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state.status == DashboardStatus.loading) {
            return const Center(
              child: CupertinoActivityIndicator(
                radius: 14,
                color: Color(0xFFFFAB00),
              ),
            );
          }

          if (state.status == DashboardStatus.error) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Something went wrong',
                style: const TextStyle(color: Color(0xFF6B6B6B)),
              ),
            );
          }

          final vehicles = state.vehicles ?? [];

          if (vehicles.isEmpty) {
            return const Center(
              child: Text(
                'No vehicles added yet',
                style: TextStyle(color: Color(0xFF6B6B6B), fontSize: 14),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: vehicles.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
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

  IconData get _icon {
    switch (vehicle.vehicleType) {
      case 'CAR':
        return Icons.directions_car_outlined;
      case 'BIKE':
        return Icons.two_wheeler_outlined;
      case 'SCOOTY':
        return Icons.electric_scooter_outlined;
      default:
        return Icons.directions_car_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E1E1E)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFAB00).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_icon, color: const Color(0xFFFFAB00), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle.vehicleNumber,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFE0E0E0),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${vehicle.vehicleModel} · ${vehicle.vehicleColor}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B6B6B),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              vehicle.vehicleType,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A4A4A),
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}