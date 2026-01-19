import 'package:align/domain/profile/user_profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_state.freezed.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    UserProfile? profile,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _ProfileState;

  const ProfileState._();

  factory ProfileState.initial() => const ProfileState();
}
