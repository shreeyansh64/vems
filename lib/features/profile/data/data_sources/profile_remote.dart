import 'package:dio/dio.dart';

class ProfileRemote {
  final Dio dio;
  ProfileRemote({required this.dio});

  Future<void> submitProfile({
    required String firstName,
    required String lastName,
    required String studentNumber,
    String? photoPath,
  }) async {
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
  }
}