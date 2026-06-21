import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:vems/core/api/api_client.dart';

void registerCore(GetIt getIt) {
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(storage: getIt()),
  );

  getIt.registerLazySingleton<Dio>(
    () => getIt<ApiClient>().getDio(),
  );
}