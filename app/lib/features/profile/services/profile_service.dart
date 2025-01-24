import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:your_app_name/features/profile/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService(
    firestore: FirebaseFirestore.instance,
    functions: FirebaseFunctions.instance,
  );
});

class ProfileService {
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  ProfileService({
    required FirebaseFirestore firestore,
    required FirebaseFunctions functions,
  })  : _firestore = firestore,
        _functions = functions;

  Future<UserProfile?> getProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) return null;
      return UserProfile.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }

  Future<void> updateProfile({
    required UserProfile profile,
  }) async {
    try {
      final data = {
        'userId': profile.id,
        ...profile.toMap(),
      };

      await _functions.httpsCallable('updateProfile').call(data);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<String> uploadProfilePhoto({
    required String userId,
    required String filePath,
  }) async {
    try {
      final data = {
        'userId': userId,
        'filePath': filePath,
      };

      final result = await _functions
          .httpsCallable('generateProfilePhotoUploadUrl')
          .call(data);

      // Return the uploaded file URL
      return result.data['photoURL'] as String;
    } catch (e) {
      throw Exception('Failed to upload profile photo: $e');
    }
  }

  Future<bool> deleteProfile({
    required String userId,
  }) async {
    try {
      final data = {
        'userId': userId,
      };
      await _functions.httpsCallable('deleteProfile').call(data);
      return true;
    } catch (e) {
      return false;
    }
  }
}
