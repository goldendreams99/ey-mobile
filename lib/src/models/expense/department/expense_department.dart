import 'package:json_annotation/json_annotation.dart';

part 'expense_department.g.dart';

@JsonSerializable(explicitToJson: true)
class ExpenseDepartment {
  String? name;
  String? id;

  ExpenseDepartment({this.name, this.id});

  factory ExpenseDepartment.fromJson(Map<String, dynamic> json) =>
      _$ExpenseDepartmentFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseDepartmentToJson(this);
}
