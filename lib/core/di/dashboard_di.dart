import 'package:get_it/get_it.dart';
import 'package:vems/features/dashboard/data/data_source/dashboard_remote.dart';
import 'package:vems/features/dashboard/data/repository/dashboard_repository_impl.dart';
import 'package:vems/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:vems/features/dashboard/presentation/bloc/dashboard_bloc.dart';

void registerDashboard(GetIt getIt) {
  getIt.registerLazySingleton<DashboardRemote>(
    () => DashboardRemote(dio: getIt()),
  );
  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(fetchProfileRemote: getIt()),
  );
  getIt.registerFactory<DashboardBloc>(
    () => DashboardBloc(fetchProfileRepository: getIt()),
  );
}
