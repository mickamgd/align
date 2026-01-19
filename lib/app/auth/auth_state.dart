import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

/// État d'authentification (Firebase Auth uniquement)
/// Le profil est géré par ProfileController
@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    User? user,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _AuthState;

  const AuthState._();

  factory AuthState.initial() => const AuthState();
  factory AuthState.loading() => const AuthState(isLoading: true);

  bool get isAuthenticated => user != null;
}
