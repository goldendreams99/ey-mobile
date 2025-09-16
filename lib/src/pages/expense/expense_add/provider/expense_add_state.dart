import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:employ/src/models/expense/client/expense_client.dart';
import 'package:employ/src/models/expense/cost_center/expense_cost_center.dart';
import 'package:employ/src/models/expense/currency/expense_currency.dart';
import 'package:employ/src/models/expense/type/expense_type.dart';

part 'expense_add_state.g.dart';

@CopyWith()
class ExpenseAddState {
  final ExpenseType? type;
  final ExpenseCostCenter? costCenter;
  final ExpenseCurrency? currency;
  final ExpenseClient? client;
  final bool viewStepClient;
  final String? created;
  final String? createdBy;
  final DateTime? date;
  final bool? reimbursable;
  final double? amount;
  final String? observation;
  final int? status;
  final List<String> attachments;
  final List<ExpenseType> types;
  final List<ExpenseCurrency> currencies;
  final List<ExpenseCostCenter> costCenters;
  final List<ExpenseClient> clients;

  ExpenseAddState({
    this.date,
    this.type,
    this.costCenter,
    this.currency,
    this.created,
    this.createdBy,
    this.reimbursable,
    this.amount,
    this.observation,
    this.status,
    this.client,
    required this.viewStepClient,
    required this.attachments,
    required this.types,
    required this.currencies,
    required this.costCenters,
    required this.clients,
  });
}
