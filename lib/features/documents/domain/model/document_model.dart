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

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'],
      user: json['user'],
      ocrStatus: json['ocr_status'],
      verificationStatus: json['verification_status'],
    );
  }
}
