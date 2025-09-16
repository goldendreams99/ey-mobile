import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:employ/app.dart';

part 'sign_in_form_state.g.dart';

@CopyWith()
class SignInFormState {
  final String user;
  final String password;
  final String email;

  SignInFormState({
    required this.user,
    required this.password,
    required this.email,
  });

  bool get validUser => user.isNotEmpty;

  bool get valid =>
      user.isNotEmpty && password.isNotEmpty && password.length >= 6;

  bool get canForgot => email.isNotEmpty && validateEmail(email);
}
