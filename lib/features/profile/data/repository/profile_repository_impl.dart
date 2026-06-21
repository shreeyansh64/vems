import 'package:vems/features/profile/data/data_sources/profile_remote.dart';
import 'package:vems/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemote profileRemote;

  ProfileRepositoryImpl({required this.profileRemote});
  @override
  Future<void> submitProfile({
    required String firstName,
    required String lastName,
    required String studentNumber,
    String? photoPath,
  }) {
    return profileRemote.submitProfile(
      firstName: firstName,
      lastName: lastName,
      studentNumber: studentNumber,
      photoPath: photoPath,
    );
  }
}
