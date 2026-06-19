import 'package:get_it/get_it.dart';
import 'package:vems/core/api/api_client.dart';
import 'package:vems/features/auth/data/data_source/register_remote.dart';
import 'package:vems/features/auth/data/repository/register_repository_impl.dart';
import 'package:vems/features/auth/domain/repository/register_repository.dart';
import 'package:vems/features/auth/presentation/bloc/register_bloc.dart';

var getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton(ApiClient);
  getIt.registerSingleton(getIt<ApiClient>().getDio());
  getIt.registerLazySingleton(() => RegisterRemote(dio: getIt()));
  getIt.registerLazySingleton<RegisterRepository>(
    () => RegisterRepositoryImpl(registerRemote: getIt()),
  );
  getIt.registerFactory(() => RegisterBloc(registerRepository: getIt()));
}
