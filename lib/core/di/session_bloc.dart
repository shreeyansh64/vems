import 'package:get_it/get_it.dart';
import 'package:vems/features/session/presentation/bloc/session_bloc.dart';

void registerSession(GetIt getIt) {
  getIt.registerFactory(
    () => SessionBloc(
      storage: getIt(),
      dashboardRepository: getIt(),
    ),
  );
}