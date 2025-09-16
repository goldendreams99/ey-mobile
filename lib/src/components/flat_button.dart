import 'package:flutter/material.dart';

class FlatButton extends StatelessWidget {
  final VoidCallback onPressed;
  final EdgeInsets? padding;
  final Widget child;
  final RoundedRectangleBorder? shape;

  const FlatButton({
    Key? key,
    required this.onPressed,
    this.padding,
    required this.child,
    this.shape,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextButton(
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
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
        child: child,
      ),
    );
  }
}
