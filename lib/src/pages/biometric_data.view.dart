part of employ.pages;

class BiometricDataView extends ConsumerStatefulWidget {
  final EmployeeSignplify? signplify;

  const BiometricDataView({this.signplify});

  @override
  _BiometricDataViewState createState() => _BiometricDataViewState();
}

class _BiometricDataViewState extends ConsumerState<BiometricDataView>
    with SingleTickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    super.initState();
    controller =
        TabController(vsync: this, initialIndex: 0, length: items.length);
    controller?.addListener(() {
      if (mounted) setState(() {});
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
    final settings = ref.watch(
      appProvider.select((value) => value.settings),
    );
    final data = items;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: STYLES.vGradient(theme: settings!.theme),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: calcSize(size, 116),
                  width: size.width,
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.fromLTRB(22.0, 0, 12.0, 19.0),
                  child: Text(
                    'Datos Biométricos',
                    style: FONT.TITLE.merge(
                      TextStyle(fontSize: 30.0, color: COLOR.white),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  height: size.height * 0.52,
                  width: size.width,
                  child: TabBarView(
                    controller: controller,
                    children: <Widget>[]..addAll(
                        List.generate(
                          data.length,
                          (i) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 7.7),
                              decoration: BoxDecoration(
                                color: COLOR.black.withOpacity(0.13),
                                borderRadius: BorderRadius.circular(20.9),
                                image: DecorationImage(
                                  fit: data[i].contains('signature')
                                      ? BoxFit.contain
                                      : BoxFit.fitHeight,
                                  image: NetworkImage(
                                    data[i],
                                  ),
                                ),
                              ),
                              width: size.width * 0.88,
                              height: size.height * 0.52,
                            );
                          },
                        ),
                      ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 18),
                  width: size.width,
                  child: Center(
                    child: TabPageSelector(
                      controller: controller,
                      indicatorSize: calcSize(size, 10.0),
                      color: Colors.transparent,
                      selectedColor: COLOR.white,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: padding.bottom,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.0),
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkResponse(
                      onTap: resetBiometricData,
                      child: Container(
                        height: 60.0,
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        alignment: Alignment.center,
                        child: Text(
                          "Restablecer ",
                          style: FONT.TITLE.merge(
                            TextStyle(color: COLOR.white, fontSize: 16.0),
                          ),
                        ),
                      ),
                    ),
                    FooterButton(
                      action: () => Application.router.pop(context),
                      icon: EmployIcons.btm_close_dark,
                      size: calcSize(size, 60.0),
                      theme: Brightness.light,
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

  List<String> get items {
    List<String> pictures = widget.signplify?.signature != null
        ? [widget.signplify!.signature]
        : [];
    if (widget.signplify?.frontal != null)
      pictures.add(widget.signplify!.frontal);
    if (widget.signplify?.dorso != null) pictures.add(widget.signplify!.dorso);
    if (widget.signplify?.selfie != null)
      pictures.add(widget.signplify!.selfie);
    return pictures;
  }

  void resetBiometricData() {
    BottomSheetDialog.build(
      context,
      ref,
      '''Reestableceremos tu PIN, ¿Estás seguro?

Deberás iniciar sesión nuevamente para que confirmemos tu identidad
    ''',
      height: 320.0,
      onAccept: reset,
    );
  }

  void reset() {
    Application.router.pop(context);
    final manager = ref.read(appProvider);
    Timer(Duration(milliseconds: 300), () async {
      final provider = EmployProvider.of(context);
      String ref =
          'client/${manager.company!.id}/employee/${manager.employee!.id}/signplify';
      await provider.database.remove(ref);
      provider.messaging?.unsubscribe(manager.employee);
      provider.auth?.signOut();
      Application.router
          .navigateTo(context, Routes.login, replace: true, clearStack: true);
    });
  }
}
