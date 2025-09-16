part of employ.pages;

class TicketViewEmpty extends ConsumerStatefulWidget {
  final String name;

  const TicketViewEmpty({required this.name});

  @override
  _TicketViewEmptyState createState() => _TicketViewEmptyState();
}

class _TicketViewEmptyState extends ConsumerState<TicketViewEmpty> {
  ScrollController? controller;

  bool get isOpen => true;
  String? ticketId;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      updateScroll();
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final manager = ref.watch(appProvider);
    final Database db = EmployProvider.of(context).database;
    double messageBar = isOpen ? 65.0 + padding.bottom : 0.0;
    return Scaffold(
      backgroundColor: COLOR.white,
      body: LayoutBuilder(
        builder: (_, constraints) {
          return Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Positioned(
                  left: 0.0,
                  bottom: 0.0,
                  child: isOpen
                      ? ChatTextBar(
                          send: pushMessage,
                          subject: widget.name,
                          ticketId: ticketId,
                        )
                      : Container(),
                ),
                Column(
                  children: <Widget>[
                    SimpleAppBarView(text: widget.name),
                    Expanded(
                      flex: 1,
                      child: Container(
                          padding: EdgeInsets.only(
                            bottom: calcSize(size, messageBar),
                          ),
                          child: StreamBuilder<DatabaseEvent>(
                            stream: TicketChat.getStream(
                              db.admin,
                              manager.company!,
                              ticketId ?? 'empty',
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data?.snapshot.value != null) {
                                DatabaseEvent? data = snapshot.data;
                                List<TicketChat> documents = List.from(
                                  data!.snapshot.value!.toDynamic(),
                                )
                                    .map((value) => TicketChat.fromJson(value))
                                    .toList();
                                TicketChat.sort(documents);
                                if (documents.length == 0)
                                  return renderEmptyState(
                                    context,
                                    snapshot.connectionState,
                                  );
                                return renderList(documents);
                              } else {
                                return renderList([]);
                              }
                            },
                          )),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void updateScroll() {
    Timer(Duration(milliseconds: 500), () {
      if (mounted) {
        controller?.animateTo(
          controller!.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> create(TicketChat message) async {
    final manager = ref.read(appProvider);
    final db = EmployProvider.of(context).database;
    final config = AppConfig.of(context);
    DateTime now = DateTime.now();
    message.created = '${DateTime.now().toIso8601String()}Z';
    message.type = 'employee';
    Map<String, dynamic> ticket = {
      'open': true,
      'priority': false,
      'created': formatDate(now, [yyyy, '-', mm, '-', dd]),
      'year': formatDate(now, [yyyy]),
      'month': formatDate(now, [mm]),
      'period': formatDate(now, [yyyy, mm]),
      'employee': manager.employee!.apiData(),
      'name': widget.name,
      'chats': [
        message.toJson(),
      ],
    };
    String refe = 'client/${manager.company!.id}/ticket/';
    ticketId = (await db.push(refe, ticket))!;
    Ticket.notify(
      config: config,
      employee: manager.employee!,
      company: manager.company!,
      isRecently: true,
    );
    setState(() {});
  }

  Future<void> pushMessage(TicketChat message) async {
    if (ticketId == null) {
      await create(message);
    } else {
      await ChatHelper.pushMessage(
        message: message,
        ref: ref,
        context: context,
        ticketId: ticketId!,
      );
      updateScroll();
    }
  }

  Widget renderList(List<TicketChat> documents) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return false;
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        controller: controller,
        addAutomaticKeepAlives: true,
        itemCount: documents.length,
        itemBuilder: (context, int index) {
          TicketChat current = documents[index];
          return !current.hasMedia
              ? ChatItemMessage(
                  item: current,
                  index: index,
                )
              : current.hasImage
                  ? ChatItemImage(
                      item: current,
                      index: index,
                      ticketId: ticketId!,
                    )
                  : ChatItemFile(
                      item: current,
                      index: index,
                      ticketId: ticketId!,
                    );
        },
      ),
    );
  }
}
