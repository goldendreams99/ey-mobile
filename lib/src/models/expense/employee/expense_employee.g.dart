// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseEmployee _$ExpenseEmployeeFromJson(Map<String, dynamic> json) =>
    ExpenseEmployee(
      department: json['department'] == null
          ? null
          : ExpenseDepartment.fromJson(
              json['department'] as Map<String, dynamic>),
      place: json['place'],
      position: json['position'],
      avatar: json['avatar'] as String?,
      dateBirth: json['date_birth'] as String?,
      document: json['document'] as String?,
      name: json['name'] as String?,
      gender: json['gender'] as String?,
      id: json['id'] as String?,
      mail: json['mail'] as String?,
    );

Map<String, dynamic> _$ExpenseEmployeeToJson(ExpenseEmployee instance) =>
    <String, dynamic>{
      'avatar': instance.avatar,
      'date_birth': instance.dateBirth,
      'document': instance.document,
      'gender': instance.gender,
      'id': instance.id,
      'mail': instance.mail,
      'name': instance.name,
      'position': instance.position,
      'place': instance.place,
      'department': instance.department?.toJson(),
    };
