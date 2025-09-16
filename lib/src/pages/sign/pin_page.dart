part of employ.pages;

class SignPinPage extends ConsumerStatefulWidget {
  final TabController? controller;
  final ValueChanged<String>? process;
  final bool onlyAgree;
  final bool canResetPin;
  final bool hasOptions;
  final Function? onReset;

  const SignPinPage({
    this.controller,
    this.process,
    this.onReset,
    this.onlyAgree = false,
    this.canResetPin = false,
    this.hasOptions = false,
  });

  @override
  _SignPinPageState createState() => _SignPinPageState();
}

class _SignPinPageState extends ConsumerState<SignPinPage> {
  late TextEditingController pinController;
  bool password = true;

  TextStyle get textStyle => FONT.BOLD.merge(
        TextStyle(color: COLOR.white, fontSize: 21.0),
      );

  @override
  void initState() {
    super.initState();
    pinController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    return Container(
      padding: EdgeInsets.fromLTRB(22.0, 0, 12.0, 0.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              height: calcSize(size, 116.0),
              width: size.width,
              padding: EdgeInsets.fromLTRB(0.0, 0, 0.0, 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 3.0),
                    width: calcSize(size, 274.0),
                    child: Text(
                      '¿Firmamos?',
                      style: FONT.TITLE.merge(
                        TextStyle(fontSize: 34.0, color: COLOR.white),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  widget.onlyAgree || !widget.hasOptions
                      ? Container()
                      : IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(EmployIcons.chevron_right),
                          onPressed: () => widget.controller?.animateTo(1),
                          color: COLOR.white,
                        )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: COLOR.black.withOpacity(0.13),
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 14.0),
                    padding: EdgeInsets.symmetric(horizontal: 22.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Ingresa tu PIN ',
                          style: FONT.TITLE.merge(
                            TextStyle(color: COLOR.white, fontSize: 18.0),
                          ),
                        ),
                        InkResponse(
                          onTap: () {
                            password = !password;
                            setState(() {});
                          },
                          child: Icon(
                              !password
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: COLOR.white),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 22.0),
                    child: PinInputTextField(
                      pinLength: 4,
                      keyboardType: TextInputType.numberWithOptions(signed: true),
                      // inputFormatter: <TextInputFormatter>[],
                      decoration: BoxLooseDecoration(
                        textStyle: textStyle,
                        // enteredColor: COLOR.very_light_pink_four,
                        // solidColor: null,
                        // strokeColor: COLOR.white,
                        obscureStyle: ObscureStyle(
                          isTextObscure: password,
                          obscureText: '•',
                        ),
                        strokeColorBuilder: PinListenColorBuilder(
                            COLOR.very_light_pink_four, COLOR.white),
                      ),
                      controller: pinController,
                      autoFocus: false,
                      textInputAction: TextInputAction.done,
                      enabled: true,
                      onChanged: widget.process,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: widget.canResetPin
                        ? FlatButton(
                            onPressed: () {
                              // widget.controller.animateTo(2);
                              BottomSheetDialog.build(
                                context,
                                ref,
                                '',
                                textWidget: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text:
                                        'Reestableceremos tu PIN, ¿Estás seguro? ',
                                    style: FONT.TITLE.merge(
                                      TextStyle(
                                        color: COLOR.white,
                                        fontSize: 26.3,
                                      ),
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            '\n\nDeberás iniciar sesión nuevamente para que confirmemos tu identidad',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                height: calcSize(
                                  size,
                                  (padding.bottom + 290.0),
                                ),
                                onAccept: () {
                                  Application.router.pop(context);
                                  widget.onReset?.call();
                                },
                              );
                            },
                            child: Text(
                              "Olvidé mi PIN",
                              style: FONT.SEMIBOLD.merge(
                                TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
