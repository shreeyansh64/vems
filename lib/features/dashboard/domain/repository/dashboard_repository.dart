import 'package:vems/features/dashboard/domain/model/dashboard_registration_model.dart';
import 'package:vems/features/dashboard/domain/model/profile_model.dart';
import 'package:vems/features/dashboard/domain/model/vehicle_model.dart';

abstract class DashboardRepository {
  Future<ProfileModel> getProfile();
  Future<List<DashboardRegistrationModel>> getRegistration();
  Future<List<VehicleModel>> getVehicles();
}