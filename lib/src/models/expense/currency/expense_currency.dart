import 'package:json_annotation/json_annotation.dart';

part 'expense_currency.g.dart';

@JsonSerializable(explicitToJson: true)
class ExpenseCurrency {
  String? name;
  String? id;

  ExpenseCurrency({this.name, this.id});

  factory ExpenseCurrency.fromJson(Map<String, dynamic> json) =>
      _$ExpenseCurrencyFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseCurrencyToJson(this);
}
