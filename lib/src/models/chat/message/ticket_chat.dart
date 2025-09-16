import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:employ/src/config/application.dart';
import 'package:employ/src/models/index.dart';
import 'package:employ/src/theme/index.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;

part 'ticket_chat.g.dart';

@JsonSerializable()
class TicketChat {
  String? created;
  String? message;
  String? type;
  @JsonKey(name: 'file_mime')
  String? fileMime;
  @JsonKey(name: 'file_name')
  String? fileName;
  @JsonKey(name: 'display_name')
  String? displayName;
  @JsonKey(name: 'file_url')
  String? fileUrl;

  TicketChat({
    this.created,
    this.message,
    this.type,
    this.fileMime,
    this.fileName,
    this.displayName,
    this.fileUrl,
  });

  factory TicketChat.fromJson(Map<String, dynamic> json) =>
      _$TicketChatFromJson(json);

  Map<String, dynamic> toJson() => _$TicketChatToJson(this);

  bool get me => type == 'employee';

  bool get hasMedia => fileUrl != null;

  String get name => displayName ?? fileName ?? '';

  bool get hasImage =>
      fileMime != null && (fileMime?.contains('image') ?? false);

  DateTime get createdDate =>
      created == null ? DateTime.now() : DateTime.parse(created!);

  String get label {
    final DateTime now = DateTime.now();
    final String createdFormat =
        formatDate(createdDate, [dd, '-', mm, '-', yyyy]);
    final String relativeTime = timeago.format(
      createdDate.subtract(now.timeZoneOffset),
      locale: 'es',
      allowFromNow: false,
    );
    final DateTime tdays = DateTime.now().subtract(Duration(days: 30));
    return createdDate.isBefore(tdays) ? createdFormat : relativeTime;
  }

  String get relative {
    final DateTime now = DateTime.now();
    final String createdFormat =
        formatDate(createdDate, [dd, '/', mm, '/', yyyy]);
    final String createdHourFormat = formatDate(createdDate, [HH, ':', nn]);
    final DateTime thours = createdDate.add(Duration(hours: 23, minutes: 59));
    return '$createdHourFormat - ${thours.isAfter(now) ? 'Hoy' : createdFormat}';
  }

  Future<String?> isDownloaded(BuildContext context, String ticketId) async {
    try {
      bool can = await canWriteOnStorage(context);
      if (!can) return null;
      var dir = await getApplicationSupportDirectory();
      final employDir = Directory('${dir.path}/Employ/Media');
      bool employExist = await employDir.exists();
      if (!employExist) await employDir.create(recursive: true);
      File file = File('${employDir.path}/ticket_${ticketId}_$name');
      bool isDownloaded = await file.exists();
      return isDownloaded ? file.path : null;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  Future<File?> download(BuildContext context, String ticketId) async {
    try {
      bool can = await canWriteOnStorage(context);
      if (!can) return null;
      var dir = await getApplicationSupportDirectory();
      final employDir = Directory('${dir.path}/Employ/Media');
      bool employExist = await employDir.exists();
      if (!employExist) await employDir.create(recursive: true);
      File file = File('${employDir.path}/ticket_${ticketId}_$name');
      bool isDownloaded = await file.exists();
      if (isDownloaded)
        return file;
      else {
        var data = await http.get(Uri.parse(fileUrl!));
        var bytes = data.bodyBytes;
        File urlFile = await file.writeAsBytes(bytes);
        return urlFile;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error opening url file",
        backgroundColor: COLOR.orangey_red,
      );
      throw Exception("Error opening url file");
    }
  }

  static Future<File?> generateCopy(
    BuildContext context,
    File file,
    String ticketId,
    String newValue,
  ) async {
    try {
      bool can = await canWriteOnStorage(context);
      if (!can) return null;
      var dir = await getApplicationSupportDirectory();
      final employDir = Directory('${dir.path}/Employ/Media');
      bool employExist = await employDir.exists();
      if (!employExist) await employDir.create(recursive: true);
      String newPath = '${employDir.path}/ticket_${ticketId}_$newValue';
      return await file.copy(newPath);
    } catch (e) {
      throw Exception("Error cannot copy file");
    }
  }

  static sort(List<TicketChat> documents) {
    documents.sort((a, b) => a.createdDate.compareTo(b.createdDate));
  }

  static Stream<DatabaseEvent> getStream(
    FirebaseDatabase db,
    Company company,
    String ticketId,
  ) {
    String ref = 'client/${company.id}/ticket/$ticketId/chats';
    Query query = db.ref().child(ref);
    query.keepSynced(true);
    return query.onValue;
  }
}
