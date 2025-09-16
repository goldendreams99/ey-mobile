part of employ.widgets;

class ChangePasswordOnBording extends StatefulWidget {
  @override
  _ChangePasswordOnBordingState createState() =>
      _ChangePasswordOnBordingState();
}

class _ChangePasswordOnBordingState extends State<ChangePasswordOnBording> {
  @override
  void initState() {
    super.initState();
  }

  void changePassword() {
    Application.router.navigateTo(
      context,
      Routes.changePassword,
      replace: true,
      clearStack: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    return WillPopScope(
      onWillPop: () async => false,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          body: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(
                  gradient: STYLES.vGradient(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: calcSize(size, 220.0),
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
                        'Para tu seguridad, cambia la contraseña',
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
                bottom: padding.bottom,
                right: 3.0,
                child: FooterButton(
                  action: changePassword,
                  icon: EmployIcons.btm_next_dark,
                  size: calcSize(size, 60.0),
                  theme: Brightness.light,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
