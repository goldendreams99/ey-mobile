part of employ.pages;

class LicenseView extends ConsumerStatefulWidget {
  final String? companyId;
  final String? licenseId;
  final String? name;
  final bool isRecent;

  const LicenseView({
    Key? key,
    this.companyId,
    this.licenseId,
    this.name,
    this.isRecent = false,
  }) : super(key: key);

  @override
  _LicenseViewState createState() => _LicenseViewState();
}

class _LicenseViewState extends ConsumerState<LicenseView> {
  License? document;
  String? path;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final Database db = EmployProvider.of(context).database;
      if (document == null) {
        String ref = 'client/${widget.companyId}/license/${widget.licenseId}';
        db.once(ref).then((value) async {
          document = License.fromJson(value);
          if (document?.signRequired == true) {
            File? file = await document!.download(context);
            path = file?.path;
          }
          if (mounted) setState(() {});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final manager = ref.read(appProvider);
    return Scaffold(
      body: document == null ||
              (document != null && document!.signRequired && path == null)
          ? Stack(
              fit: StackFit.expand,
              children: <Widget>[
                LayoutBuilder(builder: (context, constraints) {
                  return Container(
                    height: constraints.maxHeight,
                    width: size.width,
                    decoration: BoxDecoration(
                      gradient: STYLES.vGradient(
                        theme: manager.settings!.theme,
                      ),
                    ),
                    padding: EdgeInsets.only(
                      left: 30.0,
                      right: 30.0,
                      top: 50.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: constraints.maxHeight - 50.0,
                          width: size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.name ?? '',
                                style: FONT.TITLE.merge(
                                  TextStyle(
                                    color: COLOR.white,
                                    fontSize: 35.0,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      height: constraints.maxHeight - 150.0,
                                      width: size.width,
                                      child: widget.isRecent
                                          ? null
                                          : SizedBox(
                                              width: calcSize(size, 160.0),
                                              height: calcSize(size, 160.0),
                                              child: LottieAnim(
                                                duration: Duration(
                                                    milliseconds: 1500),
                                                path:
                                                    'assets/animation/dot_animation.json',
                                                size: Size(
                                                    calcSize(size, 160.0),
                                                    calcSize(size, 160.0)),
                                                itRepeatable: true,
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                Positioned(
                  bottom: padding.bottom + 10.0,
                  left: 16.0,
                  child: Container(
                    alignment: Alignment.bottomLeft,
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
            )
          : Container(
              height: size.height,
              width: size.width,
              color: COLOR.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: size.height -
                        calcSize(size, document == null ? 116 : 0),
                    width: size.width,
                    child: LicenseViewNonSignature(
                      license: document,
                      path: path,
                      onSigned: changeStatus,
                      isRecently: widget.isRecent,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void changeStatus() {
    final Database db = EmployProvider.of(context).database;
    String ref = 'client/${widget.companyId}/license/${widget.licenseId}';
    db.once(ref).then((value) async {
      document = License.fromJson(value);
      File? file = await document?.download(context);
      path = file?.path;
      if (mounted) setState(() {});
    });
  }
}
