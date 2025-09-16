import 'package:json_annotation/json_annotation.dart';

part 'expense_client.g.dart';

@JsonSerializable(explicitToJson: true)
class ExpenseClient {
  String? name;
  String? id;

  ExpenseClient({this.name, this.id});

  factory ExpenseClient.fromJson(Map<String, dynamic> json) =>
      _$ExpenseClientFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseClientToJson(this);
}
