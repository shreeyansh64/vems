import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vems/features/dashboard/presentation/pages/dashboard_bottom_navbar.dart';
import 'package:vems/features/profile/presentation/bloc/profile_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _studentNumberController = TextEditingController();
  final _picker = ImagePicker();
  XFile? _pickedImage;

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

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _pickedImage = image);
  }

  void _submit() {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _studentNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: const Text(
            'All fields are required',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return;
    }
    context.read<ProfileBloc>().add(
      SubmitProfileEvent(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        studentNumber: _studentNumberController.text.trim(),
        photoPath: _pickedImage?.path,
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _studentNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: _ground,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: _ground,
          elevation: 0,
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.status == ProfileStatus.success) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const DashboardBottomNavbar(),
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              );
            } else if (state.status == ProfileStatus.error) {
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
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'YOUR PROFILE',
                            style: TextStyle(
                              fontFamily: _mono,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.8,
                              color: _accent,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Fill in your details',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.7,
                              color: _ink,
                              height: 1.05,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: 38,
                            height: 3,
                            decoration: BoxDecoration(
                              color: _accent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const SizedBox(
                            width: 260,
                            child: Text(
                              'Complete your identity to register vehicles and manage campus gate entries.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: _muted,
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _field,
                                border: Border.all(
                                  color: _hairline,
                                  width: 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: _panel.withValues(alpha: 0.08),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                                image: _pickedImage != null
                                    ? DecorationImage(
                                        image: FileImage(
                                          File(_pickedImage!.path),
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: _pickedImage == null
                                  ? Icon(
                                      Icons.person_outline_rounded,
                                      size: 48,
                                      color: _hint,
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _accent,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: _ground, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _accent.withValues(alpha: 0.45),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                    _label('FIRST NAME'),
                    const SizedBox(height: 7),
                    TextFormField(
                      controller: _firstNameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: const TextStyle(color: _ink, fontSize: 15),
                      decoration: _decoration(
                        hint: 'First Name',
                        icon: Icons.badge_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'First name is required';
                        }
                        if (value.length >= 20) return 'First name too long';
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    _label('LAST NAME'),
                    const SizedBox(height: 7),
                    TextFormField(
                      controller: _lastNameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: const TextStyle(color: _ink, fontSize: 15),
                      decoration: _decoration(
                        hint: 'Last Name',
                        icon: Icons.badge_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Last name is required';
                        }
                        if (value.length >= 20) return 'Last name too long';
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    _label('STUDENT NUMBER'),
                    const SizedBox(height: 7),
                    TextFormField(
                      controller: _studentNumberController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: _ink, fontSize: 15),
                      decoration: _decoration(
                        hint: 'Student Number',
                        icon: Icons.numbers_outlined,
                      ),
                    ),

                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: state.status == ProfileStatus.loading
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
                                      'Save Profile',
                                      style: TextStyle(
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),

                    const SizedBox(height: 24),
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

  InputDecoration _decoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    OutlineInputBorder b(Color c, double w) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: c, width: w),
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _hint, fontSize: 14),
      prefixIcon: Icon(icon, color: _accent, size: 20),
      suffixIcon: suffix,
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
