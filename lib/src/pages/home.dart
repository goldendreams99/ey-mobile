part of employ.pages;

class Home extends ConsumerStatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> with TickerProviderStateMixin {
  bool visibleIcons = false;
  bool revealed = false;
  bool closed = false;
  bool plusEnabled = false;
  double fraction = 1.0;
  late Animation<double> progressAnimation;
  AnimationController? progressController;
  double opacity = 1.0;
  Widget visibleWidget = Container();

  @override
  void dispose() {
    progressController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final manager = ref.read(appProvider);
      if (manager.valid) {
        visibleWidget = getHomeScreen();
        var type = visibleWidget.runtimeType;
        plusEnabled = (type == EmployExpense ||
            type == EmployLicense ||
            type == EmployTicket);
        setState(() {});
      }
    });
  }

  @override
  void deactivate() {
    reset();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final manager = ref.watch(appProvider);
    final size = MediaQuery.of(context).size;
    final List<dynamic> opts = options;
    final breakPoint = opts.indexWhere((e) => e['route'] == null);
    _validateAppVersion(manager.settings?.mobileVersion);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: COLOR.white,
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: calcSize(size, 24.0) + 6.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: plusEnabled
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.end,
            children: !(revealed || !manager.valid)
                ? <Widget>[
                    plusEnabled
                        ? Container(
                            margin: EdgeInsets.only(bottom: 12.0),
                            child: InkResponse(
                              borderRadius: BorderRadius.circular(
                                calcSize(size, 28.45),
                              ),
                              onTap: onAdd,
                              child: Container(
                                height: calcSize(size, 56.95),
                                width: calcSize(size, 56.95),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: COLOR.black.withOpacity(0.5),
                                      offset: Offset(0, 6),
                                      blurRadius: 10,
                                      spreadRadius: -7,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(
                                    calcSize(size, 28.45),
                                  ),
                                ),
                                child: AnimatedOpacity(
                                  opacity: opacity,
                                  duration: Duration(seconds: 1),
                                  child: Image.asset(
                                    'assets/images/icons/${manager.settings!.theme}_add.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    InkWell(
                      borderRadius: BorderRadius.circular(
                        calcSize(size, 33.5),
                      ),
                      onTap: revealed ? hide : reveal,
                      child: Container(
                        height: calcSize(size, 67.0),
                        width: calcSize(size, 67.0),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: COLOR.black.withOpacity(0.5),
                              offset: Offset(0, 6),
                              blurRadius: 10,
                              spreadRadius: -7,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(
                            calcSize(size, 33.5),
                          ),
                        ),
                        child: AnimatedOpacity(
                          opacity: opacity,
                          duration: Duration(seconds: 1),
                          child: Image.asset(
                            'assets/images/icons/${manager.settings!.theme}_menu.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ]
                : <Widget>[],
          ),
        ),
        body: BackToExit(
          child: Listener(
            onPointerUp: dragEnd,
            onPointerDown: dragStart,
            child: LayoutBuilder(
              builder: (context, constraints) {
                List<Widget> _menuOptions = menuOptions(breakPoint, opts);
                return Container(
                  constraints: constraints,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 20),
                        transitionBuilder: (Widget child,
                                Animation<double> animation) =>
                            FadeTransition(child: child, opacity: animation),
                        child: visibleWidget,
                      ),
                      revealed
                          ? CustomPaint(
                              size: Size.infinite,
                              foregroundPainter: GradientCanvas(
                                manager.settings!.theme,
                                fraction,
                                size,
                              ),
                            )
                          : Container(),
                      !visibleIcons
                          ? Container()
                          : Positioned(
                              bottom: 0.0,
                              child: Container(
                                height: calcSize(size, 94.0) *
                                        (opts.length / 4).ceilToDouble() +
                                    calcSize(size, 83.0),
                                width: size.width,
                                padding: _menuOptions.length > 3
                                    ? null
                                    : EdgeInsets.only(right: 16.0),
                                child: Column(
                                  crossAxisAlignment: _menuOptions.length > 3
                                      ? CrossAxisAlignment.center
                                      : CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.topRight,
                                      padding: EdgeInsets.only(
                                        right: calcSize(size, 16.0),
                                      ),
                                      child: Text(
                                        LABEL.whatDoYouWant,
                                        style: FONT.TITLE.merge(
                                          TextStyle(
                                            color: COLOR.white,
                                            fontSize: calcSize(size, 23.4),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: calcSize(size, 35.0),
                                    ),
                                    Wrap(
                                      spacing: calcSize(size, 18.0),
                                      runSpacing: calcSize(size, 16.0),
                                      alignment: WrapAlignment.end,
                                      verticalDirection: VerticalDirection.up,
                                      runAlignment: WrapAlignment.end,
                                      children: _menuOptions,
                                    ),
                                  ],
                                ),
                              ),
                            )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _validateAppVersion(int? minBuildVersion) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);
    if (buildNumber < (minBuildVersion ?? 0)) {
      Application.router.navigateTo(
        context,
        Routes.update,
        clearStack: true,
      );
    }
  }

  void reset() {
    fraction = 0.0;
  }

  void reveal() {
    Vibration.vibrate(duration: 100);
    ref.read(menuProvider.notifier).setIsShown(true);
    setState(() => revealed = true);
    Timer(Duration(milliseconds: 50), () {
      visibleIcons = true;
      if (mounted) setState(() {});
    });
    progressController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    progressAnimation = Tween(begin: 0.0, end: 1.0).animate(progressController!)
      ..addListener(() {
        fraction = progressAnimation.value;
        setState(() {});
      })
      ..addStatusListener((AnimationStatus state) {
        if (closed && state == AnimationStatus.dismissed)
          setState(() => revealed = false);
      });
    if (mounted) progressController?.forward();
  }

  void hide() {
    Vibration.vibrate(duration: 100);
    ref.read(menuProvider.notifier).setIsShown(false);
    if (progressController?.isAnimating == true) {
      progressController?.stop(canceled: true);
    }
    closed = true;
    visibleIcons = false;
    progressController?.reverse(from: 0.0);
    setState(() {});
  }

  Widget getHomeScreen() {
    final manager = ref.read(appProvider);
    // Si module_feed está habilitado, Feed es la pantalla inicial
    if (manager.settings!.moduleFeed) return MainFeed();
    // Sino, Nóminas es la pantalla inicial (si está disponible)
    if (manager.employee!.modulePaycheck) return EmployPaycheck();
    // Si no hay Nóminas, seguir el orden original de zBackup
    if (manager.employee!.moduleDocument) return EmployDocument();
    if (manager.settings!.moduleLicense && manager.employee!.moduleLicense)
      return EmployLicense();
    if (manager.settings!.moduleExpense && manager.employee!.moduleExpense)
      return EmployExpense();
    if (manager.settings!.moduleAward && manager.employee!.moduleAward)
      return EmployAward();
    if (manager.employee!.moduleChat) return EmployTicket();
    return Profile();
  }

  List<dynamic> get options {
    final manager = ref.read(appProvider);
    List<dynamic> list = [];
    if (manager.settings!.moduleAward && manager.employee!.moduleAward)
      list.add(optionContent('route', 'award', 'Awards', EmployAward()));
    if (manager.settings!.moduleExpense && manager.employee!.moduleExpense)
      list.add(optionContent('route', 'expense', 'Gastos', EmployExpense()));
    if (manager.employee!.modulePaycheck)
      list.add(optionContent('route', 'paysheet', 'Nóminas', EmployPaycheck()));
    if (manager.employee!.moduleDocument)
      list.add(optionContent('route', 'document', 'Docs', EmployDocument()));
    if (manager.employee!.moduleChat)
      list.add(optionContent('route', 'chat', 'Chats', EmployTicket()));
    if (manager.settings!.moduleLicense && manager.employee!.moduleLicense)
      list.add(optionContent('route', 'license', 'Licencias', EmployLicense()));
    if (manager.settings!.moduleInbox)
      list.add(optionContent('route', 'inbox', 'Inbox', EmployInbox()));
    int profileIndex = list.length >= 3 ? 2 : list.length;
    list.insert(
        profileIndex, optionContent('route', 'profile', 'Perfil', Profile()));
    int closeIndex = list.length >= 3 ? 3 : list.length;
    list.insert(closeIndex, optionContent(null, 'close', '', Container()));
    // Agregar Feed si está habilitado
    if (manager.settings!.moduleFeed)
      list.add(optionContent('route', 'feed', 'Feed', MainFeed()));
    return list;
  }

  List<Widget> menuOptions(int breakPoint, List<dynamic> opts) {
    return List.generate(opts.length, (index) {
      final e = opts[index];
      return MenuButton(
        index: index,
        action: index == breakPoint
            ? hide
            : () {
                final previousType = visibleWidget.runtimeType;
                visibleWidget = e['content'];
                final type = visibleWidget.runtimeType;
                if (type == EmployExpense ||
                    type == EmployLicense ||
                    type == EmployTicket)
                  plusEnabled = true;
                else
                  plusEnabled = false;
                final newType = visibleWidget.runtimeType;
                if (previousType == EmployAward ||
                    newType == EmployAward ||
                    previousType == Profile ||
                    newType == Profile) {
                  Timer(Duration(milliseconds: 200), hide);
                } else {
                  hide();
                }
                setState(() {});
              },
        assetName: '${e['icon']}.png',
        filled: breakPoint != index,
        outlined: breakPoint == index,
        text: e['label'],
        closePosition: breakPoint,
      );
    });
  }

  dynamic optionContent(String? route, String icon, String tag, Widget w) {
    return {'route': route, 'icon': icon, 'label': tag, 'content': w};
  }

  void dragStart(_) {
    opacity = 0.70;
    setState(() {});
  }

  void dragEnd(_) {
    opacity = 1.0;
    setState(() {});
  }

  Future<void> prepareCamera() async {
    bool canOpenCamera = await canTakePicture(context);
    if (canOpenCamera) {
      List<CameraDescription> cameras = await availableCameras();
      if (cameras.length > 0)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmployExpenseCamera(
              cameras[0],
              canSkip: true,
            ),
          ),
        );
    }
  }

  void onAdd() {
    switch (visibleWidget.runtimeType) {
      case EmployLicense:
        Application.router.navigateTo(
          context,
          Routes.newLicense,
          transition: fluro.TransitionType.inFromBottom,
        );
        break;
      case EmployExpense:
        Application.router.navigateTo(
          context,
          Routes.newExpense,
          transition: fluro.TransitionType.inFromBottom,
          routeSettings: RouteSettings(
            arguments: {'fromScanner': false},
          ),
        );
        break;
      case EmployTicket:
        Application.router.navigateTo(context, Routes.newTicket);
        break;
      default:
        break;
    }
  }
}
