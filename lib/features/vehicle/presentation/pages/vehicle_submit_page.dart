import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vems/features/auth/presentation/pages/dashboard.dart';
import 'package:vems/features/vehicle/presentation/bloc/vehicle_bloc.dart';

class VehicleSubmitPage extends StatefulWidget {
  const VehicleSubmitPage({super.key});

  @override
  State<VehicleSubmitPage> createState() => _VehicleSubmitPageState();
}

class _VehicleSubmitPageState extends State<VehicleSubmitPage> {
  final _ownerNameController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _vehicleColorController = TextEditingController();
  final _rcNumberController = TextEditingController();

  String _selectedVehicleType = 'BIKE';

  void _submit() {
    context.read<VehicleBloc>().add(
      SubmitVehicleEvent(
        ownerName: _ownerNameController.text.trim(),
        vehicleNumber: _vehicleNumberController.text.trim(),
        vehicleType: _selectedVehicleType,
        vehicleModel: _vehicleModelController.text.trim(),
        vehicleColor: _vehicleColorController.text.trim(),
        rcNumber: _rcNumberController.text.trim(),
      ),
    );
  }

  @override
  void dispose() {
    _ownerNameController.dispose();
    _vehicleNumberController.dispose();
    _vehicleModelController.dispose();
    _vehicleColorController.dispose();
    _rcNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Vehicle')),
      body: BlocConsumer<VehicleBloc, VehicleState>(
        listener: (context, state) {
          if (state.status == VehicleStatus.success) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Dashboard()),
            );
          } else if (state.status == VehicleStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? 'Something went wrong')),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _ownerNameController,
                  decoration: const InputDecoration(labelText: 'Owner Name'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _vehicleNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Vehicle Number',
                  ),
                  textCapitalization: TextCapitalization.characters,
                ),
                const SizedBox(height: 24),
                const Text('Vehicle Type'),
                const SizedBox(height: 8),
                Row(
                  children: ['CAR', 'BIKE', 'SCOOTY'].map((type) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(type),
                        selected: _selectedVehicleType == type,
                        onSelected: (_) =>
                            setState(() => _selectedVehicleType = type),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _vehicleModelController,
                  decoration: const InputDecoration(labelText: 'Vehicle Model'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _vehicleColorController,
                  decoration: const InputDecoration(labelText: 'Vehicle Color'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _rcNumberController,
                  decoration: const InputDecoration(labelText: 'RC Number'),
                ),
                const SizedBox(height: 32),
                state.status == VehicleStatus.loading
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submit,
                          child: const Text('Add Vehicle'),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
