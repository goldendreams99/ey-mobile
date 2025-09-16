import 'package:employ/src/config/application.dart';
import 'package:employ/src/helpers/date_time.dart';
import 'package:employ/src/models/expense/attachment/expense_attachment.dart';
import 'package:employ/src/models/expense/client/expense_client.dart';
import 'package:employ/src/models/expense/cost_center/expense_cost_center.dart';
import 'package:employ/src/models/expense/currency/expense_currency.dart';
import 'package:employ/src/models/expense/employee/expense_employee.dart';
import 'package:employ/src/models/expense/expense.dart';
import 'package:employ/src/models/expense/type/expense_type.dart';
import 'package:employ/src/models/index.dart';
import 'package:employ/src/providers/app/app_state.dart';
import 'package:employ/src/providers/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'expense_add_state.dart';

class ExpenseAddNotifier extends StateNotifier<ExpenseAddState> {
  ExpenseAddNotifier()
      : super(ExpenseAddState(
          viewStepClient: false,
          attachments: [],
          types: [],
          currencies: [],
          costCenters: [],
          clients: [],
        ));

  Future<void> saveExpense({
    required AppState manager,
    required EmployProvider employ,
    required AppConfig config,
    required List<ExpenseAttachment> attachments,
  }) async {
    final employee = manager.employee!.apiExpenseData();
    final expense = Expense(
      type: state.type,
      costCenter: state.costCenter,
      currency: state.currency,
      created: DateTime.now().formattedDate,
      createdBy: '(Portal) - ${manager.employee!.name}',
      reportedDate: state.date?.formattedDate,
      year: DateTime.now().formattedYear,
      month: DateTime.now().formattedMonth,
      period: DateTime.now().formattedPeriod,
      reimbursable: state.reimbursable ?? false,
      value: state.amount,
      observation: state.observation,
      status: manager.settings!.expenseAuthApprover ? 1 : 2,
      employee: ExpenseEmployee.fromJson(employee),
      attachments: attachments,
      id: null,
      reply: null,
      client: state.client,
    );
    String? id = await employ.database.push(
      'client/${manager.company!.id}/expense/',
      expense.toJson(),
    );
    Expense.notify(
      config: config,
      company: manager.company!,
      expenseId: id!,
    );
  }

  void setAmount(double? newValue) {
    state = state.copyWith(amount: newValue ?? state.amount);
  }

  void setDate(DateTime? date) {
    state = state.copyWith(date: date ?? state.date);
  }

  void addAttachment({required String path}) {
    state = state.copyWith(attachments: [...state.attachments, path]);
  }

  void removeAttachment({required String path}) {
    state = state.copyWith(
        attachments:
            state.attachments.where((element) => element != path).toList());
  }

  void setType({required ExpenseType type}) {
    state = state.copyWith(type: type);
  }

  void setObservation(String text) {
    state = state.copyWith(observation: text);
  }

  void setCurrency(ExpenseCurrency values) {
    state = state.copyWith(currency: values);
  }

  void setReimbursable({required bool reimbursable}) {
    state = state.copyWith(reimbursable: reimbursable);
  }

  void setCostCenter({required ExpenseCostCenter costCenter}) {
    state = state.copyWith(costCenter: costCenter);
  }

  void setClient({required ExpenseClient client}) {
    state = state.copyWith(client: client);
  }

  void setViewStepClient({required bool viewStepClient}) {
    state = state.copyWith(viewStepClient: viewStepClient);
  }

  Future<void> fetchSetting({
    required Company company,
    required EmployProvider provider,
  }) async {
    String ref = 'client/${company.id}/setting';
    final values = await provider.database.once(ref);
    // Expense Types
    final List<ExpenseType> types = [];
    if (values?['expense_type'] != null) {
      values!['expense_type']
          .forEach((k, v) => types.add(ExpenseType.fromJson(v)));
    }
    types.sort((a, b) => a.name!.compareTo(b.name!));
    // Expense Currencies
    List<ExpenseCurrency> currencies = [];
    if (values?['currency'] != null) {
      values!['currency']
          .forEach((k, v) => currencies.add(ExpenseCurrency.fromJson(v)));
    }
    currencies.sort((a, b) => a.name!.compareTo(b.name!));
    // Expense Cost Centers
    List<ExpenseCostCenter> costCenters = [];
    if (values?['costcenter'] != null) {
      values!['costcenter']
          .forEach((k, v) => costCenters.add(ExpenseCostCenter.fromJson(v)));
    }
    costCenters.sort((a, b) => a.name!.compareTo(b.name!));
    // Expense Clients
    List<ExpenseClient> clients = [];
    if (values?['client'] != null) {
      values!['client']
          .forEach((k, v) => clients.add(ExpenseClient.fromJson(v)));
    }
    clients.sort((a, b) => a.name!.compareTo(b.name!));
    // Notify
    state = state.copyWith(
      types: [...types],
      currencies: [...currencies],
      costCenters: [...costCenters],
      clients: [...clients],
    );
  }
}

final expenseAddProvider =
    StateNotifierProvider<ExpenseAddNotifier, ExpenseAddState>(
  (ref) => ExpenseAddNotifier(),
);
