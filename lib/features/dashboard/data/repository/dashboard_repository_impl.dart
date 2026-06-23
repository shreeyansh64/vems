import 'package:vems/features/dashboard/data/data_source/dashboard_remote.dart';
import 'package:vems/features/dashboard/domain/model/profile_model.dart';
import 'package:vems/features/dashboard/domain/repository/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemote fetchProfileRemote;
  DashboardRepositoryImpl({required this.fetchProfileRemote});

  @override
  Future<ProfileModel> getProfile() {
    return fetchProfileRemote.getProfile();
  }
}