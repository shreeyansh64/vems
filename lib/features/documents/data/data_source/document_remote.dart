import 'dart:io';
import 'package:dio/dio.dart';
import 'package:vems/features/documents/domain/model/document_model.dart';

class DocumentRemote {
  final Dio dio;
  DocumentRemote({required this.dio});

  Future<DocumentModel> uploadDocument(String documentType, File file) async {
    try {
      final formData = FormData.fromMap({
        'document_type': documentType,
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      final response = await dio.post('/api/documents/upload/', data: formData);
      return DocumentModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.response?.data['document_type'] ??
          e.response?.data['file'] ??
          e.response?.data['message'] ??
          "Something went wrong";
    }
  }

  Future<String> submitRegistration(int vehicleId) async {
    try {
      final response = await dio.post(
        '/api/registrations/',
        data: {'vehicle': vehicleId},
      );
      return response.data['message'] ?? 'Registration submitted';
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? e.response?.data['vehicle'] ??  'Something went wrong';
    }
  }
}
