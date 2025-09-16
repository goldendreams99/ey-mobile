part of employ.widgets;

class SignDialog {
  static Future<dynamic> build(
    BuildContext _context,
    String username,
  ) async {
    ScrollController scrollController = ScrollController();
    return showDialog(
      barrierDismissible: true,
      context: _context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SingleChildScrollView(
              controller: scrollController,
              child: SignDialogContent(
                username: username,
              ),
            ),
          ),
        );
      },
    );
  }
}

class SignDialogContent extends ConsumerStatefulWidget {
  final String username;

  SignDialogContent({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  SignDialogContentState createState() => SignDialogContentState();
}

class SignDialogContentState extends ConsumerState<SignDialogContent> {
  String? text;
  List<String> options = ['Conforme', 'No conforme'];
  final TextEditingController textControl = TextEditingController();
  final TextEditingController pinControl = TextEditingController();
  final ScrollController scrollController = ScrollController();
  late Map<String, dynamic> payload;
  bool isPasswordVisible = false;
  bool agreedPanel = false;

  @override
  void initState() {
    payload = {
      'signer_pin': null,
      'document_status': 3,
      'signer_observation': null,
    };
    super.initState();
  }

  void changePin(String text) {
    setState(() {
      payload['signer_pin'] = text;
    });
  }

  bool get canSign {
    return (payload['signer_pin'] == null || payload['signer_pin'].isEmpty) ||
        (payload['document_status'] == 4 &&
            (payload['signer_observation'] == null ||
                payload['signer_observation'].isEmpty));
  }

  void showPassword() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void showPanel() {
    setState(() {
      agreedPanel = !agreedPanel;
    });
  }

  @override
  void dispose() {
    pinControl.dispose();
    textControl.dispose();
    super.dispose();
  }

  void sign() {
    if (!canSign) return;
    Vibration.vibrate(duration: 100);
    Navigator.pop(context, payload);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final settings = ref.watch(
      appProvider.select((value) => value.settings),
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  '¿Firmamos?',
                  style: FONT.TITLE.merge(
                    TextStyle(
                      color: COLOR.brownish_grey,
                      fontSize: 19.2,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_drop_down),
                color: agreedPanel ? COLOR.pink_red : COLOR.greyish_brown_four,
                onPressed: showPanel,
              ),
            ],
          ),
        ),
        (agreedPanel
            ? Container(
                margin: EdgeInsets.only(bottom: 24.0),
                width: size.width * 0.89,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Radio(
                          activeColor: COLOR.gradient[settings!.theme]![0],
                          value: 3,
                          groupValue: payload['document_status'],
                          onChanged: (v) {
                            setState(() {
                              payload['document_status'] = 3;
                            });
                          },
                        ),
                        Text(
                          'Conforme',
                          style: TextStyle(
                            color: COLOR.brown_grey_three,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 12.0,
                          ),
                        ),
                        Radio(
                          activeColor: COLOR.gradient[settings.theme]![0],
                          value: 4,
                          groupValue: payload['document_status'],
                          onChanged: (v) {
                            setState(() {
                              payload['document_status'] = 4;
                            });
                          },
                        ),
                        Text(
                          'No Conforme',
                          style: TextStyle(
                            color: COLOR.brown_grey_three,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                    (payload['document_status'] == 4
                        ? Container(
                            margin: EdgeInsets.only(bottom: 16.0),
                            height: size.height * 0.075,
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 4,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 16.0),
                                labelText: 'Observaciones',
                                labelStyle: TextStyle(
                                  color: COLOR.brown_grey_four,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 10.6,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: COLOR.brown_grey_five,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: COLOR.brown_grey_five),
                                ),
                              ),
                              onChanged: (String v) => setState(
                                  () => payload['signer_observation'] = v),
                            ),
                          )
                        : Container())
                  ],
                ),
              )
            : Container()),
        Container(
          margin: EdgeInsets.only(bottom: 16.0),
          height: size.height * 0.075,
          child: TextField(
            controller: pinControl,
            maxLines: 1,
            obscureText: !isPasswordVisible,
            inputFormatters: [
              LengthLimitingTextInputFormatter(4),
            ],
            decoration: InputDecoration(
              suffixIcon: InkWell(
                onTap: showPassword,
                child: Icon(
                  isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: COLOR.black_five,
                  size: 20.0,
                ),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              hintText: '****',
              labelText: 'PIN',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: COLOR.black_five),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: COLOR.black_five,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        Container(
          width: size.width * 0.83,
          height: size.height * 0.0875,
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              OutlineButton(
                onPressed: () {
                  Application.router.pop(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                borderSide: BorderSide(
                  color: COLOR.very_light_pink_four,
                ),
                child: Container(
                  height: size.height * 0.070,
                  width: size.width * 0.20,
                  child: Center(
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        color: COLOR.brown_grey_three,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                ),
              ),
              OutlineButton(
                padding: EdgeInsets.all(0.0),
                onPressed: sign,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                borderSide: BorderSide(
                  color: COLOR.very_light_pink_eight,
                ),
                child: Container(
                  height: size.height * 0.070,
                  width: size.width * 0.25,
                  decoration: BoxDecoration(
                    gradient: STYLES.dGradient(theme: settings!.theme),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Firmar',
                      style: TextStyle(
                        color: COLOR.white,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
