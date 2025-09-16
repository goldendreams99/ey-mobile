import 'package:json_annotation/json_annotation.dart';

part 'expense_type.g.dart';

@JsonSerializable(explicitToJson: true)
class ExpenseType {
  String? name;
  String? id;

  ExpenseType({this.name, this.id});

  factory ExpenseType.fromJson(Map<String, dynamic> json) =>
      _$ExpenseTypeFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseTypeToJson(this);
}
