part of employ.widgets;

class ProfileInputText extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInputText({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: calcSize(size, 4.87)),
      child: TextField(
        enabled: false,
        controller: TextEditingController(text: value),
        style: FONT.BOLD.merge(
          TextStyle(color: COLOR.greyish_brown, fontSize: 21.0),
        ),
        decoration: InputDecoration(
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                style: BorderStyle.solid,
                color: COLOR.greyish_brown,
                width: 2.0),
          ),
          labelText: label,
          labelStyle: FONT.SEMIBOLD.merge(
            TextStyle(
                color: Color.fromRGBO(255, 100, 100, 0.39), fontSize: 11.0),
          ),
        ),
      ),
    );
  }
}
