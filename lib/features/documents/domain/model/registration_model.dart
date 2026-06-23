class RegistrationModel {
  final int id;
  final String status;
  final String? rejectionReason;
  final List<String> crossValidationWarnings;

  RegistrationModel({
    required this.id,
    required this.status,
    this.rejectionReason,
    required this.crossValidationWarnings,
  });

  factory RegistrationModel.fromJson(Map<String, dynamic> json) {
    return RegistrationModel(
      id: json['id'],
      status: json['status'],
      rejectionReason: json['rejection_reason'],
      crossValidationWarnings: List<String>.from(json['cross_validation_warnings']),
    );
  }
}