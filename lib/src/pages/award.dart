part of employ.pages;

class EmployAward extends ConsumerStatefulWidget {
  final String? companyId;
  final String? documentId;
  final String? name;

  const EmployAward({
    Key? key,
    this.companyId,
    this.documentId,
    this.name,
  }) : super(key: key);

  @override
  _EmployAwardState createState() => _EmployAwardState();
}

class _EmployAwardState extends ConsumerState<EmployAward>
    with TickerProviderStateMixin {
  bool filterInitialized = false;
  late TabController controller;
  bool dataIsVisible = false;
  late Animation topColorTween;
  late Animation bottomColorTween;

  @override
  void initState() {
    controller = TabController(vsync: this, initialIndex: 0, length: 2);
    controller.addListener(() {
      setState(() {});
    });
    topColorTween = ColorTween(
      begin: Color.fromRGBO(78, 12, 195, 1.0),
      end: Color.fromRGBO(35, 56, 174, 1.0),
    ).animate(controller.animation!);
    bottomColorTween = ColorTween(
      begin: Color.fromRGBO(161, 67, 198, 1.0),
      end: Color.fromRGBO(76, 150, 221, 1.0),
    ).animate(controller.animation!);
    Timer(Duration(milliseconds: 1000), () {
      dataIsVisible = true;
      if (mounted) setState(() {});
    });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final manager = ref.watch(appProvider);
    final Database db = EmployProvider.of(context).database;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: AnimatedBuilder(
        animation: controller.animation!,
        builder: (context, child) {
          return Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
              gradient: STYLES.vGradient(
                colors: [
                  topColorTween.value,
                  bottomColorTween.value,
                ],
              ),
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
                                bool hasInfo = dataIsVisible &&
                                    snapshot.hasData &&
                                    snapshot.data?.snapshot.value != null;
                                DatabaseEvent data;
                                List<Award> documents = [];
                                if (hasInfo) {
                                  data = snapshot.data!;
                                  Map<dynamic, dynamic> value =
                                      Map.from(data.snapshot.value as dynamic);
                                  value.keys.forEach((k) {
                                    documents.add(Award.fromJson(
                                      manager.employee!,
                                      value[k],
                                    ));
                                  });
                                }
                                return Column(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: padding.top + 20.0),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Awards",
                                            textAlign: TextAlign.left,
                                            style: FONT.TITLE.merge(
                                              TextStyle(
                                                color: COLOR.white,
                                                fontSize: 34.0,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                InkResponse(
                                                  onTap:
                                                      Employee.receivedAwards(
                                                                      documents)
                                                                  .length >
                                                              0
                                                          ? showReceiveds
                                                          : null,
                                                  child: AwardDiamontContainer(
                                                    value:
                                                        Employee.receivedAwards(
                                                                documents)
                                                            .length,
                                                    isReceived: true,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                InkResponse(
                                                  onTap: Employee.sendedAwards(
                                                                  documents)
                                                              .length >
                                                          0
                                                      ? () => showAward(false)
                                                      : null,
                                                  child: AwardDiamontContainer(
                                                    value: manager.settings!
                                                            .awardLimitMonthlyTotal -
                                                        Employee.sendedAwards(
                                                                documents)
                                                            .length,
                                                    isReceived: false,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: LayoutBuilder(
                                        builder: (_, constraint) {
                                          final double dH = size.height -
                                              constraint.maxHeight;
                                          return Column(
                                            children: <Widget>[
                                              Container(
                                                height: constraint.maxHeight -
                                                    calcSize(size, dH - 28.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      height:
                                                          calcSize(size, 400.0),
                                                      width: size.width,
                                                      child: TabBarView(
                                                        controller: controller,
                                                        children: <Widget>[
                                                          EmployAwardSent(
                                                            documents,
                                                            () =>
                                                                showAward(true),
                                                            () => showAward(
                                                                false),
                                                          ),
                                                          EmployAwardReceived(
                                                              documents,
                                                              showReceiveds),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 30.0),
                                                      width: size.width,
                                                      child: Center(
                                                        child: TabPageSelector(
                                                          controller:
                                                              controller,
                                                          indicatorSize:
                                                              calcSize(
                                                                  size, 10.0),
                                                          color: Colors
                                                              .transparent,
                                                          selectedColor:
                                                              COLOR.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                        : Container()
                  ],
                ),
                !dataIsVisible ? renderDotLoading(size) : Container()
              ],
            ),
          );
        },
      ),
    );
  }

  void showFilters() {
    Application.router.navigateTo(
      context,
      Routes.filter,
      transitionDuration: Duration(milliseconds: 200),
      transition: fluro.TransitionType.inFromBottom,
    );
  }

  void initFilters() {
    if (!filterInitialized && mounted) {
      filterInitialized = true;
      Timer(Duration(milliseconds: 200), () {
        if (mounted) {
          final filtersNotifier = ref.read(filterProvider.notifier);
          final manager = ref.read(appProvider);
          int year = DateTime.now().year + 1;
          int createdYear = manager.company!.created.year;
          filtersNotifier.setYears(
            List.generate((year + 1) - createdYear, (i) {
              return createdYear + i;
            }).reversed.toList(),
          );
          filtersNotifier.setStates(['Todos', 'Firmados', 'Pendientes']);
          filtersNotifier.setState('Todos');
          filtersNotifier.setYear(DateTime.now().year);
        }
      });
    }
  }

  Container renderEmptyState(ConnectionState state) {
    return Container(alignment: Alignment.center);
  }

  Widget renderAwards(int limit, List<Award> documents) {
    final size = MediaQuery.of(context).size;
    List<Widget> avatars = [];
    int count = (documents.length > 3 ? 3 : documents.length);
    for (var i = 0; i < count; i++) {
      avatars.add(
        Positioned(
          left: 0.0 + i * 21,
          child: Container(
            width: 42.0,
            height: 42.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21.0),
              color: i % 2 == 0 ? Colors.blue : Colors.yellow,
            ),
          ),
        ),
      );
    }
    return Container(
      width: size.width * 0.65,
      height: 42.0,
      child: Stack(
        children: <Widget>[]..addAll(avatars),
      ),
    );
  }

  void showAward(bool isNew) {
    final menu = ref.read(menuProvider);
    if (!menu.isShown)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return isNew
                ? WillPopScope(
                    onWillPop: () async => false,
                    child: NewAward(),
                  )
                : AwardSentList();
          },
        ),
      );
  }

  void showReceiveds() {
    final menu = ref.read(menuProvider);
    if (!menu.isShown)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return AwardReceivedList();
          },
        ),
      );
  }
}
