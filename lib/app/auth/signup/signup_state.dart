class SignupState {
  const SignupState({
    this.displayName = '',
    this.emojiIndex,
    this.email = '',
    this.password = '',
    this.step = 0,
  });

  final String displayName;
  final int? emojiIndex;
  final String email;
  final String password;
  final int step;

  bool get isIdentityValid => displayName.length >= 3 && emojiIndex != null;

  bool get isCredentialsValid => email.contains('@') && password.length >= 6;

  SignupState copyWith({
    String? displayName,
    int? emojiIndex,
    String? email,
    String? password,
    int? step,
  }) {
    return SignupState(
      displayName: displayName ?? this.displayName,
      emojiIndex: emojiIndex ?? this.emojiIndex,
      email: email ?? this.email,
      password: password ?? this.password,
      step: step ?? this.step,
    );
  }
}
