part of employ.pages;

class LicenseAddStepOne extends ConsumerStatefulWidget {
  final dynamic stepOneData;
  final ValueChanged<Map<dynamic, dynamic>> onChanged;

  const LicenseAddStepOne({
    this.stepOneData,
    required this.onChanged,
  });

  @override
  LicenseAddStepOneState createState() => LicenseAddStepOneState();
}

class LicenseAddStepOneState extends ConsumerState<LicenseAddStepOne> {
  dynamic stepOneData;
  List<String> format = [dd, ' ', ' ', yyyy];
  List<dynamic> options = [];
  bool finding = false;

  @override
  void initState() {
    stepOneData = widget.stepOneData ?? {};
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final company = ref.read(appProvider).company;
      if (mounted && options.isEmpty && !finding) {
        finding = true;
        final provider = EmployProvider.of(context);
        String ref = 'client/${company!.id}/setting/license_type';
        provider.database.once(ref).then((values) {
          if (values != null) values.forEach((k, v) => options.add(v));
          options.sort((a, b) => a['name'].compareTo(b['name']));
          if (mounted) setState(() {});
        });
      }
    });
  }

  void onSelectLicenseType() {
    Navigator.push(
      context,
      SlideRightRoute(
        widget: EmploySelect<dynamic>(
          title: 'Tipo de Licencia',
          options: options,
          selected: stepOneData['type'],
          render: (option) => option['name'],
        ),
      ),
    ).then((_val) {
      if (_val != null) {
        dynamic value = Map.from(stepOneData);
        value['type'] = Map.from(_val);
        stepOneData = Map.from(value);
        widget.onChanged(stepOneData);
      }
    });
  }

  void openCalendar() {
    final calendarNotifier = ref.read(calendarProvider.notifier);
    calendarNotifier.setPeriod(true);
    if (stepOneData['from'] != null) {
      calendarNotifier.setFrom(stepOneData['from']);
      calendarNotifier.setTo(stepOneData['to']);
    }
    Navigator.push(
      context,
      SlideRightRoute(
        widget: LicenseCalendar((data) {
          dynamic value = Map.from(stepOneData);
          value['from'] = data[0];
          value['to'] = data[1];
          stepOneData = Map.from(value);
          widget.onChanged(stepOneData);
        }),
      ),
    );
  }

  TextStyle getTextStyle(dynamic field) {
    return TextStyle(
      color: COLOR.white.withOpacity(field == null ? 0.4 : 1.0),
      fontSize: 19.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 26.0),
            child: InkResponse(
              onTap: onSelectLicenseType,
              child: Container(
                decoration: BoxDecoration(
                  color: COLOR.black.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: size.width - 68.0,
                      padding: EdgeInsets.only(left: 15.0),
                      child: Text(
                        stepOneData['type'] == null
                            ? "Tipo de Licencia"
                            : stepOneData['type']['name'],
                        style: FONT.TITLE.merge(
                          TextStyle(
                            color: COLOR.white.withOpacity(stepOneData['type'] == null ? 0.4 : 1.0),
                            fontSize: 22.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 15.0),
                      decoration: BoxDecoration(
                        color: COLOR.black.withOpacity(0.13),
                        borderRadius: BorderRadius.only(
                          bottomRight: const Radius.circular(5.0),
                          topRight: const Radius.circular(5.0),
                        ),
                      ),
                      child: Icon(
                        EmployIcons.chevron_right,
                        color: COLOR.white.withOpacity(
                          stepOneData['type'] == null ? 0.4 : 1.0,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          InkResponse(
            onTap: openCalendar,
            child: Container(
              decoration: BoxDecoration(
                color: COLOR.black.withOpacity(0.13),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Icon(
                      Icons.calendar_today,
                      color: COLOR.white.withOpacity(
                        stepOneData['from'] == null ? 0.4 : 1.0,
                      ),
                      size: 27.0,
                    ),
                  ),
                  Container(
                    width: size.width * 0.62,
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        text: stepOneData['from'] != null
                            ? formatDate(
                                stepOneData['from'],
                                List.from(format)
                                  ..insert(
                                    2,
                                    months[stepOneData['from'].month - 1]
                                        .substring(0, 3),
                                  ),
                              )
                            : 'Desde',
                        style: FONT.TITLE.merge(
                          getTextStyle(stepOneData['from']),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: stepOneData['from'] != null ? ' - ' : '/',
                          ),
                          TextSpan(
                              text: stepOneData['to'] != null
                                  ? formatDate(
                                      stepOneData['to'],
                                      List.from(format)
                                        ..insert(
                                          2,
                                          months[stepOneData['to'].month - 1]
                                              .substring(0, 3),
                                        ),
                                    )
                                  : 'Hasta'),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
                    decoration: BoxDecoration(
                      color: COLOR.black.withOpacity(0.13),
                      borderRadius: BorderRadius.only(
                        bottomRight: const Radius.circular(5.0),
                        topRight: const Radius.circular(5.0),
                      ),
                    ),
                    child: Icon(
                      EmployIcons.chevron_right,
                      color: COLOR.white.withOpacity(
                        stepOneData['from'] == null ? 0.4 : 1.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
