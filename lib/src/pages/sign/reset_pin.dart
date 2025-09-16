part of employ.pages;

class SignResetPinPage extends StatefulWidget {
  @override
  _SignResetPinPageState createState() => _SignResetPinPageState();
}

class _SignResetPinPageState extends State<SignResetPinPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Reestableceremos tu',
            textAlign: TextAlign.center,
            style: FONT.TITLE.merge(
              TextStyle(color: COLOR.white, fontSize: 28.0),
            ),
          ),
          Text(
            ' PIN, ¿Estás seguro?',
            textAlign: TextAlign.center,
            style: FONT.TITLE.merge(
              TextStyle(color: COLOR.white, fontSize: 32.0),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            'Deberás iniciar sesión nuevamente para que confirmemos tu identidad',
            textAlign: TextAlign.center,
            style:
                FONT.TITLE.merge(TextStyle(color: COLOR.white, fontSize: 16.3)),
          ),
        ],
      ),
    );
  }
}
