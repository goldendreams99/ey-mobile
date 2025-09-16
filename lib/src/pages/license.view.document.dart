part of employ.pages;

class LicenseViewDocument extends ConsumerStatefulWidget {
  final License? license;
  final String? path;
  final Function? onSigned;

  const LicenseViewDocument({this.license, this.path, this.onSigned});

  @override
  _LicenseViewDocumentState createState() => _LicenseViewDocumentState();
}

class _LicenseViewDocumentState extends ConsumerState<LicenseViewDocument> {
  String? path;
  License? license;
  bool signing = false;
  bool signingModal = false;

  @override
  void initState() {
    super.initState();
    path = widget.path;
    license = widget.license;
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
        floatingActionButton: license!.status == 0 && !signing
            ? Padding(
                padding: EdgeInsets.only(bottom: padding.bottom + 20.0),
                child: InkResponse(
                  onTap: sign,
                  child: Container(
                    height: calcSize(size, 53.0),
                    width: calcSize(size, 166.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: calcSize(size, 32.0)),
                    decoration: BoxDecoration(
                      gradient:
                          STYLES.dGradient(theme: manager.settings!.theme),
                      borderRadius: BorderRadius.circular(calcSize(size, 26.6)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Firmar",
                          style: FONT.TITLE.merge(
                            TextStyle(
                                color: COLOR.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 17.0),
                          ),
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
                  (license != null && path != null && !signingModal)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: padding.top + 66.0,
                              width: size.width,
                              color: COLOR.greyish_brown_two,
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
                                    // onPressed: () => DocumentDetailDialog.build(
                                    //   context,
                                    //   openFile,
                                    //   share,
                                    // ),
                                    // icon: Icon(Icons.more_vert,
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

  Future<void> generateVisibleDocument(dynamic value) async {
    license = License.fromJson(value);
    signing = false;
    File? file = await license?.download(context);
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

  void sign() {
    final manager = ref.read(appProvider);
    String? module = manager.employee!.moduleLicenseSign;
    if (module == 'bio') {
      if (manager.employee!.signplify == null ||
          manager.employee!.signplify?.status == 2)
        navigateTo(BiometricSignature());
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
          hasOptions: false,
        );
      else
        navigateTo(PKIData());
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

  void proccessSignature(
      {bool onlyAgree = false,
      bool canResetPin = false,
      bool hasOptions = true,
      bool isArg = false}) {
    Timer(Duration(milliseconds: 500), () {
      signing = true;
      signingModal = true;
      if (mounted) setState(() {});
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => isArg
            ? FirmarGob()
            : SignPage(
                canResetPin: canResetPin,
                hasOptions: false,
                onlyAgree: onlyAgree,
              ),
      ),
    ).then((payload) async {
      signingModal = false;
      if (mounted) setState(() {});
      if (payload != null) {
        final Database db = EmployProvider.of(context).database;
        final config = AppConfig.of(context);
        final manager = ref.read(appProvider);
        path = null;
        if (mounted) setState(() {});
        String? response = await license?.sign(
          config: config,
          status: manager.settings!.licenseAuthApprover ? 1 : 2,
          observation: payload['signer_observation'] ?? '',
          company: manager.company!,
          employee: manager.employee!,
          license: license!,
          pin: payload['pin'],
          isArg: isArg,
        );
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
          String ref = 'client/${manager.company!.id}/license/${license?.id}';
          Timer(Duration(milliseconds: 500), () async {
            var newDoc = await db.once(ref);
            await generateVisibleDocument(newDoc);
            widget.onSigned?.call();
          });
        }
        signing = false;
      } else {
        signing = false;
        if (mounted) setState(() {});
      }
    });
  }
}
