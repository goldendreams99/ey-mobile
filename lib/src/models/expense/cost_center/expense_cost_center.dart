import 'package:json_annotation/json_annotation.dart';

part 'expense_cost_center.g.dart';

@JsonSerializable(explicitToJson: true)
class ExpenseCostCenter {
  String? name;
  String? id;

  ExpenseCostCenter({this.name, this.id});

  factory ExpenseCostCenter.fromJson(Map<String, dynamic> json) =>
      _$ExpenseCostCenterFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseCostCenterToJson(this);
}
