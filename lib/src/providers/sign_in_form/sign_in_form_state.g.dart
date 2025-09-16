// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_form_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SignInFormStateCWProxy {
  SignInFormState user(String user);

  SignInFormState password(String password);

  SignInFormState email(String email);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SignInFormState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SignInFormState(...).copyWith(id: 12, name: "My name")
  /// ````
  SignInFormState call({
    String? user,
    String? password,
    String? email,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSignInFormState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSignInFormState.copyWith.fieldName(...)`
class _$SignInFormStateCWProxyImpl implements _$SignInFormStateCWProxy {
  const _$SignInFormStateCWProxyImpl(this._value);

  final SignInFormState _value;

  @override
  SignInFormState user(String user) => this(user: user);

  @override
  SignInFormState password(String password) => this(password: password);

  @override
  SignInFormState email(String email) => this(email: email);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SignInFormState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SignInFormState(...).copyWith(id: 12, name: "My name")
  /// ````
  SignInFormState call({
    Object? user = const $CopyWithPlaceholder(),
    Object? password = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
  }) {
    return SignInFormState(
      user: user == const $CopyWithPlaceholder() || user == null
          ? _value.user
          // ignore: cast_nullable_to_non_nullable
          : user as String,
      password: password == const $CopyWithPlaceholder() || password == null
          ? _value.password
          // ignore: cast_nullable_to_non_nullable
          : password as String,
      email: email == const $CopyWithPlaceholder() || email == null
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String,
    );
  }
}

extension $SignInFormStateCopyWith on SignInFormState {
  /// Returns a callable class that can be used as follows: `instanceOfSignInFormState.copyWith(...)` or like so:`instanceOfSignInFormState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SignInFormStateCWProxy get copyWith => _$SignInFormStateCWProxyImpl(this);
}
