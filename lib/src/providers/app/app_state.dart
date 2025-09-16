import 'dart:async';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:employ/src/models/index.dart';
import 'package:firebase_database/firebase_database.dart';

part 'app_state.g.dart';

@CopyWith()
class AppState {
  final Company? company;
  final Employee? employee;
  final CompanySettings? settings;
  final bool showClientOnExpense;

  final StreamSubscription<DatabaseEvent>? employeeSubs;
  final StreamSubscription<DatabaseEvent>? companySubs;
  final StreamSubscription<DatabaseEvent>? settingsSubs;

  AppState({
    this.company,
    this.employee,
    this.settings,
    this.employeeSubs,
    this.companySubs,
    this.settingsSubs,
    required this.showClientOnExpense,
  });

  bool get valid => company != null && employee != null && settings != null;
}
