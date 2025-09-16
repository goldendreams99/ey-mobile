// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AppStateCWProxy {
  AppState company(Company? company);

  AppState employee(Employee? employee);

  AppState settings(CompanySettings? settings);

  AppState employeeSubs(StreamSubscription<DatabaseEvent>? employeeSubs);

  AppState companySubs(StreamSubscription<DatabaseEvent>? companySubs);

  AppState settingsSubs(StreamSubscription<DatabaseEvent>? settingsSubs);

  AppState showClientOnExpense(bool showClientOnExpense);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AppState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AppState(...).copyWith(id: 12, name: "My name")
  /// ````
  AppState call({
    Company? company,
    Employee? employee,
    CompanySettings? settings,
    StreamSubscription<DatabaseEvent>? employeeSubs,
    StreamSubscription<DatabaseEvent>? companySubs,
    StreamSubscription<DatabaseEvent>? settingsSubs,
    bool? showClientOnExpense,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAppState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAppState.copyWith.fieldName(...)`
class _$AppStateCWProxyImpl implements _$AppStateCWProxy {
  const _$AppStateCWProxyImpl(this._value);

  final AppState _value;

  @override
  AppState company(Company? company) => this(company: company);

  @override
  AppState employee(Employee? employee) => this(employee: employee);

  @override
  AppState settings(CompanySettings? settings) => this(settings: settings);

  @override
  AppState employeeSubs(StreamSubscription<DatabaseEvent>? employeeSubs) =>
      this(employeeSubs: employeeSubs);

  @override
  AppState companySubs(StreamSubscription<DatabaseEvent>? companySubs) =>
      this(companySubs: companySubs);

  @override
  AppState settingsSubs(StreamSubscription<DatabaseEvent>? settingsSubs) =>
      this(settingsSubs: settingsSubs);

  @override
  AppState showClientOnExpense(bool showClientOnExpense) =>
      this(showClientOnExpense: showClientOnExpense);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AppState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AppState(...).copyWith(id: 12, name: "My name")
  /// ````
  AppState call({
    Object? company = const $CopyWithPlaceholder(),
    Object? employee = const $CopyWithPlaceholder(),
    Object? settings = const $CopyWithPlaceholder(),
    Object? employeeSubs = const $CopyWithPlaceholder(),
    Object? companySubs = const $CopyWithPlaceholder(),
    Object? settingsSubs = const $CopyWithPlaceholder(),
    Object? showClientOnExpense = const $CopyWithPlaceholder(),
  }) {
    return AppState(
      company: company == const $CopyWithPlaceholder()
          ? _value.company
          // ignore: cast_nullable_to_non_nullable
          : company as Company?,
      employee: employee == const $CopyWithPlaceholder()
          ? _value.employee
          // ignore: cast_nullable_to_non_nullable
          : employee as Employee?,
      settings: settings == const $CopyWithPlaceholder()
          ? _value.settings
          // ignore: cast_nullable_to_non_nullable
          : settings as CompanySettings?,
      employeeSubs: employeeSubs == const $CopyWithPlaceholder()
          ? _value.employeeSubs
          // ignore: cast_nullable_to_non_nullable
          : employeeSubs as StreamSubscription<DatabaseEvent>?,
      companySubs: companySubs == const $CopyWithPlaceholder()
          ? _value.companySubs
          // ignore: cast_nullable_to_non_nullable
          : companySubs as StreamSubscription<DatabaseEvent>?,
      settingsSubs: settingsSubs == const $CopyWithPlaceholder()
          ? _value.settingsSubs
          // ignore: cast_nullable_to_non_nullable
          : settingsSubs as StreamSubscription<DatabaseEvent>?,
      showClientOnExpense:
          showClientOnExpense == const $CopyWithPlaceholder() ||
                  showClientOnExpense == null
              ? _value.showClientOnExpense
              // ignore: cast_nullable_to_non_nullable
              : showClientOnExpense as bool,
    );
  }
}

extension $AppStateCopyWith on AppState {
  /// Returns a callable class that can be used as follows: `instanceOfAppState.copyWith(...)` or like so:`instanceOfAppState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AppStateCWProxy get copyWith => _$AppStateCWProxyImpl(this);
}
