import 'package:align/app/auth/signup/signup_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signupControllerProvider =
    NotifierProvider<SignupController, SignupState>(SignupController.new);

class SignupController extends Notifier<SignupState> {
  @override
  SignupState build() => const SignupState();

  void setIdentity(String name, int emojiIndex) {
    state = state.copyWith(displayName: name, emojiIndex: emojiIndex);
  }

  void setCredentials(String email, String password) {
    state = state.copyWith(email: email, password: password);
  }

  void next() {
    state = state.copyWith(step: state.step + 1);
  }

  void back() {
    state = state.copyWith(step: state.step - 1);
  }

  void setDisplayName(String value) =>
      state = state.copyWith(displayName: value);

  void setEmojiIndex(int index) => state = state.copyWith(emojiIndex: index);

  void setEmail(String value) => state = state.copyWith(email: value);

  void setPassword(String value) => state = state.copyWith(password: value);

  void nextStep() => state = state.copyWith(step: state.step + 1);

  void previousStep() => state = state.copyWith(step: state.step - 1);

  void reset() => state = const SignupState();
}
