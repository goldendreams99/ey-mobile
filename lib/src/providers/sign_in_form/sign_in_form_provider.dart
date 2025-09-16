import 'package:employ/src/providers/sign_in_form/sign_in_form_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInFormNotifier extends StateNotifier<SignInFormState> {
  SignInFormNotifier()
      : super(SignInFormState(
          email: '',
          password: '',
          user: '',
        ));

  setUser(String newValue) {
    state = state.copyWith(user: newValue);
  }

  setPassword(String newValue) {
    state = state.copyWith(password: newValue);
  }

  setEmail(String newValue) {
    state = state.copyWith(email: newValue);
  }
}

final signInFormProvider =
    StateNotifierProvider<SignInFormNotifier, SignInFormState>(
  (ref) => SignInFormNotifier(),
);
