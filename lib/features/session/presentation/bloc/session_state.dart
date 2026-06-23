part of 'session_bloc.dart';

enum SessionStatus {
  initial,
  loading,
  unauthenticated,
  profileIncomplete,
  authenticated,
}

class SessionState {
  final SessionStatus status;
  final String? error;

  const SessionState({
    required this.status,
    this.error,
  });

  factory SessionState.initial() {
    return const SessionState(
      status: SessionStatus.initial,
    );
  }

  SessionState copyWith({
    SessionStatus? status,
    String? error,
  }) {
    return SessionState(
      status: status ?? this.status,
      error: error,
    );
  }
}