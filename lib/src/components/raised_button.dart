import 'package:flutter/material.dart';

class RaisedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final EdgeInsets? padding;
  final RoundedRectangleBorder? shape;
  final Widget child;

  const RaisedButton({
    Key? key,
    required this.onPressed,
    required this.color,
    this.padding,
    this.shape,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          shape ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
            padding ?? EdgeInsets.all(16.0)),
        backgroundColor: MaterialStateProperty.all(color),
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
      child: child,
    );
  }
}
