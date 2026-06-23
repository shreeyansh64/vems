import 'package:vems/features/dashboard/data/data_source/dashboard_remote.dart';
import 'package:vems/features/dashboard/domain/model/dashboard_registration_model.dart';
import 'package:vems/features/dashboard/domain/model/profile_model.dart';
import 'package:vems/features/dashboard/domain/repository/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemote dashboardRemote;
  DashboardRepositoryImpl({required this.dashboardRemote});

  @override
  Future<ProfileModel> getProfile() {
    return dashboardRemote.getProfile();
  }

  @override
  Future<List<DashboardRegistrationModel>> getRegistration() {
    return dashboardRemote.getRegistration();
  }
}
