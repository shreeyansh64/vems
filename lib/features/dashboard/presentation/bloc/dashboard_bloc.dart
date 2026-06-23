import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vems/features/dashboard/domain/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:vems/features/dashboard/domain/repository/dashboard_repository.dart';



part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository fetchProfileRepository;

  DashboardBloc({required this.fetchProfileRepository})
      : super(DashboardState.initial()) {
    on<GetProfileEvent>(onGetProfileEvent);
  }

  Future onGetProfileEvent(
    GetProfileEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));
    try {
      final profile = await fetchProfileRepository.getProfile();
      emit(state.copyWith(status: DashboardStatus.success, profile: profile));
    } catch (e) {
      emit(state.copyWith(
        status: DashboardStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}