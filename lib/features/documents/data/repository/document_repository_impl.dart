import 'dart:io';
import 'package:vems/features/documents/data/data_source/document_remote.dart';
import 'package:vems/features/documents/domain/model/document_model.dart';
import 'package:vems/features/documents/domain/repository/document_repository.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final DocumentRemote documentRemote;
  DocumentRepositoryImpl({required this.documentRemote});

  @override
  Future<DocumentModel> uploadDocument(String documentType, File file) {
    return documentRemote.uploadDocument(documentType, file);
  }
  
  @override
  Future<String> submitRegistration(int vehicleId) {
    return documentRemote.submitRegistration(vehicleId);
  }
}
