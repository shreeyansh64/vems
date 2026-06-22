import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:vems/features/auth/presentation/pages/dashboard.dart';
import 'package:vems/features/documents/presentation/bloc/document_bloc.dart';

class DocumentUploadPage extends StatelessWidget {
  const DocumentUploadPage({super.key});

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
        return 'College ID';
      default:
        return type;
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
        if (state.status == DocumentStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFFCF6679),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              content: Text(
                state.errorMessage ?? 'Something went wrong',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }
        if (state.status == DocumentStatus.failed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFFCF6679),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              content: Text(
                'OCR failed for ${state.uploadedDocument?.documentType}, please re-upload a clearer image',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final ocr = state.ocrStatuses;
        final allDone =
            ocr['RC'] == 'COMPLETED' &&
            ocr['DL'] == 'COMPLETED' &&
            ocr['COLLEGE_ID'] == 'COMPLETED';

        return Scaffold(
          backgroundColor: const Color(0xFF0D0D0D),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0D0D0D),
            elevation: 0,
            centerTitle: true,
            leading: const BackButton(color: Color(0xFFE0E0E0)),
            title: const Text(
              'Upload Documents',
              style: TextStyle(
                color: Color(0xFFE0E0E0),
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          body: state.status == DocumentStatus.loading
              ? const Center(
                  child: CupertinoActivityIndicator(
                    radius: 14,
                    color: Color(0xFFFFAB00),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      const Text(
                        'Verify Documents',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFE0E0E0),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Upload clear images or PDFs of each document.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B6B6B),
                        ),
                      ),
                      const SizedBox(height: 32),

                      const Text(
                        'REQUIRED DOCUMENTS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B6B6B),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),

                      ...['RC', 'DL', 'COLLEGE_ID'].map(
                        (type) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _docTile(context, type, ocr[type]),
                        ),
                      ),

                      const Spacer(),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: allDone
                              ? () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          const Dashboard(),
                                      transitionsBuilder:
                                          (_, animation, __, child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                    ),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFAB00),
                            foregroundColor: const Color(0xFF0D0D0D),
                            disabledBackgroundColor: const Color(0xFF2A2A2A),
                            disabledForegroundColor: const Color(0xFF6B6B6B),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Proceed',
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
                ),
        );
      },
    );
  }

  Widget _docTile(BuildContext context, String type, String? ocrStatus) {
    final isCompleted = ocrStatus == 'COMPLETED';
    final isFailed = ocrStatus == 'FAILED';

    final statusColor = isCompleted
        ? const Color(0xFF4CAF50)
        : isFailed
        ? const Color(0xFFCF6679)
        : const Color(0xFF6B6B6B);

    final statusText = isCompleted
        ? 'Verified'
        : isFailed
        ? 'Failed — re-upload'
        : 'Not uploaded';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCompleted
              ? const Color(0xFF4CAF50).withOpacity(0.4)
              : isFailed
              ? const Color(0xFFCF6679).withOpacity(0.4)
              : const Color(0xFF2A2A2A),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF111111),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _docIcon(type),
              color: const Color(0xFFFFAB00),
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _label(type),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE0E0E0),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  statusText,
                  style: TextStyle(fontSize: 12, color: statusColor),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _pickAndUpload(context, type),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFF111111)
                    : const Color(0xFFFFAB00),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isCompleted ? 'Re-upload' : 'Upload',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isCompleted
                      ? const Color(0xFF6B6B6B)
                      : const Color(0xFF0D0D0D),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
