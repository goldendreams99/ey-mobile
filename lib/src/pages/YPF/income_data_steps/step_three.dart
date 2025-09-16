part of employ.pages;

class IncomeDataStepThree extends StatefulWidget {
  final Map<String, String>? stepThreeData;
  final ValueChanged<Map<String, String>> onChanged;

  const IncomeDataStepThree({this.stepThreeData, required this.onChanged});

  @override
  IncomeDataStepThreeState createState() => IncomeDataStepThreeState();
}

class IncomeDataStepThreeState extends State<IncomeDataStepThree> {
  late Map<String, String> stepThreeData;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;

  @override
  void initState() {
    super.initState();
    stepThreeData = widget.stepThreeData ?? Map();
    firstNameController =
        TextEditingController(text: stepThreeData['first_name'] ?? '');
    lastNameController =
        TextEditingController(text: stepThreeData['last_name'] ?? '');
  }

  void change(String target, dynamic value) async {
    stepThreeData[target] = value;
    widget.onChanged(stepThreeData);
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

  Future<void> choiceDate() async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      initialDatePickerMode: DatePickerMode.day,
      locale: ui.Locale('es'),
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null) change('birthdate', picked.toUtc().toString());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            UnderlineTextField(
              height: calcSize(size, 51.0),
              controller: firstNameController,
              margin: EdgeInsets.symmetric(vertical: 20.0),
              label: 'Nombre',
              hint: 'Sebastian',
              color: COLOR.white,
              type: TextInputType.text,
              insidePadding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 9.0),
              suffixIcon: EmployIcons.edit,
              style: textStyle,
              hintStyle: hintStyle,
              labelStyle: labelStyle,
              onChange: (text) => change('first_name', text),
            ),
            UnderlineTextField(
              height: calcSize(size, 51.0),
              controller: lastNameController,
              margin: EdgeInsets.symmetric(vertical: 20.0),
              label: 'Apellido',
              hint: 'Germino',
              color: COLOR.white,
              type: TextInputType.text,
              insidePadding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 9.0),
              suffixIcon: EmployIcons.edit,
              style: textStyle,
              hintStyle: hintStyle,
              labelStyle: labelStyle,
              onChange: (text) => change('last_name', text),
            ),
            InkResponse(
              onTap: choiceDate,
              child: Container(
                margin: EdgeInsets.only(top: 20.0),
                width: size.width,
                height: 44.6,
                padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: COLOR.white, width: 2.0),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10.8),
                      child: Icon(Icons.calendar_today, color: COLOR.white),
                    ),
                    Container(
                      width: size.width * 0.28,
                      child: Text(
                        "Nacimiento",
                        style: FONT.TITLE.merge(
                          TextStyle(color: COLOR.white, fontSize: 18.0),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 13.0, right: 8.5),
                      width: calcSize(size, 116),
                      child: Text(
                        stepThreeData['birthdate'] != null
                            ? formatDate(
                            DateTime.tryParse(
                                        stepThreeData['birthdate']!) ??
                                    DateTime.now(),
                                [dd, '/', mm, '/', yyyy])
                            : '',
                        maxLines: 1,
                        style: FONT.TITLE.merge(
                          TextStyle(color: COLOR.white, fontSize: 18.8),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 5.0),
                      alignment: Alignment.bottomLeft,
                      child: Icon(
                        EmployIcons.chevron_downward,
                        color: COLOR.white,
                        size: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
