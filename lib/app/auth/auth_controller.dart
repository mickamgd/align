import 'package:align/app/auth/auth_state.dart';
import 'package:align/app/profile/profile_controller.dart';
import 'package:align/core/logger.dart';
import 'package:align/data/auth/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

/// Controller pour l'authentification uniquement (Firebase Auth)
/// La gestion du profil est déléguée à ProfileController
class AuthController extends Notifier<AuthState> {
  late final AuthRepository _repository;

  @override
  AuthState build() {
    _repository = ref.read(authRepositoryProvider);

    final authStateChangesListener = _repository.authStateChanges.listen((
      user,
    ) {
      state = state.copyWith(user: user);

      if (user != null) {
        ref
            .read(profileControllerProvider.notifier)
            .loadProfileForUser(user.uid);
      } else {
        ref.read(profileControllerProvider.notifier).reset();
      }
    });

    ref.onDispose(authStateChangesListener.cancel);

    final currentUser = _repository.currentUser;

    if (currentUser != null) {
      return AuthState(user: currentUser);
    }

    return AuthState.initial();
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
    required int emojiIndex,
  }) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _repository.signUp(
      email: email,
      password: password,
      displayName: displayName,
      emojiIndex: emojiIndex,
    );

    if (result.isSuccess) {
      AppLogger.info('Sign up successful', result.user?.email);
      state = state.copyWith(
        user: result.user,
        isLoading: false,
        errorMessage: null,
      );

      // Mettre à jour immédiatement le profil avec celui retourné par signUp
      if (result.profile != null) {
        ref
            .read(profileControllerProvider.notifier)
            .setProfile(result.profile!);
      }
    } else {
      AppLogger.error('Sign up failed', error: result.errorMessage);
      state = state.copyWith(
        isLoading: false,
        errorMessage: result.errorMessage,
      );
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _repository.signIn(email: email, password: password);

    if (result.isSuccess) {
      AppLogger.info('Sign in successful', result.user?.email);
      state = state.copyWith(
        user: result.user,
        isLoading: false,
        errorMessage: null,
      );
    } else {
      AppLogger.error('Sign in failed', error: result.errorMessage);
      state = state.copyWith(
        isLoading: false,
        errorMessage: result.errorMessage,
      );
    }
  }

  Future<void> signOut() async {
    AppLogger.info('User signing out', state.user?.email);
    await _repository.signOut();
  }
}
