import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vems/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:vems/features/vehicle/presentation/pages/vehicle_submit_page.dart';

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

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _pickedImage = image);
  }

  void _submit() {
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

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      hintText: label,
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCF6679), width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCF6679), width: 1.8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0D0D),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0D0D0D),
          elevation: 0,
          centerTitle: true,
          leading: const BackButton(color: Color(0xFFE0E0E0)),
          title: const Text(
            'Complete Profile',
            style: TextStyle(
              color: Color(0xFFE0E0E0),
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.status == ProfileStatus.success) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const VehicleSubmitPage(),
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              );
            } else if (state.status == ProfileStatus.error) {
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
                    'Your Profile',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFE0E0E0),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Fill in your details to get started.',
                    style: TextStyle(fontSize: 14, color: Color(0xFF6B6B6B)),
                  ),
                  const SizedBox(height: 32),

                  // Avatar
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: const Color(0xFF1A1A1A),
                            backgroundImage: _pickedImage == null
                                ? null
                                : FileImage(File(_pickedImage!.path)),
                            child: _pickedImage == null
                                ? const Icon(
                                    Icons.person_outline,
                                    size: 40,
                                    color: Color(0xFF3D3D3D),
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFAB00),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 14,
                                color: Color(0xFF0D0D0D),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                          'PERSONAL INFO',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B6B6B),
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _firstNameController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: const TextStyle(
                            color: Color(0xFFE0E0E0),
                            fontSize: 15,
                          ),
                          decoration: _inputDecoration(
                            'First Name',
                            Icons.badge_outlined,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'First Name is required';
                            if (value.length >= 20)
                              return 'First name length too long';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _lastNameController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: const TextStyle(
                            color: Color(0xFFE0E0E0),
                            fontSize: 15,
                          ),
                          decoration: _inputDecoration(
                            'Last Name',
                            Icons.badge_outlined,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Last Name is required';
                            if (value.length >= 20)
                              return 'Last name length too long';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _studentNumberController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: Color(0xFFE0E0E0),
                            fontSize: 15,
                          ),
                          decoration: _inputDecoration(
                            'Student Number',
                            Icons.numbers_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: state.status == ProfileStatus.loading
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
                              'Save Profile',
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
      ),
    );
  }
}
