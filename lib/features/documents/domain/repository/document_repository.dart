import 'dart:io';

import 'package:vems/features/documents/domain/model/document_model.dart';

abstract class DocumentRepository {
  Future<DocumentModel> uploadDocument(String documentType, File file);
}