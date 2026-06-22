class DocumentModel {
  final int id;
  final int user;
  final String documentType;
  final String ocrStatus;
  final String verificationStatus;

  DocumentModel({
    required this.id,
    required this.user,
    required this.documentType,
    required this.ocrStatus,
    required this.verificationStatus,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'],
      user: json['user'],
      documentType: json['document_type'], // add this
      ocrStatus: json['ocr_status'],
      verificationStatus: json['verification_status'],
    );
  }
}