part of employ.pages;

class IncomeData extends ConsumerStatefulWidget {
  final String? company;
  final String? employee;

  const IncomeData({this.company, this.employee});

  @override
  _IncomeDataState createState() => _IncomeDataState();
}

class _IncomeDataState extends ConsumerState<IncomeData> {
  int index = 0;

  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    data = Map();
  }

  void changeValue(Map<String, dynamic>? info) {
    if (info != null) {
      data?.addAll(info);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(
      appProvider.select((value) => value.settings),
    );
    final bool isKeyboardShown =
        MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: STYLES.vGradient(theme: settings!.theme),
        ),
        child: Container(
          margin: EdgeInsets.only(top: 10),
          child: EmployStepper(
            title: 'Datos de ingreso',
            showActions: isKeyboardShown,
            textColor: COLOR.gradient[settings.theme]![0],
            steps: [
              EmployStep(
                state: data!['frontal'] != null && data!['dorso'] != null
                    ? EmployStepState.complete
                    : EmployStepState.indexed,
                content: IncomeDataStepOne(
                  onChanged: changeValue,
                  stepOneData: <String, String>{
                    'frontal': data?['frontal'],
                    'dorso': data?['dorso']
                  },
                ),
              ),
              EmployStep(
                state: data?['selfie'] != null
                    ? EmployStepState.complete
                    : EmployStepState.indexed,
                content: IncomeDataStepTwo(
                  onChanged: changeValue,
                  stepTwoData: <String, String>{
                    'selfie': data?['selfie'],
                  },
                ),
              ),
              EmployStep(
                state: data?['first_name'] != null &&
                        data?['last_name'] != null &&
                        data?['birthdate'] != null
                    ? EmployStepState.complete
                    : EmployStepState.indexed,
                content: IncomeDataStepThree(
                  onChanged: changeValue,
                  stepThreeData: <String, String>{
                    'first_name': data?['first_name'],
                    'last_name': data?['last_name'],
                    'birthdate': data?['birthdate'],
                  },
                ),
              ),
              EmployStep(
                state: data?['nationality'] != null &&
                        data?['document'] != null &&
                        data?['phone'] != null
                    ? EmployStepState.complete
                    : EmployStepState.indexed,
                content: IncomeDataStepFour(
                  onChanged: changeValue,
                  stepFourData: <String, String>{
                    'nationality': data?['nationality'],
                    'document': data?['document'],
                    'phone': data?['phone'],
                  },
                ),
              ),
              EmployStep(
                content: IncomeDataStepFive(
                  onChanged: changeValue,
                  stepFiveData: <String, String>{
                    'location': data?['location'],
                    'locationDetail': data?['locationDetail'],
                  },
                ),
              ),
              EmployStep(
                content: IncomeDataStepSix(
                  onChanged: changeValue,
                  stepSixData: <String, String>{
                    'relationships': data?['relationship'],
                  },
                ),
              ),
            ],
            currentStep: index,
            onStepTapped: (i) {
              index = i;
              setState(() {});
            },
            onStepCancel: () {
              Application.router.pop(context);
            },
            onStepContinue: () {
              print("You are clicking the continue button.");
            },
          ),
        ),
      ),
    );
  }
}
