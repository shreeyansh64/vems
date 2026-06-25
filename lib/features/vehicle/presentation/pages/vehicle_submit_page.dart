import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: _ground,
        appBar: AppBar(
          backgroundColor: _ground,
          elevation: 0,
          centerTitle: true,
          leading: const BackButton(color: _ink),
          title: const Text(
            'ADD VEHICLE',
            style: TextStyle(
              fontFamily: _mono,
              color: _ink,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              letterSpacing: 2.0,
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
                  transitionsBuilder: (_, animation, __, child) =>
                      FadeTransition(opacity: animation, child: child),
                ),
              );
            } else if (state.status == VehicleStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: const Color(0xFFDC2626),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const RadialGradient(
                          center: Alignment(0.7, -1.2),
                          radius: 1.4,
                          colors: [Color(0xFF163056), _panel],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _panel.withValues(alpha: 0.35),
                            blurRadius: 30,
                            offset: const Offset(0, 18),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF2A5BFF),
                                      Color(0xFF1230A8),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF2A5BFF,
                                      ).withValues(alpha: 0.6),
                                      blurRadius: 14,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.directions_car_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 11),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'VEMS',
                                    style: TextStyle(
                                      fontFamily: _mono,
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 3.0,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'VEHICLE REGISTRATION',
                                    style: TextStyle(
                                      fontFamily: _mono,
                                      color: _onPanelMuted,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.8,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: _green.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: _green.withValues(alpha: 0.35),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _Dot(color: _green, size: 6),
                                    SizedBox(width: 6),
                                    Text(
                                      'NEW',
                                      style: TextStyle(
                                        fontFamily: _mono,
                                        color: Color(0xFFBFF3D6),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.fromLTRB(2, 11, 2, 4),
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Color(0x14FFFFFF)),
                              ),
                            ),
                            child: const Row(
                              children: [
                                _Dot(color: _green, size: 6),
                                SizedBox(width: 8),
                                Text(
                                  'GATE ACCESS',
                                  style: TextStyle(
                                    fontFamily: _mono,
                                    color: _onPanelMuted,
                                    fontSize: 10.5,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  'Pending approval · AKGEC',
                                  style: TextStyle(
                                    fontFamily: _mono,
                                    color: Color(0xFFBFE9CF),
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'VEHICLE DETAILS',
                            style: TextStyle(
                              fontFamily: _mono,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.8,
                              color: _accent,
                            ),
                          ),
                          const SizedBox(height: 11),
                          const Text(
                            'Register your vehicle',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.7,
                              color: _ink,
                              height: 1.05,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: 38,
                            height: 3,
                            decoration: BoxDecoration(
                              color: _accent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const SizedBox(
                            width: 260,
                            child: Text(
                              'Fill in your vehicle information to apply for campus gate access.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.5,
                                color: _muted,
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),
                    _label('OWNER NAME'),
                    const SizedBox(height: 7),
                    TextField(
                      controller: _ownerNameController,
                      style: const TextStyle(color: _ink, fontSize: 15),
                      decoration: _decoration(
                        hint: 'Owner Name',
                        icon: Icons.person_outline_rounded,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _label('VEHICLE NUMBER'),
                    const SizedBox(height: 7),
                    TextField(
                      controller: _vehicleNumberController,
                      style: const TextStyle(color: _ink, fontSize: 15),
                      textCapitalization: TextCapitalization.characters,
                      decoration: _decoration(
                        hint: 'e.g. UP14 AB 2847',
                        icon: Icons.pin_outlined,
                      ),
                    ),

                    const SizedBox(height: 24),
                    _label('VEHICLE TYPE'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _typeButton(
                          type: 'CAR',
                          icon: Icons.directions_car_rounded,
                        ),
                        const SizedBox(width: 10),
                        _typeButton(
                          type: 'BIKE',
                          icon: Icons.two_wheeler_rounded,
                        ),
                        const SizedBox(width: 10),
                        _typeButton(
                          type: 'SCOOTY',
                          icon: Icons.electric_scooter_rounded,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    _label('VEHICLE MODEL'),
                    const SizedBox(height: 7),
                    TextField(
                      controller: _vehicleModelController,
                      style: const TextStyle(color: _ink, fontSize: 15),
                      decoration: _decoration(
                        hint: 'e.g. Honda Activa',
                        icon: Icons.directions_car_outlined,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _label('VEHICLE COLOR'),
                    const SizedBox(height: 7),
                    TextField(
                      controller: _vehicleColorController,
                      style: const TextStyle(color: _ink, fontSize: 15),
                      decoration: _decoration(
                        hint: 'e.g. Pearl White',
                        icon: Icons.color_lens_outlined,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _label('RC NUMBER'),
                    const SizedBox(height: 7),
                    TextField(
                      controller: _rcNumberController,
                      style: const TextStyle(color: _ink, fontSize: 15),
                      decoration: _decoration(
                        hint: 'Registration Certificate No.',
                        icon: Icons.document_scanner_outlined,
                      ),
                    ),

                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: state.status == VehicleStatus.loading
                          ? const Center(
                              child: CupertinoActivityIndicator(
                                radius: 14,
                                color: _accent,
                              ),
                            )
                          : DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: _accent.withValues(alpha: 0.45),
                                    blurRadius: 22,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _accent,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Add Vehicle',
                                      style: TextStyle(
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 9),
                                    Icon(Icons.arrow_forward_rounded, size: 18),
                                  ],
                                ),
                              ),
                            ),
                    ),

                    const SizedBox(height: 22),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.lock_outline_rounded,
                            size: 12,
                            color: _hint,
                          ),
                          SizedBox(width: 7),
                          Text(
                            'VEMS · By SHREEYANSH & AGRIM',
                            style: TextStyle(
                              fontFamily: _mono,
                              color: _hint,
                              fontSize: 10,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _typeButton({required String type, required IconData icon}) {
    final selected = _selectedVehicleType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedVehicleType = type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? _accent : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? _accent : _hairline,
              width: selected ? 0 : 1.5,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: _accent.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: _panel.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            children: [
              Icon(icon, size: 22, color: selected ? Colors.white : _muted),
              const SizedBox(height: 6),
              Text(
                type,
                style: TextStyle(
                  fontFamily: _mono,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: selected ? Colors.white : _muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      fontFamily: _mono,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.0,
      color: _muted,
    ),
  );

  InputDecoration _decoration({required String hint, required IconData icon}) {
    OutlineInputBorder b(Color c, double w) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: c, width: w),
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _hint, fontSize: 14),
      prefixIcon: Icon(icon, color: _accent, size: 20),
      filled: true,
      fillColor: _field,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: b(Colors.transparent, 0),
      enabledBorder: b(_hairline, 1.5),
      focusedBorder: b(_accent, 1.6),
      errorBorder: b(const Color(0xFFDC2626), 1.3),
      focusedErrorBorder: b(const Color(0xFFDC2626), 1.6),
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
