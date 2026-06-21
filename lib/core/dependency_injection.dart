import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:vems/core/api/api_client.dart';
import 'package:vems/features/auth/data/data_source/login_remote.dart';
import 'package:vems/features/auth/data/data_source/register_remote.dart';
import 'package:vems/features/auth/data/repository/login_repository_impl.dart';
import 'package:vems/features/auth/data/repository/register_repository_impl.dart';
import 'package:vems/features/auth/domain/repository/login_repository.dart';
import 'package:vems/features/auth/domain/repository/register_repository.dart';
import 'package:vems/features/auth/presentation/bloc/login_bloc.dart';
import 'package:vems/features/auth/presentation/bloc/register_bloc.dart';

var getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  getIt.registerLazySingleton<ApiClient>(() => ApiClient(storage: getIt()));
  getIt.registerLazySingleton<Dio>(() => getIt<ApiClient>().getDio());

  // register
  getIt.registerLazySingleton<RegisterRemote>(
    () => RegisterRemote(dio: getIt()),
  );
  getIt.registerLazySingleton<RegisterRepository>(
    () => RegisterRepositoryImpl(registerRemote: getIt()),
  );
  getIt.registerFactory<RegisterBloc>(
    () => RegisterBloc(registerRepository: getIt()),
  );

  // login
  getIt.registerLazySingleton<LoginRemote>(() => LoginRemote(dio: getIt()));
  getIt.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(loginRemote: getIt()),
  );
  getIt.registerFactory<LoginBloc>(() => LoginBloc(loginRepository: getIt()));
}
