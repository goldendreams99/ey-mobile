// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CalendarStateCWProxy {
  CalendarState from(DateTime? from);

  CalendarState to(DateTime? to);

  CalendarState period(bool period);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CalendarState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CalendarState(...).copyWith(id: 12, name: "My name")
  /// ````
  CalendarState call({
    DateTime? from,
    DateTime? to,
    bool? period,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCalendarState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCalendarState.copyWith.fieldName(...)`
class _$CalendarStateCWProxyImpl implements _$CalendarStateCWProxy {
  const _$CalendarStateCWProxyImpl(this._value);

  final CalendarState _value;

  @override
  CalendarState from(DateTime? from) => this(from: from);

  @override
  CalendarState to(DateTime? to) => this(to: to);

  @override
  CalendarState period(bool period) => this(period: period);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CalendarState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CalendarState(...).copyWith(id: 12, name: "My name")
  /// ````
  CalendarState call({
    Object? from = const $CopyWithPlaceholder(),
    Object? to = const $CopyWithPlaceholder(),
    Object? period = const $CopyWithPlaceholder(),
  }) {
    return CalendarState(
      from: from == const $CopyWithPlaceholder()
          ? _value.from
          // ignore: cast_nullable_to_non_nullable
          : from as DateTime?,
      to: to == const $CopyWithPlaceholder()
          ? _value.to
          // ignore: cast_nullable_to_non_nullable
          : to as DateTime?,
      period: period == const $CopyWithPlaceholder() || period == null
          ? _value.period
          // ignore: cast_nullable_to_non_nullable
          : period as bool,
    );
  }
}

extension $CalendarStateCopyWith on CalendarState {
  /// Returns a callable class that can be used as follows: `instanceOfCalendarState.copyWith(...)` or like so:`instanceOfCalendarState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CalendarStateCWProxy get copyWith => _$CalendarStateCWProxyImpl(this);
}
