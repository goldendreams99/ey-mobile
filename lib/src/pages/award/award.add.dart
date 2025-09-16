part of employ.pages;

class NewAward extends ConsumerStatefulWidget {
  @override
  _NewAwardState createState() => _NewAwardState();
}

class _NewAwardState extends ConsumerState<NewAward> {
  int index = 0;
  dynamic data;
  bool doing = false;

  @override
  void initState() {
    super.initState();
    data = {};
  }

  void uploadAward() async {
    try {
      if (index == (availiableStep.length - 1)) {
        DateTime now = DateTime.now();
        List<String> format = [yyyy, mm];
        String period = formatDate(now, format);
        final db = EmployProvider.of(context).database;
        final manager = ref.read(appProvider);
        String? message;
        if (data['observation'] == null) message = "Ingresá una observación";
        if (data['employee'] == null) message = "Seleccioná un empleado";
        if (data['award'] == null)
          message = "Seleccioná el tipo de reconocimiento";
        if (message != null) {
          Fluttertoast.showToast(
            msg: message,
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_LONG,
          );
          return;
        } else {
          doing = true;
          setState(() {});
          // LoadingDialog.build(context);
          List<Award> sent = [];
          Query query = db.admin
              .ref()
              .child('client/${manager.company!.id}/award')
              .orderByChild('employee_from/id')
              .equalTo(manager.employee!.id);
          DatabaseEvent _data = await query.once();
          dynamic value = Map.from((_data.snapshot.value ?? {}) as dynamic);
          value.keys.toList().forEach(
              (k) => sent.add(Award.fromJson(manager.employee!, value[k])));
          int limitMonthlyTotal = manager.settings!.awardLimitMonthlyTotal -
              sent.where((a) => a.period == period).toList().length;
          int limitMonthlyEmployee =
              manager.settings!.awardLimitMonthlyEmployee -
                  (sent
                      .where((a) {
                        return a.period == period &&
                            a.to.id == data['employee'].id;
                      })
                      .toList()
                      .length);
          if (limitMonthlyTotal == 0) {
            doing = false;
            setState(() {});
            // Application.router.pop(context);
            Fluttertoast.showToast(
              msg: 'Pss.. superaste el limite total del mes!',
              gravity: ToastGravity.BOTTOM,
              toastLength: Toast.LENGTH_LONG,
            );
            return;
          }
          if (limitMonthlyEmployee == 0) {
            Application.router.pop(context);
            Fluttertoast.showToast(
              msg: 'Pss.. superaste el limite para este compañero!',
              gravity: ToastGravity.BOTTOM,
              toastLength: Toast.LENGTH_LONG,
            );
            return;
          }
          AppConfig config = AppConfig.of(context);
          dynamic award = {
            'created': formatDate(now, [yyyy, '-', mm, '-', dd]),
            'year': formatDate(now, [yyyy]),
            'month': formatDate(now, [mm]),
            'period': formatDate(now, [yyyy, mm]),
            'award_type': data['award'],
            'observation': data['observation'],
            'employee_from': manager.employee!.apiData(),
            'employee_to': data['employee'].apiData(),
          };
          String? awardId =
              await db.push('client/${manager.company!.id}/award', award);
          Award _award = Award.fromJson(
            manager.employee!,
            Map.from(award)..addAll({'id': awardId}),
          );
          Award.notify(
            config: config,
            company: manager.company!,
            employee: data['employee'],
          );
          Application.router.pop(context);
          Application.router.navigateTo(
            context,
            Routes.newAwardCreated,
            transitionDuration: Duration(milliseconds: 200),
            transition: fluro.TransitionType.inFromBottom,
            routeSettings: RouteSettings(
              arguments: {'item': _award},
            ),
          );
        }
      }
    } catch (e) {
      doing = false;
      setState(() {});
      BottomSheetDialog.build(
        context,
        ref,
        'Uhh.. error al crear el reconocimiento, intentá nuevamente más tarde',
      );
    }
  }

  void changeValue(Map<dynamic, dynamic> info) {
    data = Map.from(data)..addAll(Map.from(info));
    setState(() {});
  }

  List<EmployStep> get availiableStep {
    return <EmployStep>[
      EmployStep(
        state: data['award'] != null
            ? EmployStepState.complete
            : EmployStepState.indexed,
        content: AwardStepOne(
          onChanged: changeValue,
          stepOneData: <String, dynamic>{
            'award': data['award'],
          },
        ),
      ),
      EmployStep(
        state: data['employee'] != null
            ? EmployStepState.complete
            : EmployStepState.indexed,
        content: AwardStepTwo(
          onChanged: changeValue,
          stepTwoData: <String, dynamic>{
            'employee': data['employee'],
          },
        ),
      ),
      EmployStep(
        state: data['observation'] != null
            ? EmployStepState.complete
            : EmployStepState.indexed,
        content: AwardStepThree(
          onChanged: changeValue,
          stepThreeData: <String, dynamic>{
            'observation': data['observation'],
          },
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardShown =
        MediaQuery.of(context).viewInsets.bottom == 0.0;
    final size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
          body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: STYLES.vGradient(
                colors: [
                  Color.fromRGBO(78, 12, 195, 1.0),
                  Color.fromRGBO(161, 67, 198, 1.0),
                ],
              ),
            ),
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: EmployStepper(
                textColor: Color.fromRGBO(78, 12, 195, 1.0),
                title: 'Enviar',
                spacing: 10.0,
                showActions: isKeyboardShown,
                steps: availiableStep,
                currentStep: index,
                swipeable: false,
                onStepTapped: (i) {
                  index = i;
                  setState(() {});
                },
                onStepCancel: () {
                  Application.router.pop(context);
                },
                onStepContinue: uploadAward,
              ),
            ),
          ),
          Container(
            decoration: doing
                ? BoxDecoration(
                    gradient: STYLES.vGradient(
                      colors: [
                        Color.fromRGBO(78, 12, 195, 1.0),
                        Color.fromRGBO(161, 67, 198, 1.0),
                      ],
                    ),
                  )
                : null,
            child: doing ? renderDotLoading(size) : null,
          ),
        ],
      )),
    );
  }
}
