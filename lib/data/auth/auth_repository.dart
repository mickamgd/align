import 'package:align/data/auth/firebase_auth_service.dart';
import 'package:align/data/profile/profile_repository.dart';
import 'package:align/domain/profile/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    authService: ref.read(firebaseAuthServiceProvider),
    profileRepository: ref.read(userProfileRepositoryProvider),
  );
});

/// Repository qui orchestre Auth + Profile de manière atomique
/// Garantit la cohérence entre Firebase Auth et Firestore
class AuthRepository {
  AuthRepository({
    required FirebaseAuthService authService,
    required UserProfileRepository profileRepository,
  }) : _authService = authService,
       _profileRepository = profileRepository;

  final FirebaseAuthService _authService;
  final UserProfileRepository _profileRepository;

  Stream<User?> get authStateChanges => _authService.authStateChanges;
  User? get currentUser => _authService.currentUser;

  /// Sign up avec transaction atomique : Firebase Auth + Firestore Profile
  /// En cas d'échec Firestore, rollback du user Firebase
  Future<SignUpResult> signUp({
    required String email,
    required String password,
    required String displayName,
    required int emojiIndex,
  }) async {
    UserCredential? credential;

    try {
      // 1. Créer Firebase Auth User
      credential = await _authService.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );

      if (credential.user == null) {
        return SignUpResult.failure('Échec de création du compte');
      }

      // 2. Créer Firestore Profile
      final profile = UserProfile(
        uid: credential.user!.uid,
        displayName: displayName,
        emojiIndex: emojiIndex,
        createdAt: DateTime.now(),
      );

      await _profileRepository.createProfile(profile);

      return SignUpResult.success(credential.user, profile);
    } on FirebaseAuthException catch (e) {
      return SignUpResult.failure(_mapFirebaseError(e));
    } catch (e) {
      // Rollback: supprimer le user Firebase si la création du profil a échoué
      if (credential?.user != null) {
        try {
          await credential!.user!.delete();
        } catch (_) {
          // Ignore les erreurs de suppression, on retourne déjà une erreur
        }
      }

      return SignUpResult.failure(
        'Erreur lors de la création du profil. Veuillez réessayer.',
      );
    }
  }

  /// Sign in simple
  Future<SignInResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _authService.signInWithEmail(email: email, password: password);

      final user = _authService.currentUser;
      if (user == null) {
        return SignInResult.failure('Échec de connexion');
      }

      // Charger le profile
      final profile = await _profileRepository.getProfile(user.uid);

      return SignInResult.success(user, profile);
    } on FirebaseAuthException catch (e) {
      return SignInResult.failure(_mapFirebaseError(e));
    } catch (e) {
      return SignInResult.failure('Erreur de connexion');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _authService.signOut();
  }

  /// Charger le profile pour un user existant
  Future<UserProfile?> getProfile(String uid) async {
    return _profileRepository.getProfile(uid);
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Aucun compte associé à cet email';
      case 'wrong-password':
        return 'Mot de passe incorrect';
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé';
      case 'weak-password':
        return 'Mot de passe trop faible (6 caractères minimum)';
      case 'invalid-email':
        return 'Email invalide';
      case 'invalid-credential':
        return 'Email ou mot de passe incorrect';
      default:
        return 'Erreur d\'authentification';
    }
  }
}

/// Result objects pour type-safety

class SignUpResult {
  SignUpResult.success(this.user, this.profile)
    : isSuccess = true,
      errorMessage = null;

  SignUpResult.failure(this.errorMessage)
    : isSuccess = false,
      user = null,
      profile = null;

  final bool isSuccess;
  final User? user;
  final UserProfile? profile;
  final String? errorMessage;
}

class SignInResult {
  SignInResult.success(this.user, this.profile)
    : isSuccess = true,
      errorMessage = null;

  SignInResult.failure(this.errorMessage)
    : isSuccess = false,
      user = null,
      profile = null;

  final bool isSuccess;
  final User? user;
  final UserProfile? profile;
  final String? errorMessage;
}
