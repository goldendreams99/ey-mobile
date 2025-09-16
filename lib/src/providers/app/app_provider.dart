import 'dart:async';
import 'dart:convert';
import 'package:employ/src/providers/app/app_state.dart';
import 'package:http/http.dart' as http;

import 'package:employ/src/config/application.dart';
import 'package:employ/src/models/index.dart';
import 'package:employ/src/providers/index.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppNotifier extends StateNotifier<AppState> {
  AppNotifier() : super(AppState(
    showClientOnExpense: false,
  ));

  void setCompany(Company company) {
    state = state.copyWith(company: company);
  }

  void setEmployee(Employee employee) {
    state = state.copyWith(employee: employee);
  }

  void setSettings(CompanySettings companySettings) {
    state = state.copyWith(settings: companySettings);
  }

  void _generateError(Object o, String target) {
    print('$target Subscription: $o');
  }

  Future<void> _isValid() async {
    final completer = Completer<void>();
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (state.valid) {
        completer.complete();
        timer.cancel();
      }
    });
    return completer.future;
  }

  Future<bool> init(Database db, String companyId, String employeeId) async {
    try {
      String eref = 'client/$companyId/employee/$employeeId';
      String cref = 'client/$companyId/company';
      String sref = 'client/$companyId/customizing';

      Stream<DatabaseEvent> employeeStream = await db.getStream(eref);
      Stream<DatabaseEvent> companyStream = await db.getStream(cref);
      Stream<DatabaseEvent> settingsStream = await db.getStream(sref);

      companyStream.listen(
        (event) {
          setCompany(Company.fromJson(event.snapshot.value ?? Map()));
        },
        onError: (Object o) => _generateError(o, 'Company'),
      );

      settingsStream.listen(
        (event) {
          setSettings(CompanySettings.fromJson(event.snapshot.value ?? Map()));
        },
        onError: (Object o) => _generateError(o, 'Customizing'),
      );

      employeeStream.listen(
        (event) {
          setEmployee(Employee.fromJson(event.snapshot.value ?? Map()));
        },
        onError: (Object o) => _generateError(o, 'Employee'),
      );

      await _isValid();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> close() async {
    await state.companySubs?.cancel();
    await state.settingsSubs?.cancel();
    await state.employeeSubs?.cancel();
  }

  Future<dynamic> faceRecognition(
      AppConfig config, String dorso, String selfie) async {
    String body = jsonEncode({'face_1': selfie, 'face_2': dorso});
    http.Response response = await http.post(
      Uri.parse('${config.apiBaseUrl}/Vision/FaceCompare'),
      headers: config.apiHeaders,
      body: body,
    );
    return response.statusCode == 200 ? jsonDecode(response.body) : null;
  }

  Future<void> hashPin(
    AppConfig config,
    String pin,
    Company company,
    Employee employee,
  ) async {
    String body = jsonEncode({
      'production': config.isProduction,
      'company_id': company.id,
      'employee_id': employee.id,
      'pin': pin
    });
    http.post(
      Uri.parse('${config.apiBaseUrl}/Employee/PinHash'),
      headers: config.apiHeaders,
      body: body,
    );
  }

  Future<void> electronicPin(
    AppConfig config,
    String pin,
    Company company,
    Employee employee,
  ) async {
    String body = jsonEncode({
      'production': config.isProduction,
      'company_id': company.id,
      'company_certificate_key': company.certificateKey,
      'employee_id': employee.id,
      'pin': pin
    });
    await http.post(
      Uri.parse('${config.apiBaseUrl}/Certificate/EmployeeElectronicRequest'),
      headers: config.apiHeaders,
      body: body,
    );
  }

  Future<void> pinReset(
    AppConfig config,
  ) async {
    if (state.company == null || state.employee == null) {
      throw Exception('Company or Employee is null');
    }
    String body = jsonEncode({
      'company_id': state.company!.id,
      'employee_id': state.employee!.id,
    });
    await http.post(
      Uri.parse('${config.apiBaseUrl}/Certificate/PinReset'),
      headers: config.apiHeaders,
      body: body,
    );
  }
}

final appProvider = StateNotifierProvider<AppNotifier, AppState>(
  (ref) => AppNotifier(),
);
