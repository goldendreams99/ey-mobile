// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ticket _$TicketFromJson(Map<String, dynamic> json) => Ticket(
      id: json['id'] as String,
      name: json['name'] as String,
      chats: (json['chats'] as List<dynamic>)
          .map((e) => TicketChat.fromJson(e as Map<String, dynamic>))
          .toList(),
      created: json['created'] as String?,
      open: json['open'] as bool,
    );

Map<String, dynamic> _$TicketToJson(Ticket instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'chats': instance.chats,
      'created': instance.created,
      'open': instance.open,
    };
