import 'package:employ/src/config/application.dart';
import 'package:employ/src/models/chat/message/ticket_chat.dart';
import 'package:employ/src/models/chat/ticket.dart';
import 'package:employ/src/providers/app/app_provider.dart';
import 'package:employ/src/providers/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';

abstract class ChatHelper {
  static Future<void> pushMessage({
    required TicketChat message,
    required WidgetRef ref,
    required BuildContext context,
    required String ticketId,
  }) async {
    Vibration.vibrate(duration: 100);
    final manager = ref.read(appProvider);
    final provider = EmployProvider.of(context);
    var config = AppConfig.of(context);
    String refChat = 'client/${manager.company!.id}/ticket/$ticketId';
    final res = await provider.database.once('$refChat/chats');
    List<TicketChat> oldChats = res != null
        ? List.from(res).map((e) => TicketChat.fromJson(e)).toList()
        : [];
    message.created = '${DateTime.now().toIso8601String()}Z';
    message.type = 'employee';
    oldChats.add(message);
    await provider.database.update(refChat, {
      'chats': oldChats.map((e) => e.toJson()).toList(),
    });
    Ticket.notify(
      company: manager.company!,
      config: config,
      employee: manager.employee!,
      isRecently: true,
    );
  }
}
