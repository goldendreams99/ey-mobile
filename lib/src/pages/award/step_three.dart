part of employ.pages;

class AwardStepThree extends StatefulWidget {
  final dynamic stepThreeData;
  final ValueChanged<Map<dynamic, dynamic>> onChanged;

  const AwardStepThree({
    this.stepThreeData,
    required this.onChanged,
  });
  @override
  AwardStepThreeState createState() => AwardStepThreeState();
}

class AwardStepThreeState extends State<AwardStepThree> {
  dynamic stepData;
  bool editMode = false;
  TextEditingController? commentControl;

  @override
  void initState() {
    super.initState();
    stepData = widget.stepThreeData ?? {};
    commentControl = TextEditingController(
      text: stepData['observation'] ?? '',
    );
  }

  TextStyle get inputStyle {
    return FONT.TITLE.merge(TextStyle(color: COLOR.white, fontSize: 20.0));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: COLOR.black.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 11.35,
                ),
                child: TextField(
                  controller: commentControl,
                  style: inputStyle,
                  maxLength: 140,
                  maxLines: 4,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(140),
                  ],
                  onChanged: (text) {
                    dynamic value = Map.from(stepData);
                    value['observation'] = text;
                    stepData = Map.from(value);
                    widget.onChanged(stepData);
                  },
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      hintStyle: inputStyle.merge(
                        TextStyle(
                          color: COLOR.white.withOpacity(0.4),
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 18.0,
                      ),
                      hintText: '¿Por qué?',
                      border: InputBorder.none,
                      counterText: ""),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
