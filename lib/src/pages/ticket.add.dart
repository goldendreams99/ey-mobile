part of employ.pages;

class TicketAdd extends ConsumerStatefulWidget {
  @override
  _TicketAddState createState() => _TicketAddState();
}

class _TicketAddState extends ConsumerState<TicketAdd> {
  TextEditingController? controller;
  List<dynamic> options = [];
  dynamic selectedSubjectType;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller?.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final size = MediaQuery.of(context).size;
    final manager = ref.watch(appProvider);
    bool hasOptions = manager.settings!.moduleChatSubject;
    final Database db = EmployProvider.of(context).database;
    return Scaffold(
      backgroundColor: COLOR.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: STYLES.vGradient(theme: manager.settings!.theme),
        ),
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.topLeft,
          children: <Widget>[
            hasOptions
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: calcSize(size, 116),
                        alignment: Alignment.bottomLeft,
                        width: size.width,
                        padding: EdgeInsets.fromLTRB(22.0, 0, 16.0, 16.0),
                        child: Text(
                          'Chat',
                          style: FONT.TITLE.merge(
                            TextStyle(fontSize: 34.0, color: COLOR.white),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 80.0),
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: StreamBuilder<DatabaseEvent>(
                            stream: Ticket.getSubjectStream(
                              db.admin,
                              manager.company!,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data?.snapshot.value != null) {
                                DatabaseEvent data = snapshot.data!;
                                List<dynamic> documents = [];
                                Map<dynamic, dynamic> value =
                                    Map.from(data.snapshot.value as dynamic);
                                value.keys
                                    .forEach((k) => documents.add(value[k]));
                                documents.sort(
                                  (b, a) {
                                    return b['name'].compareTo(a['name']);
                                  },
                                );
                                return ListView.builder(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  addAutomaticKeepAlives: true,
                                  itemCount: documents.length,
                                  itemBuilder: (context, int index) {
                                    dynamic current = documents[index];
                                    return FlatButton(
                                      onPressed: () => select(current),
                                      padding: EdgeInsets.zero,
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(
                                            0.0, 4.0, 16.0, 4.0),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: 18.0,
                                              margin:
                                                  EdgeInsets.only(right: 8.0),
                                              child:
                                                  selectedSubjectType != null &&
                                                          selectedSubjectType[
                                                                  'name'] ==
                                                              current['name']
                                                      ? Icon(Icons.check,
                                                          color: COLOR.white)
                                                      : null,
                                            ),
                                            Expanded(
                                              child: Text(
                                                current['name'],
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: FONT.TITLE.merge(
                                                  TextStyle(
                                                    color: COLOR.white,
                                                    fontSize: 21.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                              return Container();
                            }),
                          ),
                        ),
                    ],
                  )
                : Container(
                    padding: EdgeInsets.fromLTRB(
                        25.0, padding.top + 20.0, 25.0, 5.0),
                    child: TextField(
                      style: FONT.TITLE.merge(
                        TextStyle(
                          color: COLOR.white,
                          fontSize: 32.0,
                        ),
                      ),
                      autofocus: true,
                      autocorrect: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Escribe un asunto',
                        hintStyle: FONT.TITLE.merge(
                          TextStyle(
                              color: COLOR.black.withOpacity(0.35),
                              fontSize: 32.0),
                        ),
                      ),
                      controller: controller,
                    ),
                  ),
            Positioned(
              bottom: padding.bottom,
              child: Container(
                color:
                    hasOptions ? Colors.transparent : COLOR.greyish_brown_four,
                width: size.width,
                padding: EdgeInsets.symmetric(horizontal: 3.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FooterButton(
                      action: () => Application.router.pop(context),
                      icon: EmployIcons.btm_close_dark,
                      size: calcSize(size, 60.0),
                      theme: Brightness.light,
                    ),
                    FooterButton(
                      action: createTicket,
                      icon: EmployIcons.btm_next_dark,
                      size: calcSize(size, 60.0),
                      theme: Brightness.light,
                      enabled: canCreate,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSelectSubjectType() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmploySelect<dynamic>(
          title: 'Asunto Chat',
          options: options,
          selected: selectedSubjectType ?? Map(),
          render: (option) => option['name'],
        ),
      ),
    ).then((value) {
      if (value != null) {
        selectedSubjectType = value;
        setState(() {});
      }
    });
  }

  bool get canCreate {
    final settings = ref.read(appProvider).settings;
    bool hasOptions = settings!.moduleChatSubject;
    return hasOptions
        ? selectedSubjectType != null
        : controller?.text != null && (controller?.text.isNotEmpty ?? false);
  }

  void createTicket() async {
    if (!canCreate) return;
    Vibration.vibrate(duration: 100);
    FocusScope.of(context).requestFocus(FocusNode());
    LoadingDialog.build(context);
    final manager = ref.read(appProvider);
    bool hasOptions = manager.settings!.moduleChatSubject;
    final name = hasOptions ? selectedSubjectType['name'] : controller?.text;
    String route = Routes.newTicketEmpty.replaceAll(':name', name);
    Application.router.pop(context);
    Application.router.pop(context);
    Application.router.navigateTo(context, route);
  }

  void select(item) {
    selectedSubjectType = item;
    if (mounted) setState(() {});
  }
}
