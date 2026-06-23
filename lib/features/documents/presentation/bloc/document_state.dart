part of 'document_bloc.dart';

enum DocumentStatus { initial, loading, uploaded, failed, error, registrationSubmitted}

class DocumentState {
  final DocumentStatus status;
  final String? errorMessage;
  final RegistrationModel? registration;
  final DocumentModel? uploadedDocument;
  final Map<String, String> ocrStatuses;

  DocumentState._({
    required this.status,
    this.errorMessage,
    this.uploadedDocument,
    this.registration,
    this.ocrStatuses = const {},
  });

  factory DocumentState.initial() => DocumentState._(status: DocumentStatus.initial);

  DocumentState copyWith({
    DocumentStatus? status,
    String? errorMessage,
    RegistrationModel? registration,
    DocumentModel? uploadedDocument,
    Map<String, String>? ocrStatuses,
  }) {
    return DocumentState._(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      registration: registration ?? this.registration,
      uploadedDocument: uploadedDocument ?? this.uploadedDocument,
      ocrStatuses: ocrStatuses ?? this.ocrStatuses,
    );
  }
}