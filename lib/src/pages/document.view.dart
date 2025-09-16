part of employ.pages;

class DocumentView extends ConsumerStatefulWidget {
  final String? category;
  final String? companyId;
  final String? documentId;
  final String? name;

  const DocumentView({
    Key? key,
    this.category,
    this.companyId,
    this.documentId,
    this.name,
  }) : super(key: key);

  @override
  _DocumentViewState createState() => _DocumentViewState();
}

class _DocumentViewState extends ConsumerState<DocumentView> {
  Document? document;
  String? path;
  bool signing = false;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final Database db = EmployProvider.of(context).database;
      String ref =
          'client/${widget.companyId}/${widget.category?.toLowerCase()}/${widget.documentId}';
      db.once(ref).then(generateVisibleDocument);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final manager = ref.watch(appProvider);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: document != null &&
                (document?.isPending ?? false) &&
                path != null
            ? Padding(
                padding: EdgeInsets.only(bottom: padding.bottom + 20.0),
                child: InkResponse(
                  onTap: sign,
                  child: Container(
                    height: calcSize(size, 53.0),
                    width: calcSize(size, 150.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: calcSize(size, 32.0)),
                    decoration: BoxDecoration(
                        gradient:
                            STYLES.dGradient(theme: manager.settings!.theme),
                        borderRadius:
                            BorderRadius.circular(calcSize(size, 26.6)),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 23.0,
                            spreadRadius: -8.0,
                            offset: Offset(0.0, 7.0),
                            color: COLOR.gradient[manager.settings!.theme]![1]
                                .withOpacity(0.5),
                          )
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Firmar",
                          style: FONT.TITLE.merge(
                            TextStyle(
                              color: COLOR.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Icon(EmployIcons.sign, size: 25.0, color: COLOR.white)
                      ],
                    ),
                  ),
                ),
              )
            : null,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              height: size.height,
              width: size.width,
              child: Stack(
                children: <Widget>[
                  (document != null && path != null && !signing)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: padding.top + 66.0,
                              width: size.width,
                              // color: Colors.red,
                              color: Platform.isAndroid
                                  ? COLOR.greyish_brown_two
                                  : Color.fromRGBO(116, 116, 116, 1.0),
                              padding: EdgeInsets.fromLTRB(
                                  10.0, padding.top, 10.0, 0.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () =>
                                        Application.router.pop(context),
                                    icon: Icon(Icons.close, color: COLOR.white),
                                    iconSize: 36.0,
                                  ),
                                  IconButton(
                                    onPressed: share,
                                    icon: Icon(EmployIcons.share,
                                        color: COLOR.white),
                                    iconSize: 26.0,
                                    // iconSize: 36.0,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: PdfView(path),
                              ),
                            ),
                          ],
                        )
                      : Container(
                          color: Color.fromRGBO(42, 42, 42, 1.0),
                          alignment: Alignment.center,
                          child: Container(
                            width: 150,
                            height: 150,
                            padding: EdgeInsets.all(10.0),
                            child: Center(
                              child: LottieAnim(
                                duration: Duration(milliseconds: 3000),
                                path: 'assets/animation/dot_animation.json',
                                size: Size(100.0, 100.0),
                                itRepeatable: true,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void generateVisibleDocument(dynamic value) async {
    document = Document.fromJson(value, category: widget.category!);
    File? file = await document?.download(context);
    if (file == null) {
      Application.router.pop(context);
      return;
    }
    path = file.path;
    if (mounted) setState(() {});
  }

  void share() {
    Vibration.vibrate(duration: 100);
    Share.shareXFiles([XFile(path!)]);
  }

  void openFile() {
    Vibration.vibrate(duration: 100);
    OpenFilex.open(path!);
  }

  void close() {
    Application.router.pop(context);
  }

  void sign() {
    final manager = ref.read(appProvider);
    String? module = widget.category == 'Paycheck'
        ? manager.employee!.modulePaycheckSign
        : manager.employee!.moduleDocumentSign;
    if (module == 'bio') {
      if (manager.employee!.signplify == null ||
          manager.employee!.signplify?.status == 2)
        SignDocumentMissing.build(context, ref).then((response) {
          if (response != null && response) navigateTo(BiometricSignature());
        });
      else if (manager.employee!.signplify?.status == 0)
        BottomSheetDialog.build(
          context,
          ref,
          'Tus credenciales están pendientes de aprobación intenta nuevamente más tarde',
        );
      else
        proccessSignature(
          canResetPin: manager.settings!.changePin,
          onlyAgree: manager.settings!.paycheckSignOnlyAgree,
        );
    } else if (module == 'pki') {
      if (manager.employee!.certificate != null &&
          manager.employee!.certificate?.key != null &&
          (manager.employee!.certificate?.valid ?? false))
        proccessSignature(
            canResetPin: manager.settings!.changePin,
            onlyAgree: manager.settings!.paycheckSignOnlyAgree);
      else
        navigateTo(PKISignature());
    } else if (module == 'arg') {
      proccessSignature(isArg: true);
    }
  }

  void navigateTo(Widget newRoute) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => newRoute,
      ),
    );
  }

  void proccessSignature({
    bool onlyAgree = false,
    bool canResetPin = false,
    bool hasOptions = true,
    bool isArg = false,
  }) {
    Timer(Duration(milliseconds: 200), () {
      signing = true;
      if (mounted) setState(() {});
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => isArg
            ? FirmarGob()
            : SignPage(
                canResetPin: canResetPin,
                hasOptions: widget.category == 'Paycheck' && !onlyAgree,
                onlyAgree: onlyAgree,
                category: widget.category!,
              ),
      ),
    ).then((payload) async {
      signing = false;
      if (mounted) setState(() {});
      if (payload != null) {
        final Database db = EmployProvider.of(context).database;
        final config = AppConfig.of(context);
        final manager = ref.read(appProvider);
        path = null;
        if (mounted) setState(() {});
        String? response = await document?.sign(
            agree: payload['document_status'],
            company: manager.company!,
            config: config,
            employee: manager.employee!,
            observation: payload['signer_observation'] ?? '',
            pin: payload['pin'],
            isArg: isArg,
            status: payload['document_status']);
        if (isArg) {
          bool canLauncheUrl = await canLaunchUrl(Uri.parse(response!));
          if (canLauncheUrl) {
            Application.router.pop(context);
            await canLaunchUrl(Uri.parse(response));
          }
        } else {
          if (response == null)
            Fluttertoast.showToast(
              msg: 'Pin incorrecto',
              gravity: ToastGravity.TOP,
              toastLength: Toast.LENGTH_LONG,
            );
          String ref =
              'client/${widget.companyId}/${widget.category?.toLowerCase()}/${widget.documentId}';
          db.once(ref).then(generateVisibleDocument);
        }
      }
    });
  }
}
