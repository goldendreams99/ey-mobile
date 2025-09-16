part of employ.widgets;

class PinTextField extends StatefulWidget {
  final int fields;
  final onSubmit;
  final fieldWidth;
  final fontSize;
  final isTextObscure;
  final inputStyle;
  final inputDecoration;
  final Color color;

  PinTextField({
    this.fields = 4,
    this.onSubmit,
    this.fieldWidth = 50.0,
    this.fontSize = 20.0,
    this.isTextObscure = true,
    this.inputStyle,
    this.inputDecoration,
    required this.color,
  });

  @override
  State createState() {
    return PinTextFieldState();
  }
}

class PinTextFieldState extends State<PinTextField> {
  late List<String> _pin;
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _textControllers;

  @override
  void initState() {
    super.initState();
    _pin = List.filled(widget.fields, '');
    _focusNodes = List.filled(widget.fields, FocusNode());
    _textControllers = List.filled(widget.fields, TextEditingController());
  }

  @override
  void dispose() {
    _textControllers.forEach((TextEditingController t) => t.dispose());
    super.dispose();
  }

  void clearTextFields() {
    _textControllers.forEach(
        (TextEditingController tEditController) => tEditController.clear());
    _pin.clear();
  }

  Widget buildTextField(int i, BuildContext context) {
    _focusNodes[i] = FocusNode();
    _textControllers[i] = TextEditingController();

    _focusNodes[i].addListener(() {
      if (_focusNodes[i].hasFocus) {
        _textControllers[i].clear();
      }
    });

    return Container(
      height: widget.fieldWidth,
      width: widget.fieldWidth,
      margin: EdgeInsets.only(right: 10.0),
      child: TextField(
        controller: _textControllers[i],
        keyboardType: TextInputType.text,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: FONT.MEDIUM.merge(
          TextStyle(
            color: widget.color,
            fontSize: 29.8,
          ),
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0.0),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.color),
          ),
        ),
        focusNode: _focusNodes[i],
        obscureText: widget.isTextObscure,
        onChanged: (String str) {
          _pin[i] = str;
          if (i + 1 != widget.fields) {
            FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
          } else {
            FocusScope.of(context).requestFocus(_focusNodes[0]);
            widget.onSubmit(_pin.join());
            clearTextFields();
          }
        },
        onSubmitted: (String str) {
          widget.onSubmit(_pin.join());
          clearTextFields();
        },
      ),
    );
  }

  Widget generateTextFields(BuildContext context) {
    List<Widget> textFields = List.generate(widget.fields, (int i) {
      return buildTextField(i, context);
    });

    // FocusScope.of(context).requestFocus(_focusNodes[0]);

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: textFields);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: generateTextFields(context),
    );
  }
}
