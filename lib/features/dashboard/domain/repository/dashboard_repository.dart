import 'package:vems/features/dashboard/domain/model/dashboard_registration_model.dart';
import 'package:vems/features/dashboard/domain/model/profile_model.dart';
import 'package:vems/features/documents/domain/model/registration_model.dart';

abstract class DashboardRepository {
  Future<ProfileModel> getProfile();
  Future<DashboardRegistrationModel> getRegistration();
}