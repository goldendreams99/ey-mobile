part of employ.pages;

class BiometricDataStepFive extends StatefulWidget {
  final Map<String, String?> stepFiveData;
  final ValueChanged<Map<String, String?>> onChanged;
  final Key key;

  const BiometricDataStepFive({
    required this.stepFiveData,
    required this.onChanged,
    this.key = const Key('pin_page'),
  });

  @override
  BiometricDataStepFiveState createState() => BiometricDataStepFiveState();
}

class BiometricDataStepFiveState extends State<BiometricDataStepFive> {
  late Map<String, String?> stepFiveData;
  late TextEditingController pinController;
  late TextEditingController confirmPinController;
  bool obscureEnable = true;
  bool showConfirmField = false;

  @override
  void initState() {
    super.initState();
    stepFiveData = widget.stepFiveData;
    pinController = TextEditingController(
      text: stepFiveData['pin'] ?? '',
    );
    confirmPinController = TextEditingController(
      text: stepFiveData['confirm_pin'] ?? '',
    );
    
    pinController.addListener(() {
      changePinValue(pinController.text);
    });
    
    confirmPinController.addListener(() {
      changeConfirmPinValue(confirmPinController.text);
    });
    
    // Show confirm field if PIN is already complete
    if ((stepFiveData['pin'] ?? '').length == 4) {
      showConfirmField = true;
    }
  }

  @override
  void dispose() {
    pinController.dispose();
    confirmPinController.dispose();
    super.dispose();
  }

  void changePinValue(String value) async {
    stepFiveData['pin'] = value;
    
    // Show confirm field when PIN is complete (4 digits)
    if (value.length == 4 && !showConfirmField) {
      setState(() {
        showConfirmField = true;
      });
      // Auto-focus confirm field after a small delay
      Future.delayed(Duration(milliseconds: 100), () {
        if (mounted) {
          FocusScope.of(context).nextFocus();
        }
      });
    } else if (value.length < 4 && showConfirmField) {
      setState(() {
        showConfirmField = false;
        stepFiveData['confirm_pin'] = '';
        confirmPinController.clear();
      });
    }
    
    widget.onChanged(stepFiveData);
  }

  void changeConfirmPinValue(String value) async {
    stepFiveData['confirm_pin'] = value;
    widget.onChanged(stepFiveData);
  }

  void visibility() {
    obscureEnable = !obscureEnable;
    setState(() {});
  }

  TextStyle get textStyle => FONT.BOLD.merge(TextStyle(
        color: COLOR.white,
        fontSize: 21.0,
      ));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20.0, bottom: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'PIN Seguridad',
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
              decoration: BoxLooseDecoration(
                textStyle: textStyle,
                obscureStyle: ObscureStyle(
                  isTextObscure: obscureEnable,
                  obscureText: '•',
                ),
                strokeColorBuilder: PinListenColorBuilder(
                  COLOR.very_light_pink_four,
                  COLOR.white,
                ),
              ),
              keyboardType: TextInputType.numberWithOptions(signed: true),
              controller: pinController,
              autoFocus: false,
              textInputAction: showConfirmField ? TextInputAction.next : TextInputAction.done,
              enabled: true,
            ),
            
            // Confirm PIN field - shows when PIN is complete
            if (showConfirmField) ...[
              SizedBox(height: 20.0),
              Container(
                margin: EdgeInsets.only(bottom: 14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Confirmar PIN',
                      style: FONT.TITLE.merge(
                        TextStyle(color: COLOR.white, fontSize: 18.0),
                      ),
                    ),
                    // Show validation icon with reserved space
                    SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: confirmPinController.text.length == 4
                          ? Icon(
                              stepFiveData['pin'] == stepFiveData['confirm_pin']
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: stepFiveData['pin'] == stepFiveData['confirm_pin']
                                  ? COLOR.turtle_green
                                  : COLOR.pink_red,
                              size: 24.0,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
              PinInputTextField(
                pinLength: 4,
                decoration: BoxLooseDecoration(
                  textStyle: textStyle,
                  obscureStyle: ObscureStyle(
                    isTextObscure: obscureEnable,
                    obscureText: '•',
                  ),
                  strokeColorBuilder: PinListenColorBuilder(
                    COLOR.very_light_pink_four,
                    // Change color based on match
                    stepFiveData['pin'] == stepFiveData['confirm_pin'] && confirmPinController.text.length == 4
                        ? COLOR.turtle_green
                        : confirmPinController.text.length == 4 && stepFiveData['pin'] != stepFiveData['confirm_pin']
                            ? COLOR.pink_red
                            : COLOR.white,
                  ),
                ),
                keyboardType: TextInputType.numberWithOptions(signed: true),
                controller: confirmPinController,
                autoFocus: false,
                textInputAction: TextInputAction.done,
                enabled: true,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
