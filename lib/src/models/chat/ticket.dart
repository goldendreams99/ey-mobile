import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:employ/src/config/application.dart';
import 'package:employ/src/models/chat/message/ticket_chat.dart';
import 'package:employ/src/models/index.dart';
import 'package:employ/src/theme/index.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;

part 'ticket.g.dart';

@JsonSerializable()
class Ticket {
  final String id;
  final String name;
  final List<TicketChat> chats;
  final String? created;
  final bool open;

  Ticket({
    required this.id,
    required this.name,
    required this.chats,
    required this.created,
    required this.open,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);

  Map<String, dynamic> toJson() => _$TicketToJson(this);

  int? get year => int.tryParse(created.toString().trim().split('-')[0]);

  DateTime? get createdDate => DateTime.tryParse(created ?? '');

  String get label {
    String? last;
    try {
      last = chats.last.message;
    } catch (e) {
      last = null;
    }
    return chats.isNotEmpty ? last ?? LABEL.fileLabel : '';
  }

  String get relative {
    if (chats.isEmpty) return '';
    TicketChat last = chats.last;
    final DateTime now = DateTime.now();
    final String createdFormat =
        formatDate(last.createdDate, [dd, '/', mm, '/', yyyy]);
    String relativeTime = timeago.format(
      last.createdDate.subtract(now.timeZoneOffset),
      locale: 'es',
      allowFromNow: false,
    );
    if (relativeTime.contains('minutos') || relativeTime.contains('momento'))
      relativeTime = timeago.format(
        last.createdDate.subtract(now.timeZoneOffset),
        locale: 'es_short',
        allowFromNow: false,
      );
    final DateTime tdays = DateTime.now().subtract(Duration(days: 30));
    return last.createdDate.isBefore(tdays)
        ? createdFormat
        : (relativeTime.contains('~') ? createdFormat : relativeTime);
  }

  static sort(List<Ticket> tickets) {
    tickets.sort(
      (b, a) {
        DateTime? aCreated =
            a.chats.isEmpty ? a.createdDate : a.chats.last.createdDate;
        DateTime? bCreated =
            b.chats.isEmpty ? b.createdDate : b.chats.last.createdDate;
        return aCreated!.compareTo(bCreated!);
      },
    );
  }

  static List<Ticket> filter(
    List<Ticket> documents,
    int year,
    bool all,
    bool isOpen,
    //---------- BEGIN ----------//
    String type,
    //---------- FINISH ----------//
  ) {
    //---------- BEGIN ----------//
    List<Ticket> filteredDocuments;
    //---------- FINISH ----------//
    if (all) {
      //---------- BEGIN ----------//
      filteredDocuments = documents.where((item) => item.year == year).toList();
      //---------- FINISH ----------//
    } else {
      //---------- BEGIN ----------//
      filteredDocuments = documents
          //---------- FINISH ----------//
          .where((item) => item.year == year && item.open == isOpen)
          //---------- BEGIN ----------//
          .toList();
    }
    
    // Aplicar filtro de tipo
    if (type != 'Todos') {
      filteredDocuments = filteredDocuments
          .where((item) => item.name == type)
          .toList();
    }
    
    return filteredDocuments;
    //---------- FINISH ----------//
  }

  static void notify({
    required AppConfig config,
    required Company company,
    required Employee employee,
    required bool isRecently,
  }) {
    http.post(
      Uri.parse('${config.apiBaseUrl}/Mail/Send'),
      headers: config.apiHeaders,
      body: jsonEncode({
        'type': isRecently ? 'messageNew' : 'messageAnswer',
        'company_id': company.id,
        'employee_id': employee.id,
      }),
    );
  }

  static Stream<DatabaseEvent> getStream(
    FirebaseDatabase db,
    Company company,
    Employee employee,
  ) {
    String ref = 'client/${company.id}/ticket';
    Query query =
        db.ref().child(ref).orderByChild('employee/id').equalTo(employee.id);
    query.keepSynced(true);
    return query.onValue;
  }

  static Stream<DatabaseEvent> getSubjectStream(
      FirebaseDatabase db, Company company) {
    String ref = 'client/${company.id}/setting/chat_subject';
    Query query = db.ref().child(ref);
    query.keepSynced(true);
    return query.onValue;
  }
}
