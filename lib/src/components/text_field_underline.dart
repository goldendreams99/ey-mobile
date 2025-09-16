part of employ.widgets;

class UnderlineTextField extends StatelessWidget {
  final EdgeInsets? margin;
  final EdgeInsets insidePadding;
  final FocusNode? node;
  final TextEditingController? controller;
  final bool? enabled;
  final bool isPassword;
  final Function(String)? onChange;
  final Function(String)? onSubmit;
  final String? label;
  final String? hint;
  final Widget? decoration;
  final Widget? suffixDecoration;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final Color color;
  final TextInputType type;
  final TextAlign align;
  final bool autoFocus;
  final TextInputAction? action;
  final double height;
  final double width;

  const UnderlineTextField(
      {this.margin,
      this.insidePadding = const EdgeInsets.symmetric(
        vertical: 12.5,
        horizontal: 25.0,
      ),
      this.node,
      this.controller,
    this.isPassword = false,
    this.autoFocus = false,
    this.onChange,
    this.onSubmit,
    this.label,
    this.hint,
    this.decoration,
    this.style,
    this.suffixIcon,
    this.suffixDecoration,
    this.prefixIcon,
    this.labelStyle,
    this.hintStyle,
    this.color = COLOR.white,
    this.type = TextInputType.emailAddress,
    this.enabled,
    this.action,
    this.align = TextAlign.start,
    this.height = 50.0,
    this.width = 360.0
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      child: TextField(
        textInputAction: action,
        autofocus: autoFocus,
        keyboardType: type,
        controller: controller,
        focusNode: node,
        obscureText: isPassword,
        style: style,
        onChanged: onChange,
        onSubmitted: onSubmit,
        enabled: enabled,
        textAlign: align,
        decoration: InputDecoration(
          contentPadding: insidePadding,
          labelStyle: labelStyle,
          labelText: label,
          hintText: hint,
          hintStyle: hintStyle,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: color, width: 2),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: color, width: 2),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: color, width: 2),
          ),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, size: 18.0, color: color)
              : null,
          prefix: decoration,
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, size: 18.0, color: color)
              : null,
              suffix: suffixDecoration,
        ),
      ),
    );
  }
}
