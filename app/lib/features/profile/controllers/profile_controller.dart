import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../services/profile_service.dart';
import '../../auth/controllers/auth_controller.dart';

final profileControllerProvider =
    AsyncNotifierProvider<ProfileController, UserProfile?>(() {
  return ProfileController();
});

class ProfileController extends AsyncNotifier<UserProfile?> {
  late final ProfileService _profileService;

  @override
  Future<UserProfile?> build() async {
    _profileService = ref.read(profileServiceProvider);

    // Get the current user ID from auth controller
    final userId = ref.read(authControllerProvider)?.uid;
    if (userId == null) return null;

    return _fetchProfile(userId);
  }

  Future<UserProfile?> _fetchProfile(String userId) async {
    try {
      return await _profileService.getProfile(userId);
    } catch (e) {
      // You might want to log the error here
      rethrow;
    }
  }

  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
    String? bio,
  }) async {
    final userId = ref.read(authControllerProvider)?.uid;
    if (userId == null) throw Exception('User not authenticated');

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final currentProfile = await _fetchProfile(userId);

      final updatedProfile = currentProfile?.copyWith(
        displayName: displayName,
        photoURL: photoURL,
        bio: bio,
      );

      if (updatedProfile != null) {
        await _profileService.updateProfile(profile: updatedProfile);
      }

      return updatedProfile;
    });
  }

  Future<void> updateProfilePhoto(String photoURL) async {
    final userId = ref.read(authControllerProvider)?.uid;
    if (userId == null) throw Exception('User not authenticated');

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final currentProfile = await _fetchProfile(userId);

      final updatedProfile = currentProfile?.copyWith(
        photoURL: photoURL,
      );

      if (updatedProfile != null) {
        await _profileService.updateProfile(profile: updatedProfile);
      }

      return updatedProfile;
    });
  }

  Future<void> refreshProfile() async {
    final userId = ref.read(authControllerProvider)?.uid;
    if (userId == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchProfile(userId));
  }
}
