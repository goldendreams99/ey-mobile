part of employ.pages;

class PKIData extends ConsumerStatefulWidget {
  @override
  _PKIDataState createState() => _PKIDataState();
}

class _PKIDataState extends ConsumerState<PKIData>
    with SingleTickerProviderStateMixin {
  late TextEditingController pinController;
  late TextEditingController pinCController;
  bool valid = false;
  bool loading = false;
  bool obscureEnable = true;
  int index = 0;
  bool doing = false;

  @override
  void initState() {
    super.initState();
    pinController = TextEditingController();
    pinCController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardShown =
        MediaQuery.of(context).viewInsets.bottom == 0.0;
    final manager = ref.watch(appProvider);
    final size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: STYLES.vGradient(theme: manager.settings!.theme),
              ),
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: EmployStepper(
                  title: 'Firma Electrónica',
                  showActions: isKeyboardShown,
                  textColor: COLOR.gradient[manager.settings!.theme]![0],
                  steps: availiableSteps,
                  currentStep: index,
                  onStepTapped: (i) {
                    index = i;
                    setState(() {});
                  },
                  onStepCancel: () {
                    Application.router.pop(context);
                  },
                  onStepContinue: uploadFiles,
                ),
              ),
            ),
            Container(
              decoration: doing
                  ? BoxDecoration(
                      gradient:
                          STYLES.vGradient(theme: manager.settings!.theme),
                    )
                  : null,
              child: doing ? renderDotLoading(size) : null,
            ),
          ],
        ),
      ),
    );
  }

  void visibility() {
    obscureEnable = !obscureEnable;
    setState(() {});
  }

  TextStyle get textStyle => FONT.BOLD.merge(
        TextStyle(color: COLOR.white, fontSize: 21.0),
      );

  void loadCertificate() {
    final manager = ref.read(appProvider);
    final config = AppConfig.of(context);
    doing = true;
    if (mounted) setState(() {});
    ref
        .read(appProvider.notifier)
        .electronicPin(
          config,
          pinController.text,
          manager.company!,
          manager.employee!,
        )
        .then((e) {
      Application.router.pop(context);
      Application.router.pop(context);
    });
  }

  List<EmployStep> get availiableSteps {
    List<EmployStep> list = [];
    list.add(
      EmployStep(
        state: pinController.text.isNotEmpty && pinController.text.length == 4
            ? EmployStepState.complete
            : EmployStepState.indexed,
        content: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              margin: EdgeInsets.only(bottom: 14.0, left: 16.0, right: 16.0),
              decoration: BoxDecoration(
                color: COLOR.black.withOpacity(0.13),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: SingleChildScrollView(
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
                            'PIN Seguridad',
                            style: FONT.TITLE.merge(
                              TextStyle(color: COLOR.white, fontSize: 18.0),
                            ),
                          ),
                          InkResponse(
                            onTap: visibility,
                            child: Icon(
                              obscureEnable
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: COLOR.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    PinInputTextField(
                      pinLength: 4,
                      // inputFormatter: <TextInputFormatter>[],
                      decoration: BoxLooseDecoration(
                        textStyle: textStyle,
                        // enteredColor: COLOR.very_light_pink_four,
                        // solidColor: null,
                        // strokeColor: COLOR.white,
                        obscureStyle: ObscureStyle(
                          isTextObscure: obscureEnable,
                          obscureText: '•',
                        ),
                        strokeColorBuilder: PinListenColorBuilder(
                            COLOR.very_light_pink_four, COLOR.white),
                      ),
                      keyboardType: TextInputType.numberWithOptions(signed: true),
                      controller: pinController,
                      autoFocus: false,
                      textInputAction: TextInputAction.next,
                      enabled: true,
                      onSubmit: (e) {
                        setState(() => index++);
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
    list.add(
      EmployStep(
        state: pinController.text == pinCController.text
            ? EmployStepState.complete
            : EmployStepState.indexed,
        content: Container(
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
                        'Confirmar PIN',
                        style: FONT.TITLE.merge(
                          TextStyle(color: COLOR.white, fontSize: 18.0),
                        ),
                      ),
                      InkResponse(
                        onTap: visibility,
                        child: Icon(
                            obscureEnable
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: COLOR.white),
                      )
                    ],
                  ),
                ),
                PinInputTextField(
                  pinLength: 4,
                  // inputFormatter: <TextInputFormatter>[],
                  decoration: BoxLooseDecoration(
                    textStyle: textStyle,
                    obscureStyle: ObscureStyle(
                      isTextObscure: obscureEnable,
                      obscureText: '•',
                    ),
                    strokeColorBuilder: PinListenColorBuilder(
                        COLOR.very_light_pink_four, COLOR.white),
                  ),
                  keyboardType: TextInputType.numberWithOptions(signed: true),
                  controller: pinCController,
                  autoFocus: false,
                  textInputAction: TextInputAction.done,
                  enabled: true,
                  onSubmit: (e) {
                    if (e.isNotEmpty &&
                        e.length == 4 &&
                        e != pinController.text) {
                      Vibration.vibrate(duration: 200);
                      pinCController.clear();
                      pinController.clear();
                      index = 0;
                      setState(() {});
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
    return list;
  }

  void uploadFiles() {
    EmployStep? step;
    try {
      step =
          availiableSteps.firstWhere((s) => s.state == EmployStepState.indexed);
    } catch (e) {
      step = null;
    }

    if (step != null && index == availiableSteps.length - 1) {
      print('holaaa problemas');
    } else if (step == null) {
      loadCertificate();
    }
  }
}
