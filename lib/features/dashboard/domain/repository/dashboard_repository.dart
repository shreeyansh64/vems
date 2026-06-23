import 'package:vems/features/dashboard/domain/model/dashboard_registration_model.dart';
import 'package:vems/features/dashboard/domain/model/profile_model.dart';

abstract class DashboardRepository {
  Future<ProfileModel> getProfile();
  Future<List<DashboardRegistrationModel>> getRegistration();
}