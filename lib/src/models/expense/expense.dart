import 'dart:convert';
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:employ/src/config/application.dart';
import 'package:employ/src/models/expense/attachment/expense_attachment.dart';
import 'package:employ/src/models/expense/client/expense_client.dart';
import 'package:employ/src/models/expense/cost_center/expense_cost_center.dart';
import 'package:employ/src/models/expense/currency/expense_currency.dart';
import 'package:employ/src/models/expense/employee/expense_employee.dart';
import 'package:employ/src/models/expense/type/expense_type.dart';
import 'package:employ/src/models/index.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

part 'expense.g.dart';

@JsonSerializable(explicitToJson: true)
class Expense {
  final String? id;
  @JsonKey(name: 'amount')
  final double? value;
  final String? observation;
  final String? reply;
  @JsonKey(name: 'date')
  final String? reportedDate;
  final String? created;
  final String? year;
  final String? month;
  final String? period;
  @JsonKey(name: 'created_by')
  final String? createdBy;
  final bool reimbursable;
  final int? status;
  final ExpenseCurrency? currency;
  @JsonKey(name: 'costcenter')
  final ExpenseCostCenter? costCenter;
  final ExpenseType? type;
  final ExpenseEmployee? employee;
  final ExpenseClient? client;
  final List<ExpenseAttachment>? attachments;

  Expense({
    required this.id,
    required this.currency,
    required this.value,
    required this.costCenter,
    required this.observation,
    required this.reply,
    required this.attachments,
    required this.reportedDate,
    required this.created,
    required this.year,
    required this.reimbursable,
    required this.status,
    required this.type,
    required this.month,
    required this.period,
    required this.createdBy,
    required this.employee,
    required this.client,
  });

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseToJson(this);

  bool get isApproved => status == 3;

  bool get isPending => (status ?? 0) <= 2;

  bool get isRejected => status == 4;

  bool get isRemovable => (status ?? 0) <= 2 && (status ?? 0) > 0;

  String? get name => type?.name;

  String? get label {
    if (created == null) return null;
    final String dueDate =
        formatDate(DateTime.parse(created!), [dd, '/', mm, '/', yyyy]);
    return '$dueDate - $name';
  }

  String? get reportedDateLabel {
    if (reportedDate == null) return null;
    final String dueDate =
        formatDate(DateTime.parse(reportedDate!), [dd, '/', mm, '/', yyyy]);
    return dueDate;
  }

  String? get createdDateLabel {
    if (created == null) return null;
    final String dueDate =
        formatDate(DateTime.parse(created!), [dd, '/', mm, '/', yyyy]);
    return dueDate;
  }

  String? get relative {
    if (created == null) return null;
    final DateTime now = DateTime.now();
    final String createdFormat =
        formatDate(DateTime.parse(created!), [dd, '/', mm, '/', yyyy]);
    final String relativeTime = timeago.format(
      DateTime.parse(created!).subtract(now.timeZoneOffset),
      locale: 'es',
      allowFromNow: false,
    );
    final DateTime tdays = DateTime.now().subtract(Duration(days: 30));
    return DateTime.parse(created!).isBefore(tdays)
        ? createdFormat
        : relativeTime;
  }

  static List<Expense> filter(
    List<Expense> documents,
    int year,
    bool all,
    bool isPending,
    bool approved,
    bool rejected,
    //---------- BEGIN ----------//
    String type,
    //---------- FINISH ----------//
  ) {
    //---------- BEGIN ----------//
    List<Expense> filteredDocuments;
    //---------- FINISH ----------//
    if (all) {
      //---------- BEGIN ----------//
      filteredDocuments = documents.where((item) {
        return item.year == year.toString();
      }).toList();
      //---------- FINISH ----------//
    } else {
      //---------- BEGIN ----------//
      filteredDocuments = documents
          //---------- FINISH ----------//
          .where(
            (item) =>
                item.year == year.toString() &&
                item.isPending == isPending &&
                item.isApproved == approved &&
                item.isRejected == rejected,
          )
          //---------- BEGIN ----------//
          .toList();
    }
    
    // Aplicar filtro de tipo
    if (type != 'Todos') {
      filteredDocuments = filteredDocuments
          .where((item) => item.type?.name == type)
          .toList();
    }
    
    return filteredDocuments;
    //---------- FINISH ----------//
  }

  Future<List<File>> downloadAttachments(BuildContext context) async {
    List<File> files = [];
    if (attachments?.isNotEmpty ?? false) {
      try {
        bool can = await canWriteOnStorage(context);
        if (!can) return [];
        var dir = await getApplicationSupportDirectory();
        final employDir = Directory('${dir.path}/Employ/Media');
        bool employExist = await employDir.exists();
        if (!employExist) await employDir.create(recursive: true);
        List<File> _attachments = attachments!
            .map((attachment) =>
                File('${employDir.path}/expense-${attachment.name}'))
            .toList();
        var exists =
            await Future.wait(_attachments.map((f) => f.exists()).toList());
        bool isdownloaded = List.from(exists).reduce((curr, next) {
          return curr && next;
        });
        if (isdownloaded)
          files = List.from(_attachments);
        else {
          var data = await Future.wait(
            attachments!.map((a) => http.get(Uri.parse(a.url ?? ''))).toList(),
          );
          var bytes = data.map((d) => d.bodyBytes).toList();
          var futures = <Future>[];
          for (var i = 0; i < _attachments.length; i++) {
            futures.add(_attachments[i].writeAsBytes(bytes[i]));
          }
          files = List.from(await Future.wait(futures));
        }
      } catch (e) {
        throw Exception("Error opening url file");
      }
    }
    return files;
  }

  static sort(List<Expense> documents) {
    documents.sort((b, a) {
      if (a.created == null) return 1;
      if (b.created == null) return -1;
      return a.created!.compareTo(b.created!);
    });
  }

  static void notify({
    required AppConfig config,
    required Company company,
    required String expenseId,
  }) {
    http.post(
      Uri.parse('${config.apiBaseUrl}/Mail/Send'),
      headers: config.apiHeaders,
      body: jsonEncode({
        'type': 'expenseNew',
        'company_id': company.id,
        'expense_id': expenseId,
      }),
    );
  }

  static Stream<DatabaseEvent> getStream(
    FirebaseDatabase db,
    Company company,
    Employee employee,
  ) {
    String ref = 'client/${company.id}/expense';
    Query query =
        db.ref().child(ref).orderByChild('employee/id').equalTo(employee.id);
    query.keepSynced(true);
    return query.onValue;
  }
}
