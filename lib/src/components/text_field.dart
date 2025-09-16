part of employ.widgets;

class CustomTextField extends StatelessWidget {
  final EdgeInsets? margin;
  final FocusNode? node;
  final TextEditingController? controller;
  final bool isPassword;
  final Function(String)? onChange;
  final Function(String)? onSubmit;
  final String? label;
  final String? hint;
  final Widget? decoration;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final InputBorder? focusedBorder;
  final TextInputType type;

  const CustomTextField({
    this.margin,
    this.node,
    this.controller,
    this.isPassword = false,
    this.onChange,
    this.onSubmit,
    this.label,
    this.hint,
    this.decoration,
    this.style,
    this.labelStyle,
    this.focusedBorder,
    this.type = TextInputType.emailAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: TextField(
        keyboardType: type,
        controller: controller,
        focusNode: node,
        obscureText: isPassword,
        style: style,
        onChanged: onChange,
        onSubmitted: onSubmit,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.5,
            horizontal: 25.0,
          ),
          labelStyle: labelStyle,
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(),
          focusedBorder: focusedBorder,
          suffixIcon: decoration,
        ),
      ),
    );
  }
}
