part of employ.pages;

class FirmarGob extends ConsumerStatefulWidget {
  @override
  _FirmarGobState createState() => _FirmarGobState();
}

class _FirmarGobState extends ConsumerState<FirmarGob> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final manager = ref.watch(appProvider);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: STYLES.vGradient(theme: manager.settings!.theme),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                height: size.height,
                width: size.width,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 22.0),
                      width: size.width,
                      height: size.height * 0.42,
                      child: Image.asset('assets/images/onbording_bio.png',
                          fit: BoxFit.cover),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Utilizá tus credenciales de firma digital',
                        textAlign: TextAlign.center,
                        style: FONT.TITLE.merge(
                          TextStyle(color: COLOR.white, fontSize: 28.0),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Y empezá a firmar todo tipo de documentos.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: COLOR.white,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 67.0),
                      margin: EdgeInsets.symmetric(horizontal: 28.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Image.asset('assets/images/firmar_logo.png',
                              height: 34.0),
                          Image.asset('assets/images/ministerio.png',
                              width: 153.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: padding.bottom + 20.0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.0),
                  constraints:
                      BoxConstraints.tightFor(height: 60.0, width: size.width),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FooterButton(
                        action: () => Application.router.pop(context),
                        icon: EmployIcons.btm_close_dark,
                        size: calcSize(size, 60.0),
                        theme: Brightness.light,
                      ),
                      FooterButton(
                        action: () => Navigator.of(context).pop({
                          'document_status': 3,
                        }),
                        icon: EmployIcons.btm_check_dark,
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
      ),
    );
  }
}
