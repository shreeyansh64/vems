import 'package:vems/features/dashboard/domain/model/profile_model.dart';

abstract class DashboardRepository {
  Future<ProfileModel> getProfile();
}