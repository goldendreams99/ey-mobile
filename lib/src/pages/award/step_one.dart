part of employ.pages;

class AwardStepOne extends ConsumerStatefulWidget {
  final dynamic stepOneData;
  final ValueChanged<Map<dynamic, dynamic>> onChanged;

  const AwardStepOne({
    this.stepOneData,
    required this.onChanged,
  });

  @override
  AwardStepOneState createState() => AwardStepOneState();
}

class AwardStepOneState extends ConsumerState<AwardStepOne>
    with TickerProviderStateMixin {
  String? query;
  bool isVisible = false;
  TabController? controller;
  dynamic stepData;

  @override
  void initState() {
    super.initState();
    stepData = Map.from(widget.stepOneData);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final manager = ref.watch(appProvider);
    final db = EmployProvider.of(context).database;
    return manager.valid
        ? Container(
            height: size.height,
            width: size.width,
            child: StreamBuilder<DatabaseEvent>(
              stream: Award.getTypeStream(
                db.admin,
                manager.company!,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
                  DatabaseEvent data = snapshot.data!;
                  List<dynamic> types = [];
                  Map<dynamic, dynamic> value =
                      Map.from(data.snapshot.value as dynamic);
                  value.keys.forEach((k) => types.add(value[k]));
                  int initialIndex = 0;
                  if (stepData['award'] != null) {
                    int index = types.indexWhere(
                        (type) => type['id'] == stepData['award']['id']);
                    if (index >= 0) initialIndex = index;
                  } else {
                    Timer(Duration(milliseconds: 500), () {
                      widget.onChanged({'award': types[0]});
                    });
                    stepData['award'] = types[0];
                  }
                  controller = TabController(
                      vsync: this,
                      initialIndex: initialIndex,
                      length: types.length);
                  controller?.addListener(() => setState(() {
                        stepData['award'] = types[controller!.index];
                        widget.onChanged(stepData);
                      }));
                  return Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: ClipShadowPath(
                            shadow: Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 10,
                              color: COLOR.black.withOpacity(0.5),
                            ),
                            clipper: EmployAwardBoxClipper(),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: STYLES.vGradient(
                                  colors: [
                                    Color.fromRGBO(194, 46, 160, 1.0),
                                    Color.fromRGBO(95, 19, 117, 1.0),
                                  ],
                                ),
                              ),
                              height: calcSize(size, 300.0),
                              width: size.width,
                              child: TabBarView(
                                controller: controller,
                                children: <Widget>[]..addAll(types.map((t) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                            width: 112.5,
                                            height: 112.5,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(56.25),
                                            ),
                                            child: FadeInImage.assetNetwork(
                                              fadeInDuration:
                                                  Duration(milliseconds: 350),
                                              fadeOutDuration:
                                                  Duration(milliseconds: 150),
                                              placeholder:
                                                  'assets/images/icons/award_loading.png',
                                              image: t['image'],
                                              fit: BoxFit.cover,
                                            )),
                                        SizedBox(height: 10.0),
                                        Container(
                                          width: size.width * 0.8,
                                          child: Text(
                                            t['name'],
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            style: FONT.TITLE.merge(
                                              TextStyle(
                                                color: Colors.white,
                                                fontSize: calcSize(size, 24.2),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        Container(
                                          width: size.width * 0.8,
                                          height: calcSize(size, 40.0),
                                          child: Text(
                                            t['description'] ?? '',
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: FONT.REGULAR.merge(
                                              TextStyle(
                                                color: Colors.white,
                                                fontSize: calcSize(size, 15.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList()),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          width: size.width,
                          height: 30.0,
                          child: controller != null
                              ? Center(
                                  child: TabPageSelector(
                                    controller: controller,
                                    indicatorSize: calcSize(size, 10.0),
                                    color: Colors.transparent,
                                    selectedColor: COLOR.white,
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),
                  );
                } else {
                  /// loading
                  return Container();
                }
              },
            ),
          )
        : Container();
  }

  TextStyle get style {
    return FONT.TITLE.merge(
      TextStyle(
        color: Colors.white,
        fontSize: 27.0,
      ),
    );
  }
}
