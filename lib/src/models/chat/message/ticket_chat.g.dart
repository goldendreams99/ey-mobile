// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketChat _$TicketChatFromJson(Map<String, dynamic> json) => TicketChat(
      created: json['created'] as String?,
      message: json['message'] as String?,
      type: json['type'] as String?,
      fileMime: json['file_mime'] as String?,
      fileName: json['file_name'] as String?,
      displayName: json['display_name'] as String?,
      fileUrl: json['file_url'] as String?,
    );

Map<String, dynamic> _$TicketChatToJson(TicketChat instance) =>
    <String, dynamic>{
      'created': instance.created,
      'message': instance.message,
      'type': instance.type,
      'file_mime': instance.fileMime,
      'file_name': instance.fileName,
      'display_name': instance.displayName,
      'file_url': instance.fileUrl,
    };
