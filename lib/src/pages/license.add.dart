part of employ.pages;

class LicenseAdd extends ConsumerStatefulWidget {
  @override
  _LicenseAddState createState() => _LicenseAddState();
}

class _LicenseAddState extends ConsumerState<LicenseAdd>
    with SingleTickerProviderStateMixin {
  dynamic data;
  List<dynamic> uploadbleAttachments = [];
  int index = 0;
  bool doing = false;

  @override
  void initState() {
    super.initState();
    data = {'attachments': []};
  }

  @override
  Widget build(BuildContext context) {
    final manager = ref.watch(appProvider);
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
                gradient: STYLES.vGradient(theme: manager.settings!.theme),
              ),
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: EmployStepper(
                  title: 'Nueva Licencia',
                  swipeable: false,
                  showActions: isKeyboardShown,
                  textColor: COLOR.gradient[manager.settings!.theme]![1],
                  steps: availiableSteps,
                  currentStep: index,
                  onStepTapped: (i) {
                    index = i;
                    setState(() {});
                  },
                  onStepCancel: () {
                    Application.router.pop(context);
                  },
                  onStepContinue: uploadLicense,
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
            )
          ],
        ),
      ),
    );
  }

  void close() async {
    Application.router.pop(context);
  }

  void create() async {
    final manager = ref.read(appProvider);
    final settings = manager.settings;
    final company = manager.company;
    final employee = manager.employee;
    final config = AppConfig.of(context);
    final db = EmployProvider.of(context).database;
    try {
      setState(() {
        doing = true;
      });
      // LoadingDialog.build(context);
      dynamic license = {
        'type': data['type'],
        'created': formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]),
        'created_by': '(Portal) - ${employee!.name}',
        'date_from': formatDate(data['from'], [yyyy, '-', mm, '-', dd]),
        'date_to': formatDate(data['to'], [yyyy, '-', mm, '-', dd]),
        'observation': data['observation'].isEmpty ? null : data['observation'],
        'status': data['type']['sign'] != null && data['type']['sign']
            ? 0
            : settings!.licenseAuthApprover
                ? 1
                : 2,
        'employee': employee.apiExpenseData()
      };
      dynamic response = await License.register(config, company!, license);
      if (data['attachments'].length > 0) {
        addAtachments(response, license, data['attachments']);
      } else {
        doing = false;
        setState(() {});
        if (license['type']['sign'] != null && license['type']['sign']) {
          proccessSignature(db, company, response.toString());
        } else {
          Application.router.pop(context);
        }
      }
    } catch (e) {
      setState(() {
        doing = false;
      });
      BottomSheetDialog.build(
        context,
        ref,
        'Uhh.. error al crear la licencia, intentá nuevamente más tarde',
      );
    }
  }

  void proccessSignature(Database db, Company company, String licenseId) async {
    String _ref = 'client/${company.id}/license/$licenseId';
    dynamic document = await db.once(_ref);
    final item = License.fromJson(document);
    Application.router.pop(context);
    String route = Routes.license
        .replaceAll(':companyId', company.id)
        .replaceAll(':name', item.name)
        .replaceAll(':id', item.id)
        .replaceAll(':recent', 'true');
    Application.router.navigateTo(context, route);
  }

  void addAtachments(String license, dynamic data, List<dynamic> attachments) {
    final manage = ref.read(appProvider);
    final storage = EmployProvider.of(context).storage;
    String path = 'client/${manage.company!.id}/employee/license_attach';
    List.from(attachments).forEach((file) {
      String id = '${Uuid().v1()}.jpg';
      String name = file.substring(file.lastIndexOf('/') + 1);
      bool isDocument = file.toLowerCase().endsWith('.pdf');
      storage?.upload(
        file,
        '$path/$id',
        (url) => loadAtta(
          data,
          license,
          url,
          name,
          id,
          attachments.length,
          manage,
          isDoc: isDocument,
        ),
      );
    });
  }

  void loadAtta(
    dynamic data,
    String license,
    String url,
    String name,
    String id,
    int size,
    AppState state, {
    bool isDoc = false,
  }) async {
    uploadbleAttachments.add({
      'url': url,
      'name': name,
      'type': isDoc ? 'application/pdf' : 'image/jpg',
      'id': id,
    });
    if (uploadbleAttachments.length == size) {
      final company = state.company;
      final db = EmployProvider.of(context).database;
      String ref = 'client/${company!.id}/license/$license';
      await db.update(ref, {
        'attachments': uploadbleAttachments,
        'id': license,
      });
      doing = false;
      setState(() {});
      // Application.router.pop(context);
      if (data['type']['sign'] != null && data['type']['sign']) {
        proccessSignature(db, company, license);
      } else {
        Application.router.pop(context);
      }
    }
  }

  void changeValue(Map<dynamic, dynamic> info) {
    data = Map.from(data)..addAll(Map.from(info));
    setState(() {});
  }

  List<EmployStep> get availiableSteps {
    List<EmployStep> list = [];
    list.add(EmployStep(
      state: data['from'] != null && data['to'] != null && data['type'] != null
          ? EmployStepState.complete
          : EmployStepState.indexed,
      content: LicenseAddStepOne(
        onChanged: changeValue,
        stepOneData: <String, dynamic>{
          'from': data['from'],
          'to': data['to'],
          'type': data['type'],
        },
      ),
    ));
    list.add(EmployStep(
      state:
          data['observation'] != null && data['observation'].trim().isNotEmpty
              ? EmployStepState.complete
              : EmployStepState.indexed,
      content: LicenseAddStepTwo(
        onChanged: changeValue,
        stepTwoData: <String, dynamic>{
          'observation': data['observation'],
          'attachments': data['attachments'],
        },
      ),
    ));
    return list;
  }

  void uploadLicense() {
    EmployStep? step;
    try {
      step =
          availiableSteps.firstWhere((s) => s.state == EmployStepState.indexed);
    } catch (e) {
      step = null;
    }
    if (step != null && index == availiableSteps.length - 1) {
      String message = 'error';
      if (data['observation'] == null || data['observation'].trim().isEmpty)
        message = "Completá la observación";
      if (data['from'] == null || data['to'] == null)
        message = "Seleccioná las fechas";
      if (data['type'] == null) message = "Seleccioná el tipo de licencia";
      Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
      );
    } else if (step == null) {
      create();
    }
  }
}
