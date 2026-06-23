part of 'session_bloc.dart';

abstract class SessionEvent {}

class CheckSessionEvent extends SessionEvent {}

class ProfileCompletedEvent extends SessionEvent {}
