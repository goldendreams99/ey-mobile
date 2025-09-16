part of employ.pages;

class BiometricDataStepSix extends StatefulWidget {
  final Map<String, String?> stepSixData;
  final ValueChanged<Map<String, String?>> onChanged;
  final Key key;

  const BiometricDataStepSix({
    required this.stepSixData,
    required this.onChanged,
    this.key = const Key('pin_confirm_page'),
  });

  @override
  BiometricDataStepSixState createState() => BiometricDataStepSixState();
}

class BiometricDataStepSixState extends State<BiometricDataStepSix> {
  late Map<String, String?> stepSixData;
  late TextEditingController controller;
  bool obscureEnable = true;

  @override
  void initState() {
    super.initState();
    stepSixData = widget.stepSixData;
    controller = TextEditingController(
      text: stepSixData['confirm_pin'] ?? '',
    );
    controller.addListener(() {
      change(controller.text);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void change(String value) async {
    stepSixData['confirm_pin'] = value;
    widget.onChanged(stepSixData);
  }

  void visibility() {
    obscureEnable = !obscureEnable;
    setState(() {});
  }

  TextStyle get textStyle => FONT.BOLD.merge(
        TextStyle(color: COLOR.white, fontSize: 21.0),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(top: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Confirmar PIN ',
                    style: FONT.TITLE.merge(
                      TextStyle(color: COLOR.white, fontSize: 18.0),
                    ),
                  ),
                  InkResponse(
                    onTap: visibility,
                    child: Container(
                      padding: EdgeInsets.all(2.0),
                      child: Icon(
                          obscureEnable
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: COLOR.white),
                    ),
                  ),
                ],
              ),
            ),
            PinInputTextField(
              pinLength: 4,
              keyboardType: TextInputType.numberWithOptions(signed: true),
              decoration: BoxLooseDecoration(
                textStyle: textStyle,
                obscureStyle: ObscureStyle(
                  isTextObscure: obscureEnable,
                  obscureText: '•',
                ),
                strokeColorBuilder: PinListenColorBuilder(
                    COLOR.very_light_pink_four, COLOR.white),
              ),
              controller: controller,
              autoFocus: false,
              textInputAction: TextInputAction.done,
              enabled: true,
            )
          ],
        ),
      ),
    );
  }
}
