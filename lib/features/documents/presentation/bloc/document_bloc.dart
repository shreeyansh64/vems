import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vems/features/documents/domain/model/document_model.dart';
import 'package:vems/features/documents/domain/repository/document_repository.dart';

part 'document_event.dart';
part 'document_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final DocumentRepository documentRepository;

  DocumentBloc({required this.documentRepository})
    : super(DocumentState.initial()) {
    on<UploadDocumentEvent>(onUploadDocumentEvent);
    on<SubmitRegistrationEvent>(onSubmitRegistrationEvent);
  }

  Future onUploadDocumentEvent(
    UploadDocumentEvent event,
    Emitter<DocumentState> emit,
  ) async {
    emit(state.copyWith(status: DocumentStatus.loading));
    try {
      final doc = await documentRepository.uploadDocument(
        event.documentType,
        event.file,
      );

      final updatedOcrStatuses = Map<String, String>.from(state.ocrStatuses);
      updatedOcrStatuses[event.documentType] = doc.ocrStatus;

      if (doc.ocrStatus == 'FAILED') {
        emit(
          state.copyWith(
            status: DocumentStatus.failed,
            uploadedDocument: doc,
            ocrStatuses: updatedOcrStatuses,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: DocumentStatus.uploaded,
            uploadedDocument: doc,
            ocrStatuses: updatedOcrStatuses,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: DocumentStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future onSubmitRegistrationEvent(
    SubmitRegistrationEvent event,
    Emitter<DocumentState> emit,
  ) async {
    emit(state.copyWith(status: DocumentStatus.loading));
    try {
      final message = await documentRepository.submitRegistration(
        event.vehicleId,
      );
      emit(
        state.copyWith(
          status: DocumentStatus.registrationSubmitted,
          message: message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DocumentStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
