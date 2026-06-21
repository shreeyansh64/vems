import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:vems/features/profile/domain/repository/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileState.initial()) {
    on<SubmitProfileEvent>(onSubmitProfileEvent);
  }

  Future<void> onSubmitProfileEvent(
    SubmitProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      await profileRepository.submitProfile(
        firstName: event.firstName,
        lastName: event.lastName,
        studentNumber: event.studentNumber,
        photoPath: event.photoPath,
      );
      emit(state.copyWith(status: ProfileStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.error, error: e.toString()));
    }
  }
}