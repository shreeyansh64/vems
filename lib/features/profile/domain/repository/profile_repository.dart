abstract class ProfileRepository {
  Future<void> submitProfile({
    required String firstName,
    required String lastName,
    required String studentNumber,
    String? photoPath,
  });
}