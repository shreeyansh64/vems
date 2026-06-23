import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vems/features/dashboard/domain/model/dashboard_registration_model.dart';
import 'package:vems/features/dashboard/domain/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:vems/features/dashboard/domain/repository/dashboard_repository.dart';



part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository dashboardRepository;

  DashboardBloc({required this.dashboardRepository})
      : super(DashboardState.initial()) {
    on<GetProfileEvent>(onGetProfileEvent);
    on<GetRegistrationStatusEvent>(onGetRegistrationStatusEvent);
  }

  Future onGetProfileEvent(
    GetProfileEvent event,
    Emitter<DashboardState> emit,
  ) async {
    if (state.profile != null) return;
    emit(state.copyWith(status: DashboardStatus.loading));
    try {
      final profile = await dashboardRepository.getProfile();
      emit(state.copyWith(status: DashboardStatus.success, profile: profile));
    } catch (e) {
      emit(state.copyWith(
        status: DashboardStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future onGetRegistrationStatusEvent(
    GetRegistrationStatusEvent event,
    Emitter<DashboardState> emit,
  ) async {
    if (state.registration != null) return;
    emit(state.copyWith(status: DashboardStatus.loading));
    try {
      final registration = await dashboardRepository.getRegistration();
      emit(state.copyWith(status: DashboardStatus.success, registration: registration));
    } catch (e) {
      emit(state.copyWith(
        status: DashboardStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}