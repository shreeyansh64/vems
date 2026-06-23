part of 'document_bloc.dart';

@immutable
abstract class DocumentEvent {}

class UploadDocumentEvent extends DocumentEvent {
  final String documentType;
  final File file;
  UploadDocumentEvent({required this.documentType, required this.file});
}

class SubmitRegistrationEvent extends DocumentEvent {
  final int vehicleId;
  SubmitRegistrationEvent({required this.vehicleId});
}