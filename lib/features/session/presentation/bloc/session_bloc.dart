import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vems/features/dashboard/domain/repository/dashboard_repository.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final FlutterSecureStorage storage;
  final DashboardRepository dashboardRepository;

  SessionBloc({
    required this.storage,
    required this.dashboardRepository,
  }) : super(SessionState.initial()) {
    on<CheckSessionEvent>(_onCheckSession);
    on<ProfileCompletedEvent>(_onProfileCompleted);
  }

  Future<void> _onCheckSession(
    CheckSessionEvent event,
    Emitter<SessionState> emit,
  ) async {
    emit(state.copyWith(status: SessionStatus.loading));

    try {
      final token = await storage.read(key: 'access_token');
      if (token == null) {
        emit(state.copyWith(status: SessionStatus.unauthenticated));
        return;
      }

      final profile = await dashboardRepository.getProfile();

      if (profile.firstName == null || profile.firstName!.trim().isEmpty) {
        emit(state.copyWith(status: SessionStatus.profileIncomplete));
      } else {
        emit(state.copyWith(status: SessionStatus.authenticated));
      }
    } catch (_) {
      emit(state.copyWith(status: SessionStatus.unauthenticated));
    }
  }

  void _onProfileCompleted(
    ProfileCompletedEvent event,
    Emitter<SessionState> emit,
  ) {
    emit(state.copyWith(status: SessionStatus.authenticated));
  }
}