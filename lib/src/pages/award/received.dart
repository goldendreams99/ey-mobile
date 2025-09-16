part of employ.pages;

class AwardReceivedList extends ConsumerStatefulWidget {
  @override
  AwardReceivedListState createState() => AwardReceivedListState();
}

class AwardReceivedListState extends ConsumerState<AwardReceivedList> {
  String? selectedType;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final manager = ref.watch(appProvider);
    final Database db = EmployProvider.of(context).database;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: STYLES.vGradient(colors: [
            Color.fromRGBO(78, 12, 195, 1.0),
            Color.fromRGBO(161, 67, 198, 1.0),
          ]),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            manager.valid
                ? Container(
                    height: size.height,
                    width: size.width,
              child: StreamBuilder<DatabaseEvent>(
                      stream: Award.getReceivedStream(
                        db.admin,
                        manager.company!,
                        manager.employee!,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.data?.snapshot.value != null) {
                          DatabaseEvent data = snapshot.data!;
                          List<Award> documents = [];
                          Map<dynamic, dynamic> value =
                              Map.from(data.snapshot.value as dynamic);
                          value.keys.forEach((k) {
                            Award aw =
                                Award.fromJson(manager.employee!, value[k]);
                            documents.add(aw);
                          });
                          Map<String, List<Award>> received = Map();
                          Award.sort(documents);
                          Employee.receivedAwards(documents).forEach((a) {
                            if (received[a.type] == null) received[a.type] = [];
                            received[a.type]?.add(a);
                          });
                          List<String> keys = received.keys.toList();
                          return Column(
                            children: <Widget>[
                              Container(
                                margin:
                                    EdgeInsets.only(top: padding.top + 20.0),
                                width: size.width,
                                padding:
                                    EdgeInsets.fromLTRB(22.0, 0.0, 16.0, 16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Recibidos',
                                      style: FONT.TITLE.merge(
                                        TextStyle(
                                            fontSize: 34.0, color: COLOR.white),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    AwardDiamontContainer(
                                      value: Employee.receivedAwards(documents)
                                          .length,
                                      isReceived: true,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: size.width,
                                height: 136.0,
                                child: ListView.builder(
                                  itemCount: keys.length > 0 ? keys.length : 0,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    Award current = received[keys[index]]![0];
                                    return InkResponse(
                                      onTap: () {
                                        selectedType = current.type;
                                        setState(() {});
                                      },
                                      child: Container(
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              height: 100.0,
                                              width: 100.0,
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    height: 80.0,
                                                    width: 80.0,
                                                    foregroundDecoration:
                                                        selectedType == null ||
                                                                selectedType ==
                                                                    current.type
                                                            ? null
                                                            : BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  55.0,
                                                                ),
                                                                color:
                                                                    Colors.grey,
                                                                backgroundBlendMode:
                                                                    BlendMode
                                                                        .saturation,
                                                              ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        40.0,
                                                      ),
                                                      color: Colors.yellow,
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                            current.image),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 5.0,
                                                    right: 5.0,
                                                    child: Container(
                                                      height: 25.0,
                                                      width: 25.0,
                                                      child: Center(
                                                        child: Text(
                                                          received[keys[index]]!
                                                              .length
                                                              .toString(),
                                                          style:
                                                              FONT.TITLE.merge(
                                                            TextStyle(
                                                              color:
                                                                  COLOR.white,
                                                              fontSize: 12.4,
                                                            ),
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          12.5,
                                                        ),
                                                        gradient:
                                                            STYLES.vGradient(
                                                          colors: [
                                                            Color.fromRGBO(23,
                                                                154, 155, 1.0),
                                                            Color.fromRGBO(50,
                                                                193, 255, 1.0),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 110.0,
                                              child: Text(
                                                current.name,
                                                overflow: TextOverflow.clip,
                                                maxLines: 2,
                                                style: FONT.SEMIBOLD.merge(
                                                  TextStyle(
                                                    color: COLOR.white.withOpacity(
                                                        selectedType == null ||
                                                                selectedType ==
                                                                    current.type
                                                            ? 1.0
                                                            : 0.5),
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                height: size.height - 322.0 - padding.bottom,
                                width: size.width,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: selectedType != null
                                      ? received[selectedType]!.length
                                      : keys.length > 0
                                          ? received[keys[0]]!.length
                                          : 0,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 20.0),
                                  itemBuilder: (_, index) {
                                    String sel = selectedType == null
                                        ? keys[0]
                                        : selectedType!;
                                    Award current = received[sel]![index];
                                    ImageProvider image;
                                    if (current.from.avatar.contains('http')) {
                                      image = NetworkImage(current.from.avatar);
                                    } else {
                                      image = AssetImage(
                                          'assets/images/avatar/${current.from.avatar}.png');
                                    }

                                    return InkResponse(
                                      onTap: () {
                                        AwardReceivedDialog.build(
                                            context, current);
                                      },
                                      child: Container(
                                        height: 60.0,
                                        width: size.width,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  height: 60.0,
                                                  width: 60.0,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                    color: Colors.white
                                                        .withOpacity(current
                                                                .from.avatar
                                                                .contains(
                                                                    'http')
                                                            ? 0.3
                                                            : 1.0),
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: image,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 20.0),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      current.relative,
                                                      style:
                                                          FONT.SEMIBOLD.merge(
                                                        TextStyle(
                                                          color: COLOR.white,
                                                          fontSize: 12.0,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 5.0),
                                                    Container(
                                                      width: size.width - 120.0,
                                                      child: Text(
                                                        current.from.name,
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow.clip,
                                                        style: FONT.TITLE.merge(
                                                          TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    243,
                                                                    243,
                                                                    0.95),
                                                            fontSize: 18.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  )
                : Container(),
            Positioned(
              bottom: padding.bottom,
              left: 0.0,
              child: Container(
                width: size.width,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 3.0),
                child: FooterButton(
                  action: () {
                    Application.router.pop(context);
                  },
                  icon: EmployIcons.btm_close_dark,
                  size: calcSize(size, 60.0),
                  theme: Brightness.light,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
