// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expense _$ExpenseFromJson(Map<String, dynamic> json) => Expense(
      id: json['id'] as String?,
      currency: json['currency'] == null
          ? null
          : ExpenseCurrency.fromJson(json['currency'] as Map<String, dynamic>),
      value: (json['amount'] as num?)?.toDouble(),
      costCenter: json['costcenter'] == null
          ? null
          : ExpenseCostCenter.fromJson(
              json['costcenter'] as Map<String, dynamic>),
      observation: json['observation'] as String?,
      reply: json['reply'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => ExpenseAttachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      reportedDate: json['date'] as String?,
      created: json['created'] as String?,
      year: json['year'] as String?,
      reimbursable: json['reimbursable'] as bool,
      status: (json['status'] as num?)?.toInt(),
      type: json['type'] == null
          ? null
          : ExpenseType.fromJson(json['type'] as Map<String, dynamic>),
      month: json['month'] as String?,
      period: json['period'] as String?,
      createdBy: json['created_by'] as String?,
      employee: json['employee'] == null
          ? null
          : ExpenseEmployee.fromJson(json['employee'] as Map<String, dynamic>),
      client: json['client'] == null
          ? null
          : ExpenseClient.fromJson(json['client'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ExpenseToJson(Expense instance) => <String, dynamic>{
      'id': instance.id,
      'amount': instance.value,
      'observation': instance.observation,
      'reply': instance.reply,
      'date': instance.reportedDate,
      'created': instance.created,
      'year': instance.year,
      'month': instance.month,
      'period': instance.period,
      'created_by': instance.createdBy,
      'reimbursable': instance.reimbursable,
      'status': instance.status,
      'currency': instance.currency?.toJson(),
      'costcenter': instance.costCenter?.toJson(),
      'type': instance.type?.toJson(),
      'employee': instance.employee?.toJson(),
      'client': instance.client?.toJson(),
      'attachments': instance.attachments?.map((e) => e.toJson()).toList(),
    };
