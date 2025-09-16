part of employ.pages;

class BiometricData extends ConsumerStatefulWidget {
  @override
  _BiometricDataState createState() => _BiometricDataState();
}

class _BiometricDataState extends ConsumerState<BiometricData> {
  int index = 0;
  Map<String, dynamic> data = Map();

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardShown =
        MediaQuery.of(context).viewInsets.bottom == 0.0;
    final settings = ref.watch(
      appProvider.select((value) => value.settings),
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: STYLES.vGradient(theme: settings!.theme),
          ),
          child: Container(
            margin: EdgeInsets.only(top: 10),
            child: EmployStepper(
              title: 'Datos Biométricos',
              showActions: isKeyboardShown,
              textColor: COLOR.gradient[settings.theme]![1],
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
      ),
    );
  }

  void changeValue(Map<String, dynamic> info) {
    data.addAll(info);
    setState(() {});
  }

  void uploadFiles() {
    EmployStep? step;
    try {
      step = availiableSteps.firstWhere(
        (s) => s.state == EmployStepState.indexed,
      );
    } catch (e) {
      step = null;
    }

    if (step != null && index == availiableSteps.length - 1) {
      String key = step.content.key.toString();
      String message = 'error';
      if (key == "[<'frontal_page'>]")
        message = "Completá el frente del documento";
      if (key == "[<'dorso_page'>]")
        message = "Completá el dorso del documento";
      if (key == "[<'selfie_page'>]") message = "Completá la selfie";
      if (key == "[<'signature_page'>]") message = "Completá la firma";
      if (key == "[<'pin_page'>]") message = "Completá el pin";
      if (key == "[<'pin_confirm_page'>]") message = "Los pines no coinciden";
      Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
      );
    } else if (step == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BiometricDataUpload(
            steps: Map<String, String>.from(data),
          ),
        ),
      );
    }
  }

  List<EmployStep> get availiableSteps {
    final manager = ref.read(appProvider);
    List<EmployStep> list = [];
    if (manager.settings!.signBioDocument) {
      list.add(EmployStep(
        state: data['frontal'] != null
            ? EmployStepState.complete
            : EmployStepState.indexed,
        content: BiometricDataStepOne(
          onChanged: changeValue,
          stepOneData: <String, String?>{'frontal': data['frontal']},
        ),
      ));
      list.add(EmployStep(
        state: data['dorso'] != null
            ? EmployStepState.complete
            : EmployStepState.indexed,
        content: BiometricDataStepTwo(
          onChanged: changeValue,
          stepTwoData: <String, String?>{'dorso': data['dorso']},
        ),
      ));
    }
    if (manager.settings!.signBioSelfie) {
      list.add(EmployStep(
        state: data['selfie'] != null
            ? EmployStepState.complete
            : EmployStepState.indexed,
        content: BiometricDataStepThree(
          onChanged: changeValue,
          stepThreeData: <String, String?>{'selfie': data['selfie']},
        ),
      ));
    }
    list.add(EmployStep(
      state: data['signature_image'] != null
          ? EmployStepState.complete
          : EmployStepState.indexed,
      content: BiometricDataStepFour(
        onChanged: changeValue,
        stepFourData: <String, String?>{
          'signature_image': data['signature_image'],
          'signature_metadata': data['signature_metadata'],
        },
      ),
    ));
    list.add(EmployStep(
      state: data['pin'] != null && data['pin'].length == 4 && 
             data['confirm_pin'] != null && data['confirm_pin'].length == 4 &&
             data['pin'] == data['confirm_pin']
          ? EmployStepState.complete
          : EmployStepState.indexed,
      content: BiometricDataStepFive(
        onChanged: changeValue,
        stepFiveData: <String, String?>{
          'pin': data['pin'],
          'confirm_pin': data['confirm_pin'],
        },
      ),
    ));
    return list;
  }
}
