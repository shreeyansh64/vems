import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:vems/features/dashboard/presentation/pages/dashboard_bottom_navbar.dart';
import 'package:vems/features/documents/presentation/bloc/document_bloc.dart';
import 'package:vems/features/vehicle/presentation/bloc/vehicle_bloc.dart';

class DocumentUploadPage extends StatelessWidget {
  const DocumentUploadPage({super.key});

  static const Color _ground = Color(0xFFF4F7FC);
  static const Color _panel = Color(0xFF0C1A2E);
  static const Color _ink = Color(0xFF0C1A2E);
  static const Color _muted = Color(0xFF5A6B85);
  static const Color _hint = Color(0xFF9AA8BF);
  static const Color _field = Color(0xFFF7F9FD);
  static const Color _hairline = Color(0xFFE4E9F2);
  static const Color _accent = Color(0xFF1E50E5);
  static const Color _green = Color(0xFF34D399);
  static const Color _red = Color(0xFFDC2626);
  static const String _mono = 'monospace';

  Future<void> _pickAndUpload(BuildContext context, String documentType) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      context.read<DocumentBloc>().add(
        UploadDocumentEvent(documentType: documentType, file: file),
      );
    }
  }

  String _label(String type) {
    switch (type) {
      case 'RC':
        return 'Registration Certificate';
      case 'DL':
        return 'Driving Licence';
      case 'COLLEGE_ID':
        return 'College ID Card';
      default:
        return type;
    }
  }

  String _sublabel(String type) {
    switch (type) {
      case 'RC':
        return 'Vehicle registration document';
      case 'DL':
        return 'Valid government-issued licence';
      case 'COLLEGE_ID':
        return 'Current academic year ID';
      default:
        return '';
    }
  }

  IconData _docIcon(String type) {
    switch (type) {
      case 'RC':
        return Icons.car_rental_outlined;
      case 'DL':
        return Icons.badge_outlined;
      case 'COLLEGE_ID':
        return Icons.school_outlined;
      default:
        return Icons.description_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DocumentBloc, DocumentState>(
      listener: (context, state) {
        if (state.status == DocumentStatus.registrationSubmitted) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const DashboardBottomNavbar(),
              transitionsBuilder: (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
            ),
          );
        }
        if (state.status == DocumentStatus.error) {
          _showSnack(context, state.errorMessage ?? 'Something went wrong');
        }
        if (state.status == DocumentStatus.failed) {
          _showSnack(
            context,
            'OCR failed for ${state.uploadedDocument?.documentType}. '
            'Please re-upload a clearer image.',
          );
        }
      },
      builder: (context, state) {
        final ocr = state.ocrStatuses;
        final allDone =
            ocr['RC'] == 'COMPLETED' &&
            ocr['DL'] == 'COMPLETED' &&
            ocr['COLLEGE_ID'] == 'COMPLETED';

        final isLoading = state.status == DocumentStatus.loading;

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
                'DOCUMENTS',
                style: TextStyle(
                  fontFamily: _mono,
                  color: _ink,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            body: SafeArea(
              child: isLoading
                  ? const Center(
                      child: CupertinoActivityIndicator(
                        radius: 14,
                        color: _accent,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(22, 4, 22, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                const SizedBox(height: 12),
                                const Text(
                                  'DOCUMENT UPLOAD',
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
                                  'Verify your identity',
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
                                  width: 270,
                                  child: Text(
                                    'Upload clear images or PDFs of each document for OCR verification.',
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

                          const SizedBox(height: 24),
                          _ProgressStrip(ocrStatuses: ocr),

                          const SizedBox(height: 24),
                          const Text(
                            'REQUIRED DOCUMENTS',
                            style: TextStyle(
                              fontFamily: _mono,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0,
                              color: _muted,
                            ),
                          ),
                          const SizedBox(height: 12),

                          ...['RC', 'DL', 'COLLEGE_ID'].map(
                            (type) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _DocTile(
                                type: type,
                                label: _label(type),
                                sublabel: _sublabel(type),
                                icon: _docIcon(type),
                                ocrStatus: ocr[type],
                                onTap: () => _pickAndUpload(context, type),
                              ),
                            ),
                          ),

                          const Spacer(),

                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: allDone
                                ? DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _accent.withValues(
                                            alpha: 0.45,
                                          ),
                                          blurRadius: 22,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        context.read<DocumentBloc>().add(
                                          SubmitRegistrationEvent(
                                            vehicleId: context
                                                .read<VehicleBloc>()
                                                .state
                                                .id!,
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _accent,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Submit for Approval',
                                            style: TextStyle(
                                              fontSize: 15.5,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(width: 9),
                                          Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: null,
                                    style: ElevatedButton.styleFrom(
                                      disabledBackgroundColor: _hairline,
                                      disabledForegroundColor: _hint,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: Text(
                                      _ctaHintText(ocr),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                          ),

                          const SizedBox(height: 16),
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
                                  'ENCRYPTED SESSION · AKGEC',
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
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  String _ctaHintText(Map<String, String?> ocr) {
    final pending = [
      'RC',
      'DL',
      'COLLEGE_ID',
    ].where((t) => ocr[t] != 'COMPLETED').length;
    return '$pending document${pending == 1 ? '' : 's'} remaining';
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

class _ProgressStrip extends StatelessWidget {
  final Map<String, String?> ocrStatuses;
  const _ProgressStrip({required this.ocrStatuses});

  static const Color _accent = Color(0xFF1E50E5);
  static const Color _green = Color(0xFF34D399);
  static const Color _red = Color(0xFFDC2626);
  static const Color _hairline = Color(0xFFE4E9F2);

  @override
  Widget build(BuildContext context) {
    final types = ['RC', 'DL', 'COLLEGE_ID'];
    final completed = types.where((t) => ocrStatuses[t] == 'COMPLETED').length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _hairline, width: 1.5),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$completed',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0C1A2E),
                        height: 1,
                      ),
                    ),
                    const TextSpan(
                      text: ' / 3',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF5A6B85),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                'verified',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  color: Color(0xFF9AA8BF),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: completed / 3,
                minHeight: 6,
                backgroundColor: _hairline,
                valueColor: AlwaysStoppedAnimation(
                  completed == 3 ? _green : _accent,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Row(
            children: types.map((t) {
              final status = ocrStatuses[t];
              final color = status == 'COMPLETED'
                  ? _green
                  : status == 'FAILED'
                  ? _red
                  : _hairline;
              return Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _DocTile extends StatelessWidget {
  final String type;
  final String label;
  final String sublabel;
  final IconData icon;
  final String? ocrStatus;
  final VoidCallback onTap;

  const _DocTile({
    required this.type,
    required this.label,
    required this.sublabel,
    required this.icon,
    required this.ocrStatus,
    required this.onTap,
  });

  static const Color _accent = Color(0xFF1E50E5);
  static const Color _green = Color(0xFF34D399);
  static const Color _red = Color(0xFFDC2626);
  static const Color _ink = Color(0xFF0C1A2E);
  static const Color _muted = Color(0xFF5A6B85);
  static const Color _hairline = Color(0xFFE4E9F2);

  @override
  Widget build(BuildContext context) {
    final isCompleted = ocrStatus == 'COMPLETED';
    final isFailed = ocrStatus == 'FAILED';

    final borderColor = isCompleted
        ? _green.withValues(alpha: 0.45)
        : isFailed
        ? _red.withValues(alpha: 0.4)
        : _hairline;

    final iconBg = isCompleted
        ? _green.withValues(alpha: 0.10)
        : isFailed
        ? _red.withValues(alpha: 0.10)
        : _accent.withValues(alpha: 0.08);

    final iconColor = isCompleted
        ? _green
        : isFailed
        ? _red
        : _accent;

    final statusText = isCompleted
        ? 'Pending approval'
        : isFailed
        ? 'OCR failed — re-upload a clearer image'
        : 'Not uploaded yet';

    final statusColor = isCompleted
        ? _green
        : isFailed
        ? _red
        : _muted;

    final statusIcon = isCompleted
        ? Icons.check_circle_rounded
        : isFailed
        ? Icons.error_rounded
        : Icons.upload_file_rounded;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0C1A2E).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: _ink,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(statusIcon, size: 12, color: statusColor),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 12,
                          color: statusColor,
                          fontWeight: isCompleted || isFailed
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
              decoration: BoxDecoration(
                color: isCompleted ? _hairline : _accent,
                borderRadius: BorderRadius.circular(10),
                boxShadow: isCompleted
                    ? []
                    : [
                        BoxShadow(
                          color: _accent.withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
              ),
              child: Text(
                isCompleted ? 'Re-upload' : 'Upload',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: isCompleted ? _muted : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
