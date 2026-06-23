import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vems/features/dashboard/presentation/pages/dashboard.dart';
import 'package:vems/features/documents/presentation/pages/document_page.dart';
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

  InputDecoration _dec(String hint, IconData icon) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFF3D3D3D), fontSize: 14),
    prefixIcon: Icon(icon, color: const Color(0xFFFFAB00), size: 20),
    filled: true,
    fillColor: const Color(0xFF111111),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF2A2A2A), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFFFAB00), width: 1.8),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Color(0xFFE0E0E0)),
        title: const Text(
          'Add Vehicle',
          style: TextStyle(
            color: Color(0xFFE0E0E0),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: BlocConsumer<VehicleBloc, VehicleState>(
        listener: (context, state) {
          if (state.status == VehicleStatus.success) {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const DocumentUploadPage(),
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            );
          } else if (state.status == VehicleStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color(0xFFCF6679),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                content: Text(
                  state.error ?? 'Something went wrong',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const Text(
                  'Vehicle Details',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFE0E0E0),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Register your vehicle to proceed.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF6B6B6B)),
                ),
                const SizedBox(height: 32),

                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF2A2A2A),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'OWNER & VEHICLE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B6B6B),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _ownerNameController,
                        style: const TextStyle(
                          color: Color(0xFFE0E0E0),
                          fontSize: 15,
                        ),
                        decoration: _dec('Owner Name', Icons.person_outline),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _vehicleNumberController,
                        style: const TextStyle(
                          color: Color(0xFFE0E0E0),
                          fontSize: 15,
                        ),
                        textCapitalization: TextCapitalization.characters,
                        decoration: _dec('Vehicle Number', Icons.pin_outlined),
                      ),
                      const SizedBox(height: 24),

                      // Vehicle Type
                      const Text(
                        'VEHICLE TYPE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B6B6B),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: ['CAR', 'BIKE', 'SCOOTY'].map((type) {
                          final selected = _selectedVehicleType == type;
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedVehicleType = type),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? const Color(0xFFFFAB00)
                                      : const Color(0xFF111111),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: selected
                                        ? const Color(0xFFFFAB00)
                                        : const Color(0xFF2A2A2A),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  type,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: selected
                                        ? const Color(0xFF0D0D0D)
                                        : const Color(0xFF6B6B6B),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 24),
                      const Text(
                        'ADDITIONAL INFO',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B6B6B),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _vehicleModelController,
                        style: const TextStyle(
                          color: Color(0xFFE0E0E0),
                          fontSize: 15,
                        ),
                        decoration: _dec(
                          'Vehicle Model',
                          Icons.directions_car_outlined,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _vehicleColorController,
                        style: const TextStyle(
                          color: Color(0xFFE0E0E0),
                          fontSize: 15,
                        ),
                        decoration: _dec(
                          'Vehicle Color',
                          Icons.color_lens_outlined,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _rcNumberController,
                        style: const TextStyle(
                          color: Color(0xFFE0E0E0),
                          fontSize: 15,
                        ),
                        decoration: _dec(
                          'RC Number',
                          Icons.document_scanner_outlined,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: state.status == VehicleStatus.loading
                      ? const Center(
                          child: CupertinoActivityIndicator(
                            radius: 14,
                            color: Color(0xFFFFAB00),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFAB00),
                            foregroundColor: const Color(0xFF0D0D0D),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Add Vehicle',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
