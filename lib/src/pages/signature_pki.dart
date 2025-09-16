part of employ.pages;

class PKISignature extends ConsumerStatefulWidget {
  @override
  _PKISignatureState createState() => _PKISignatureState();
}

class _PKISignatureState extends ConsumerState<PKISignature> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardHde = MediaQuery.of(context).viewInsets.bottom == 0.0;
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
                      margin: EdgeInsets.only(top: 4.0, bottom: 2.0),
                      padding: EdgeInsets.only(top: 20.0),
                      width: size.width,
                      height: size.height * 0.42,
                      child: Image.asset('assets/images/onbording_pki.png',
                          fit: BoxFit.cover),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Creá tu firma electrónica',
                        textAlign: TextAlign.center,
                        style: FONT.TITLE.merge(
                          TextStyle(
                              color: COLOR.white,
                              fontSize: calcSize(size, 28.0)),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Y empezá a firmar tus documentos',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: COLOR.white,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: calcSize(size, 16.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              isKeyboardHde
                  ? Positioned(
                      bottom: padding.bottom,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.0),
                        width: size.width,
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
                              action: () {
                                Application.router.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PKIData(),
                                  ),
                                );
                              },
                              icon: EmployIcons.btm_next_dark,
                              size: calcSize(size, 60.0),
                              theme: Brightness.light,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
