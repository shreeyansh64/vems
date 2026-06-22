import 'package:get_it/get_it.dart';
import 'package:vems/features/documents/data/data_source/document_remote.dart';
import 'package:vems/features/documents/data/repository/document_repository_impl.dart';
import 'package:vems/features/documents/domain/repository/document_repository.dart';
import 'package:vems/features/documents/presentation/bloc/document_bloc.dart';

void registerDocument(GetIt getIt) {
  getIt.registerLazySingleton<DocumentRemote>(
    () => DocumentRemote(dio: getIt()),
  );
  getIt.registerLazySingleton<DocumentRepository>(
    () => DocumentRepositoryImpl(documentRemote: getIt()),
  );
  getIt.registerFactory<DocumentBloc>(
    () => DocumentBloc(documentRepository: getIt()),
  );
}
