import 'package:get_it/get_it.dart';

import 'package:vems/features/profile/data/data_sources/profile_remote.dart';
import 'package:vems/features/profile/data/repository/profile_repository_impl.dart';
import 'package:vems/features/profile/domain/repository/profile_repository.dart';
import 'package:vems/features/profile/presentation/bloc/profile_bloc.dart';

void registerProfile(GetIt getIt) {
  getIt.registerLazySingleton<ProfileRemote>(
    () => ProfileRemote(dio: getIt()),
  );

  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(profileRemote: getIt()),
  );

  getIt.registerFactory(
    () => ProfileBloc(profileRepository: getIt()),
  );
}