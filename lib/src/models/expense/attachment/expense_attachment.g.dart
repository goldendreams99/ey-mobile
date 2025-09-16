// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseAttachment _$ExpenseAttachmentFromJson(Map<String, dynamic> json) =>
    ExpenseAttachment(
      name: json['name'] as String?,
      url: json['url'] as String?,
      id: json['id'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$ExpenseAttachmentToJson(ExpenseAttachment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
      'type': instance.type,
    };
