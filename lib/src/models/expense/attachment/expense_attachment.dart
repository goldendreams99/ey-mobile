import 'package:json_annotation/json_annotation.dart';

part 'expense_attachment.g.dart';

@JsonSerializable(explicitToJson: true)
class ExpenseAttachment {
  String? id;
  String? name;
  String? url;
  String? type;

  ExpenseAttachment({
    this.name,
    this.url,
    this.id,
    this.type,
  });

  factory ExpenseAttachment.fromJson(Map<String, dynamic> json) =>
      _$ExpenseAttachmentFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseAttachmentToJson(this);

  bool get isImage =>
      name != null ? !name!.toLowerCase().endsWith('pdf') : false;
}
