part of employ.pages;

class AwardSentList extends ConsumerStatefulWidget {
  @override
  AwardSentListState createState() => AwardSentListState();
}

class AwardSentListState extends ConsumerState<AwardSentList> {
  int? selectedType;

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                              value.keys.forEach((k) => documents.add(
                                  Award.fromJson(manager.employee!, value[k])));
                              Award.sort(documents);
                              List<Award> awards =
                                  Employee.sendedAwards(documents);
                              return Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: padding.top + 20.0),
                                    width: size.width,
                                    padding: EdgeInsets.fromLTRB(
                                        22.0, 0.0, 16.0, 16.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          'Enviados',
                                          style: FONT.TITLE.merge(
                                            TextStyle(
                                                fontSize: 34.0,
                                                color: COLOR.white),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        AwardDiamontContainer(
                                          value: manager.settings!
                                                  .awardLimitMonthlyTotal -
                                              Employee.sendedAwards(documents)
                                                  .length,
                                          isReceived: false,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: size.width,
                                    height: calcSize(size, 182.0),
                                    child: ListView.builder(
                                      itemCount: awards.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        Award current = awards[index];
                                        ImageProvider image;
                                        if (current.to.avatar
                                            .contains('http')) {
                                          image =
                                              NetworkImage(current.to.avatar);
                                        } else {
                                          image = AssetImage(
                                              'assets/images/avatar/${current.to.avatar}.png');
                                        }
                                        return InkResponse(
                                          onTap: () {
                                            selectedType = index;
                                            setState(() {});
                                          },
                                          child: Container(
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  height: 136.0,
                                                  width: 136.0,
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: <Widget>[
                                                      Container(
                                                        height: 100.0,
                                                        width: 100.0,
                                                        foregroundDecoration:
                                                            selectedType ==
                                                                        null ||
                                                                    selectedType ==
                                                                        index
                                                                ? null
                                                                : BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            55.0),
                                                                    color: Colors
                                                                        .grey,
                                                                    backgroundBlendMode:
                                                                        BlendMode
                                                                            .saturation,
                                                                  ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(current
                                                                      .to.avatar
                                                                      .contains(
                                                                          'http')
                                                                  ? 0.3
                                                                  : 1.0),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            50.0,
                                                          ),
                                                          image:
                                                              DecorationImage(
                                                                fit: BoxFit.cover,
                                                            image: image,
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: 0.0,
                                                        child: Container(
                                                          height: 40.0,
                                                          width: 40.0,
                                                          foregroundDecoration:
                                                              selectedType ==
                                                                          null ||
                                                                      selectedType ==
                                                                          index
                                                                  ? null
                                                                  : BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              55.0),
                                                                      color: Colors
                                                                          .grey,
                                                                      backgroundBlendMode:
                                                                          BlendMode
                                                                              .saturation,
                                                                    ),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              20.0,
                                                            ),
                                                            image:
                                                                DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage(
                                                                  current
                                                                      .image),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10.0,
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
                                                            selectedType ==
                                                                        null ||
                                                                    selectedType ==
                                                                        index
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
                                    height:
                                        size.height - 358.0 - padding.bottom,
                                    padding: EdgeInsets.fromLTRB(
                                        16.4, 20.0, 16.4, 1.0),
                                    width: size.width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(left: 30.0),
                                          child: Text(
                                            "ENVIADO\n${awards[selectedType ?? 0].relative}",
                                            style: FONT.TITLE.merge(
                                              TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 243, 243, 0.95),
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 12.6),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 30.0),
                                          child: Text(
                                            awards[selectedType ?? 0].to.name,
                                            style: FONT.TITLE.merge(
                                              TextStyle(
                                                color: Color.fromRGBO(
                                                    255, 243, 243, 0.95),
                                                fontSize: calcSize(size, 19.4),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Container(
                                          width: size.width,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 19.3, horizontal: 28.5),
                                          decoration: BoxDecoration(
                                            color:
                                                COLOR.black.withOpacity(0.14),
                                            borderRadius:
                                                BorderRadius.circular(47.0),
                                          ),
                                          child: Text(
                                            '“${awards[selectedType ?? 0].observation}”',
                                            style: FONT.REGULAR.merge(
                                              TextStyle(
                                                color: COLOR.white,
                                                fontSize: 16.9,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
              ],
            ),
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
            )
          ],
        ),
      ),
    );
  }
}
