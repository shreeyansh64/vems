class ProfileModel {
  final int id;
  final String firstName;
  final String lastName;
  final String studentNumber;
  final String? photo;

  ProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.studentNumber,
    this.photo,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      studentNumber: json['student_number'],
      photo: json['photo'],
    );
  }
}