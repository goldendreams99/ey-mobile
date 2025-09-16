// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MenuStateCWProxy {
  MenuState isShown(bool isShown);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MenuState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MenuState(...).copyWith(id: 12, name: "My name")
  /// ````
  MenuState call({
    bool? isShown,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMenuState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMenuState.copyWith.fieldName(...)`
class _$MenuStateCWProxyImpl implements _$MenuStateCWProxy {
  const _$MenuStateCWProxyImpl(this._value);

  final MenuState _value;

  @override
  MenuState isShown(bool isShown) => this(isShown: isShown);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MenuState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MenuState(...).copyWith(id: 12, name: "My name")
  /// ````
  MenuState call({
    Object? isShown = const $CopyWithPlaceholder(),
  }) {
    return MenuState(
      isShown: isShown == const $CopyWithPlaceholder() || isShown == null
          ? _value.isShown
          // ignore: cast_nullable_to_non_nullable
          : isShown as bool,
    );
  }
}

extension $MenuStateCopyWith on MenuState {
  /// Returns a callable class that can be used as follows: `instanceOfMenuState.copyWith(...)` or like so:`instanceOfMenuState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MenuStateCWProxy get copyWith => _$MenuStateCWProxyImpl(this);
}
