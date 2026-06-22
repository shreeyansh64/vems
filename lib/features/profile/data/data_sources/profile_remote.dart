import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ProfileRemote {
  final Dio dio;
  ProfileRemote({required this.dio});

  Future<void> submitProfile({
    required String firstName,
    required String lastName,
    required String studentNumber,
    String? photoPath,
  }) async {
    try {
      final map = <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'student_number': studentNumber,
    };

    if (photoPath != null) {
      map['photo'] = await MultipartFile.fromFile(
        photoPath,
        filename: photoPath.split('/').last,
      );
    }

    await dio.post(
      '/api/users/profile/',
      data: FormData.fromMap(map),
    );
    } on DioException catch (e) {
      debugPrint(e.response?.data);
      throw e.response?.data["message"] ?? e.response?.data["email"] ?? "Something went wrong"; 
    }
  }
}