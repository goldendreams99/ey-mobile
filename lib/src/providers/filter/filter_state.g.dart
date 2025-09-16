// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FilterStateCWProxy {
  FilterState year(int year);

  FilterState state(String state);

  FilterState type(String type);

  FilterState years(List<int> years);

  FilterState states(List<String> states);

  FilterState types(List<String> types);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FilterState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FilterState(...).copyWith(id: 12, name: "My name")
  /// ````
  FilterState call({
    int? year,
    String? state,
    String? type,
    List<int>? years,
    List<String>? states,
    List<String>? types,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFilterState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFilterState.copyWith.fieldName(...)`
class _$FilterStateCWProxyImpl implements _$FilterStateCWProxy {
  const _$FilterStateCWProxyImpl(this._value);

  final FilterState _value;

  @override
  FilterState year(int year) => this(year: year);

  @override
  FilterState state(String state) => this(state: state);

  @override
  FilterState type(String type) => this(type: type);

  @override
  FilterState years(List<int> years) => this(years: years);

  @override
  FilterState states(List<String> states) => this(states: states);

  @override
  FilterState types(List<String> types) => this(types: types);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FilterState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FilterState(...).copyWith(id: 12, name: "My name")
  /// ````
  FilterState call({
    Object? year = const $CopyWithPlaceholder(),
    Object? state = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? years = const $CopyWithPlaceholder(),
    Object? states = const $CopyWithPlaceholder(),
    Object? types = const $CopyWithPlaceholder(),
  }) {
    return FilterState(
      year: year == const $CopyWithPlaceholder() || year == null
          ? _value.year
          // ignore: cast_nullable_to_non_nullable
          : year as int,
      state: state == const $CopyWithPlaceholder() || state == null
          ? _value.state
          // ignore: cast_nullable_to_non_nullable
          : state as String,
      type: type == const $CopyWithPlaceholder() || type == null
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as String,
      years: years == const $CopyWithPlaceholder() || years == null
          ? _value.years
          // ignore: cast_nullable_to_non_nullable
          : years as List<int>,
      states: states == const $CopyWithPlaceholder() || states == null
          ? _value.states
          // ignore: cast_nullable_to_non_nullable
          : states as List<String>,
      types: types == const $CopyWithPlaceholder() || types == null
          ? _value.types
          // ignore: cast_nullable_to_non_nullable
          : types as List<String>,
    );
  }
}

extension $FilterStateCopyWith on FilterState {
  /// Returns a callable class that can be used as follows: `instanceOfFilterState.copyWith(...)` or like so:`instanceOfFilterState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FilterStateCWProxy get copyWith => _$FilterStateCWProxyImpl(this);
}
