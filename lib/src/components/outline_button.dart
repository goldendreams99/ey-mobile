import 'package:flutter/material.dart';

class OutlineButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? highlightedBorderColor;
  final Color? highlightColor;
  final Color? hoverColor;
  final EdgeInsets? padding;
  final Widget child;
  final BorderSide borderSide;
  final RoundedRectangleBorder? shape;

  const OutlineButton({
    Key? key,
    required this.onPressed,
    this.highlightedBorderColor,
    this.highlightColor,
    this.hoverColor,
    this.padding,
    required this.child,
    required this.borderSide,
    this.shape,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          padding ?? EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        ),
        side: MaterialStateProperty.resolveWith<BorderSide>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return BorderSide(color: Colors.blue);
            }
            return BorderSide(color: highlightedBorderColor ?? Colors.blue);
          },
        ),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        surfaceTintColor:
            MaterialStateProperty.all(highlightColor ?? Colors.blue),
        overlayColor: MaterialStateProperty.all(hoverColor ?? Colors.blue),
        shape: MaterialStateProperty.all(
          shape ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
        ),
      ),
      child: child,
    );
  }
}
