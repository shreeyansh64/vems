part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class SubmitProfileEvent extends ProfileEvent {
  final String firstName;
  final String lastName;
  final String studentNumber;
  final String? photoPath; 

  SubmitProfileEvent({
    required this.firstName,
    required this.lastName,
    required this.studentNumber,
    this.photoPath,
  });
}