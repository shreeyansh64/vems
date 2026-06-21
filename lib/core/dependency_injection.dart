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
import 'package:vems/features/profile/data/data_sources/profile_remote.dart';
import 'package:vems/features/profile/data/repository/profile_repository_impl.dart';
import 'package:vems/features/profile/domain/repository/profile_repository.dart';
import 'package:vems/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:vems/features/vehicle/data/data_source/vehicle_remote.dart';
import 'package:vems/features/vehicle/data/repository/vehicle_repository_impl.dart';
import 'package:vems/features/vehicle/domain/repository/vehicle_repository.dart';
import 'package:vems/features/vehicle/presentation/bloc/vehicle_bloc.dart';

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

  // profile
  getIt.registerLazySingleton<ProfileRemote>(() => ProfileRemote(dio: getIt()));
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(profileRemote: getIt()),
  );
  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(profileRepository: getIt()),
  );

  // vehicle
  getIt.registerLazySingleton<VehicleRemote>(() => VehicleRemote(dio: getIt()));
  getIt.registerLazySingleton<VehicleRepository>(
    () => VehicleRepositoryImpl(vehicleRemote: getIt()),
  );
  getIt.registerFactory<VehicleBloc>(
    () => VehicleBloc(vehicleRepository: getIt()),
  );
}
