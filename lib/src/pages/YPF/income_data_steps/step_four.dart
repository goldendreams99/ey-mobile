part of employ.pages;

class IncomeDataStepFour extends StatefulWidget {
  final Map<String, String>? stepFourData;
  final ValueChanged<Map<String, String>> onChanged;

  const IncomeDataStepFour({this.stepFourData, required this.onChanged});

  @override
  IncomeDataStepFourState createState() => IncomeDataStepFourState();
}

class IncomeDataStepFourState extends State<IncomeDataStepFour> {
  late Map<String, String> stepFourData;
  late TextEditingController documentController;
  late TextEditingController phoneController;
  late TextEditingController nationalityController;
  late List<dynamic> americanCountries;
  dynamic defaultCountry;

  @override
  void initState() {
    super.initState();
    stepFourData = widget.stepFourData ?? Map();
    documentController =
        TextEditingController(text: stepFourData['document'] ?? '');
    phoneController = TextEditingController(text: stepFourData['phone'] ?? '');
    nationalityController =
        TextEditingController(text: stepFourData['nationality'] ?? '');
    americanCountries = CountryCodes.countryCodes()
        .where((country) => country?.localizedName == 'America')
        .toList();
    if (stepFourData['nationality'] != null) {
      defaultCountry = americanCountries.singleWhere(
          (country) => country['name'] == stepFourData['nationality'],
          orElse: () => null);
    }
  }

  void change(String target, dynamic value) async {
    stepFourData[target] = value;
    widget.onChanged(stepFourData);
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

  void openSelect() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmploySelect<dynamic>(
          title: 'Nacionalidad',
          options: americanCountries,
          selected: defaultCountry,
          render: (option) => option['name'],
        ),
      ),
    ).then((value) {
      if (value != null) {
        defaultCountry = value;
        stepFourData['nationality'] = value['name'];
        nationalityController = TextEditingController(text: value['name']);
        widget.onChanged(stepFourData);
      }
    });
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
            InkResponse(
              onTap: openSelect,
              child: UnderlineTextField(
                height: calcSize(size, 51.0),
                controller: nationalityController,
                margin: EdgeInsets.symmetric(vertical: 20.0),
                label: 'Nacionalidad',
                hint: 'Argentina',
                color: COLOR.white,
                type: TextInputType.text,
                insidePadding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 9.0),
                suffixIcon: EmployIcons.chevron_right,
                style: textStyle,
                hintStyle: hintStyle,
                labelStyle: labelStyle,
                enabled: false,
              ),
            ),
            UnderlineTextField(
              height: calcSize(size, 51.0),
              controller: documentController,
              margin: EdgeInsets.symmetric(vertical: 20.0),
              label: 'Documento',
              hint: '23594938',
              color: COLOR.white,
              type: TextInputType.number,
              insidePadding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 9.0),
              suffixIcon: EmployIcons.edit,
              style: textStyle,
              hintStyle: hintStyle,
              labelStyle: labelStyle,
              onChange: (text) => change('document', text),
            ),
            UnderlineTextField(
              height: calcSize(size, 51.0),
              controller: phoneController,
              margin: EdgeInsets.symmetric(vertical: 20.0),
              label: 'Telefono',
              hint: '+54 11-2163-7233',
              color: COLOR.white,
              type: TextInputType.number,
              insidePadding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 9.0),
              suffixIcon: EmployIcons.edit,
              style: textStyle,
              hintStyle: hintStyle,
              labelStyle: labelStyle,
              decoration: defaultCountry != null
                  ? Container(
                      width: 32.0,
                      height: 15.0,
                      padding: EdgeInsets.only(right: 8.0),
                      child: Image.asset(
                        'flags/${defaultCountry['code'].toLowerCase()}.png',
                        package: 'country_code_picker',
                        fit: BoxFit.contain,
                      ),
                    )
                  : null,
              onChange: (text) => change('phone', text),
            ),
          ],
        ),
      ),
    );
  }
}
