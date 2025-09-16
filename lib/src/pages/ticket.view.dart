part of employ.pages;

class TicketView extends ConsumerStatefulWidget {
  final String? ticketId;
  final String isOpen;
  final String? name;

  const TicketView({this.ticketId, this.name, required this.isOpen});

  @override
  _TicketViewState createState() => _TicketViewState();
}

class _TicketViewState extends ConsumerState<TicketView> {
  ScrollController? controller;

  bool get isOpen => widget.isOpen.compareTo('true') == 0;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Timer(Duration(milliseconds: 100), updateScroll);
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
                          subject: widget.name!,
                          ticketId: widget.ticketId!,
                        )
                      : Container(),
                ),
                Column(
                  children: <Widget>[
                    SimpleAppBarView(text: widget.name ?? ''),
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
                              widget.ticketId!,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data?.snapshot.value != null) {
                                DatabaseEvent data = snapshot.data!;
                                List<TicketChat> documents = List.from(
                                        data.snapshot.value?.toDynamic())
                                    .map((value) => TicketChat.fromJson(value))
                                    .toList();
                                TicketChat.sort(documents);
                                if (documents.length == 0)
                                  return renderEmptyState(
                                      context, snapshot.connectionState);
                                return NotificationListener<
                                    OverscrollIndicatorNotification>(
                                  onNotification: (overscroll) {
                                    overscroll.disallowIndicator();
                                    return false;
                                  },
                                  child: ListView.builder(
                                    padding: EdgeInsets.fromLTRB(
                                      25.0,
                                      0.0,
                                      25.0,
                                      20.0,
                                    ),
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
                                                  ticketId: widget.ticketId!,
                                                )
                                              : ChatItemFile(
                                                  item: current,
                                                  index: index,
                                                  ticketId: widget.ticketId!,
                                                );
                                    },
                                  ),
                                );
                              } else {
                                return renderEmptyState(
                                    context, snapshot.connectionState);
                              }
                            },
                          )),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void updateScroll() {
    Timer(Duration(milliseconds: 500), () {
      controller?.animateTo(
        controller!.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> pushMessage(TicketChat message) async {
    await ChatHelper.pushMessage(
      message: message,
      ref: ref,
      context: context,
      ticketId: widget.ticketId!,
    );
    updateScroll();
  }
}
