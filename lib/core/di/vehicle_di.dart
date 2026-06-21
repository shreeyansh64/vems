import 'package:get_it/get_it.dart';

import 'package:vems/features/vehicle/data/data_source/vehicle_remote.dart';
import 'package:vems/features/vehicle/data/repository/vehicle_repository_impl.dart';
import 'package:vems/features/vehicle/domain/repository/vehicle_repository.dart';
import 'package:vems/features/vehicle/presentation/bloc/vehicle_bloc.dart';

void registerVehicle(GetIt getIt) {
  getIt.registerLazySingleton<VehicleRemote>(
    () => VehicleRemote(dio: getIt()),
  );

  getIt.registerLazySingleton<VehicleRepository>(
    () => VehicleRepositoryImpl(vehicleRemote: getIt()),
  );

  getIt.registerFactory(
    () => VehicleBloc(vehicleRepository: getIt()),
  );
}