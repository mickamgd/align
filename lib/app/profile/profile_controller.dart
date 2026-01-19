import 'package:align/app/auth/auth_controller.dart';
import 'package:align/app/profile/profile_state.dart';
import 'package:align/core/logger.dart';
import 'package:align/data/profile/profile_repository.dart';
import 'package:align/domain/profile/user_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileControllerProvider =
    NotifierProvider<ProfileController, ProfileState>(ProfileController.new);

class ProfileController extends Notifier<ProfileState> {
  late final UserProfileRepository _repository;

  @override
  ProfileState build() {
    _repository = ref.read(userProfileRepositoryProvider);
    return ProfileState.initial();
  }

  /// Charger le profil pour un user spécifique (appelé après signIn/signUp)
  void loadProfileForUser(String uid) {
    _loadProfile(uid);
  }

  /// Définir directement le profil (utilisé après signUp quand on a déjà le profil)
  void setProfile(UserProfile profile) {
    state = state.copyWith(profile: profile, isLoading: false);
  }

  /// Reset le profil (appelé après signOut)
  void reset() {
    state = ProfileState.initial();
  }

  Future<void> _loadProfile(String uid) async {
    state = state.copyWith(isLoading: true);

    try {
      final profile = await _repository.getProfile(uid);
      AppLogger.info('Profile loaded successfully', uid);
      state = state.copyWith(profile: profile, isLoading: false);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to load profile',
        error: e,
        stackTrace: stackTrace,
      );
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors du chargement du profil',
      );
    }
  }

  Future<void> updateProfile({
    required String displayName,
    required int emojiIndex,
  }) async {
    final currentUser = ref.read(authControllerProvider).user;
    if (currentUser == null) return;

    state = state.copyWith(isLoading: true);

    try {
      await _repository.updateProfile(
        uid: currentUser.uid,
        displayName: displayName,
        emojiIndex: emojiIndex,
      );

      final updatedProfile = state.profile?.copyWith(
        displayName: displayName,
        emojiIndex: emojiIndex,
      );

      AppLogger.info('Profile updated successfully', currentUser.uid);
      state = state.copyWith(profile: updatedProfile, isLoading: false);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to update profile',
        error: e,
        stackTrace: stackTrace,
      );
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors de la mise à jour du profil',
      );
    }
  }

  Future<void> refresh() async {
    final currentUser = ref.read(authControllerProvider).user;
    if (currentUser != null) {
      await _loadProfile(currentUser.uid);
    }
  }
}
