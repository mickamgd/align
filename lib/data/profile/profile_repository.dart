import 'package:align/domain/profile/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepository();
});

class UserProfileRepository {
  final _collection = FirebaseFirestore.instance.collection('users');

  Future<void> createProfile(UserProfile profile) async {
    await _collection.doc(profile.uid).set(profile.toJson());
  }

  Future<UserProfile?> getProfile(String uid) async {
    final doc = await _collection.doc(uid).get();
    if (!doc.exists) return null;
    return UserProfile.fromJson(doc.data()!);
  }

  Future<void> updateProfile({
    required String uid,
    required String displayName,
    required int emojiIndex,
  }) async {
    await _collection.doc(uid).update({
      'displayName': displayName,
      'emojiIndex': emojiIndex,
    });
  }
}
