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
  final String? role;

  const SessionState({
    required this.status,
    this.error,
    this.role
  });

  factory SessionState.initial() {
    return const SessionState(
      status: SessionStatus.initial,
    );
  }

  SessionState copyWith({
    SessionStatus? status,
    String? error,
    String? role
  }) {
    return SessionState(
      status: status ?? this.status,
      error: error ?? this.error,
      role: role ?? this.role
    );
  }
}