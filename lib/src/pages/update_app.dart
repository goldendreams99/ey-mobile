part of employ.pages;

class UpdateApp extends StatefulWidget {
  @override
  _UpdateAppState createState() => _UpdateAppState();
}

class _UpdateAppState extends State<UpdateApp> {

  void upgradeApp() {
    var config = AppConfig.of(context);
    StoreRedirect.redirect(
      androidAppId: config.androidId,
      iOSAppId: config.iosId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    return Scaffold(
      backgroundColor: COLOR.white,
      body: BackToExit(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              height: size.height,
              width: size.width,
              padding: EdgeInsets.only(bottom: 56.0 + padding.bottom),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: STYLES.vGradient(
                  colors: [
                    Color.fromRGBO(102, 62, 173, 1.0),
                    Color.fromRGBO(161, 67, 198, 1.0),
                  ],
                ),
              ),
              child: Image.asset(
                'assets/images/upgrade.png',
                width: size.width * 0.9,
              ),
            ),
            Positioned(
              bottom: calcSize(size, padding.bottom + 21.0),
              child: Container(
                child: InkResponse(
                  onTap: upgradeApp,
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
                          color: Color.fromRGBO(92, 136, 255, 0.5),
                        )
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Actualizar ahora',
                        style: FONT.TITLE.merge(
                          TextStyle(
                            fontWeight: FontWeight.w600,
                            color: COLOR.greyish_brown_three,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
