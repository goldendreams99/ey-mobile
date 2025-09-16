part of employ.widgets;

class ResetPasswordBording extends ConsumerStatefulWidget {
  @override
  _ResetPasswordBordingState createState() => _ResetPasswordBordingState();
}

class _ResetPasswordBordingState extends ConsumerState<ResetPasswordBording> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                gradient: STYLES.vGradient(theme: 'purple'),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: padding.top + 50.0),
                    height: calcSize(size, 240.0),
                    width: calcSize(size, 280.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/onbording_rp.png'),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      'Te hemos enviado instrucciones a tu dirección de mail para restablecer tu cuenta',
                      textAlign: TextAlign.center,
                      style: FONT.TITLE.merge(
                        TextStyle(
                          color: COLOR.white,
                          fontSize: calcSize(size, 25.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: calcSize(size, padding.bottom + 21.0),
              child: Container(
                child: InkResponse(
                  onTap: runToHome,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
                    decoration: BoxDecoration(
                      color: COLOR.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          offset: Offset(0, 7),
                          blurRadius: 12,
                          spreadRadius: -4,
                          color: Color.fromRGBO(255, 92, 235, 0.5),
                        )
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Iniciar sesión',
                        style: FONT.TITLE.merge(
                          TextStyle(
                            fontWeight: FontWeight.w600,
                            color: COLOR.greyish_brown_three,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void runToHome() {
    Application.router.navigateTo(
      context,
      Routes.login,
      replace: true,
      clearStack: true,
    );
  }

  Container generateTemplate(String title, String assetName) {
    final size = MediaQuery.of(context).size;
    final settings = ref.read(appProvider).settings;
    return Container(
      padding: EdgeInsets.only(
        top: calcSize(size, 70.0),
      ),
      decoration: BoxDecoration(
        gradient: STYLES.vGradient(theme: settings!.theme),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: calcSize(size, 20.0)),
            height: calcSize(size, 283.0),
            width: calcSize(size, 280.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/$assetName'),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: FONT.TITLE.merge(
                TextStyle(
                  color: COLOR.white,
                  fontSize: calcSize(size, 25.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
