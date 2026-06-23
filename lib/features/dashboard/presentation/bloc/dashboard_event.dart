part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardEvent {}

class GetProfileEvent extends DashboardEvent {}

class GetRegistrationStatusEvent extends DashboardEvent {}

class GetVehiclesEvent extends DashboardEvent {}