class DashboardRegistrationModel {
  final int id;
  final int user;
  final int vehicle;
  final String status;
  final String? rejectionReason;
  final List<dynamic> crossValidationWarnings;
  final DateTime submittedAt;
  final DateTime? reviewedAt;

  DashboardRegistrationModel({
    required this.id,
    required this.user,
    required this.vehicle,
    required this.status,
    required this.rejectionReason,
    required this.crossValidationWarnings,
    required this.submittedAt,
    required this.reviewedAt,
  });

  factory DashboardRegistrationModel.fromJson(Map<String, dynamic> json) {
    return DashboardRegistrationModel(
      id: json['id'],
      user: json['user'],
      vehicle: json['vehicle'],
      status: json['status'],
      rejectionReason: json['rejection_reason'],
      crossValidationWarnings: json['cross_validation_warnings'] ?? [],
      submittedAt: DateTime.parse(json['submitted_at']),
      reviewedAt: json['reviewed_at'] != null
          ? DateTime.parse(json['reviewed_at'])
          : null,
    );
  }
}
