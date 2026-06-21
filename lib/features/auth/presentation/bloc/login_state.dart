part of 'login_bloc.dart';

enum LoginStatus { initial, loading, success, error }

class LoginState {
  final LoginStatus status;
  final String? error;
  final String? accessToken;
  final String? refreshToken;

  LoginState._({
    required this.status,
    this.error,
    this.accessToken,
    this.refreshToken,
  });

  factory LoginState.initial() => LoginState._(status: LoginStatus.initial);

  LoginState copyWith({
    LoginStatus? status,
    String? error,
    String? accessToken,
    String? refreshToken,
  }) {
    return LoginState._(
      status: status ?? this.status,
      error: error ?? this.error,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
