part of employ.pages;

class SignConfigPage extends StatefulWidget {
  final bool? agreed;
  final String? observation;
  final Function(String, dynamic)? onChanged;

  const SignConfigPage({this.agreed, this.observation, this.onChanged});

  @override
  _SignConfigPageState createState() => _SignConfigPageState();
}

class _SignConfigPageState extends State<SignConfigPage> {
  bool agreed = true;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    agreed = !(widget.agreed ?? true);
    controller = TextEditingController(text: widget.observation ?? '');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  TextStyle get hintStyle => FONT.REGULAR.merge(
        TextStyle(color: COLOR.white.withOpacity(0.5), fontSize: 20.0),
      );

  TextStyle get labelStyle => FONT.SEMIBOLD.merge(
        TextStyle(
          color: COLOR.very_light_pink_five,
          fontSize: 11.0,
        ),
      );

  TextStyle get textStyle => FONT.BOLD.merge(
        TextStyle(color: COLOR.white, fontSize: 21.0),
      );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.fromLTRB(22.0, 0.0, 12.0, 0.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              height: calcSize(size, 116.0),
              width: size.width,
              padding: EdgeInsets.only(bottom: 16.0),
              margin: EdgeInsets.only(bottom: 8.0),
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(bottom: 3.0),
                width: calcSize(size, 274.0),
                child: Text(
                  'Avanzado',
                  style: FONT.TITLE.merge(
                    TextStyle(fontSize: 34.0, color: COLOR.white),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: COLOR.black.withOpacity(0.13),
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 11.35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Conforme",
                    style: FONT.TITLE.merge(
                      TextStyle(color: COLOR.white, fontSize: 22.0),
                    ),
                  ),
                  Switch(
                      value: agreed,
                      inactiveThumbColor: COLOR.white,
                      activeColor: COLOR.white,
                      activeTrackColor: Color.fromRGBO(63, 192, 59, 1.0),
                      onChanged: (v) {
                        if (widget.onChanged != null) {
                          widget.onChanged!('document_status', v ? 3 : 4);
                        }
                        agreed = !agreed;
                        setState(() {});
                      }),
                ],
              ),
            ),
            !agreed
                ? Container(
                    margin: EdgeInsets.only(top: 22.0),
                    decoration: BoxDecoration(
                      color: COLOR.black.withOpacity(0.13),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 0.0, vertical: 11.35),
                    child: TextField(
                      controller: controller,
                      style: FONT.TITLE.merge(
                        TextStyle(color: COLOR.white, fontSize: 22.0),
                      ),
                      maxLength: 140,
                      maxLines: 4,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(140),
                      ],
                      textInputAction: TextInputAction.done,
                      onChanged: (text) {
                        if (widget.onChanged != null) {
                          widget.onChanged!('signer_observation', text);
                        }
                      },
                      decoration: InputDecoration(
                        hintStyle: FONT.TITLE.merge(
                          TextStyle(
                            fontSize: 22.0,
                            color: COLOR.white.withOpacity(0.4),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 18.0,
                        ),
                        hintText: 'Observaciones',
                        border: InputBorder.none,
                        counterText: "",
                      ),
                    ),
                  )
                // Container(
                //     height: 30.0,
                //     margin: EdgeInsets.symmetric(vertical: 13.0),
                //     alignment: Alignment.centerLeft,
                //     child: Text(
                //       "Observaciones",
                //       style: FONT.TITLE.merge(
                //         TextStyle(color: COLOR.white, fontSize: 18.0),
                //       ),
                //     ),
                //   )
                : Container(),
            // !agreed
            //     ? TextField(
            //         textInputAction: TextInputAction.done,
            //         style: textStyle,
            //         maxLines: 4,
            //         controller: controller,
            //         onChanged: (text) {
            //           widget.onChanged('signer_observation', text);
            //         },
            //         decoration: InputDecoration(
            //           contentPadding: EdgeInsets.symmetric(
            //             vertical: 15,
            //             horizontal: 12.0,
            //           ),
            //           hintText: 'Algo paso',
            //           hintStyle: hintStyle,
            //           enabledBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(14.0),
            //             borderSide: BorderSide(color: COLOR.white, width: 2.0),
            //           ),
            //           focusedBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(14.0),
            //             borderSide: BorderSide(
            //               color: COLOR.white,
            //               width: 2.0,
            //             ),
            //           ),
            //         ),
            //       )
            //     : Container(),
          ],
        ),
      ),
    );
  }
}
