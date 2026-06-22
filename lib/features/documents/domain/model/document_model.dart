class DocumentModel {
  final int id;
  final int user;
  final String ocrStatus;
  final String verificationStatus;

  DocumentModel({
    required this.id,
    required this.user,
    required this.ocrStatus,
    required this.verificationStatus,
  });
}