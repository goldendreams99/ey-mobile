import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';

class BackToExit extends StatelessWidget {
  final Widget child;

  const BackToExit({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DoubleBackToCloseApp(
      child: child,
      snackBar: const SnackBar(
        duration: Duration(seconds: 1),
        content: Text('Vuelva a tocar atrás para salir'),
      ),
    );
  }
}
