import 'package:employ/src/models/expense/department/expense_department.dart';
import 'package:json_annotation/json_annotation.dart';

part 'expense_employee.g.dart';

@JsonSerializable(explicitToJson: true)
class ExpenseEmployee {
  final String? avatar;
  @JsonKey(name: 'date_birth')
  final String? dateBirth;
  final String? document;
  final String? gender;
  final String? id;
  final String? mail;
  final String? name;
  final dynamic position;
  final dynamic place;
  final ExpenseDepartment? department;

  ExpenseEmployee({
    required this.department,
    required this.place,
    required this.position,
    required this.avatar,
    required this.dateBirth,
    required this.document,
    required this.name,
    required this.gender,
    required this.id,
    required this.mail,
  });

  factory ExpenseEmployee.fromJson(Map<String, dynamic> json) =>
      _$ExpenseEmployeeFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseEmployeeToJson(this);
}
