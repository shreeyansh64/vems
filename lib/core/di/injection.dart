import 'package:get_it/get_it.dart';

import 'core_di.dart';
import 'auth_di.dart';
import 'profile_di.dart';
import 'vehicle_di.dart';

final getIt = GetIt.instance;

void setup() {
  registerCore(getIt);
  registerAuth(getIt);
  registerProfile(getIt);
  registerVehicle(getIt);
}