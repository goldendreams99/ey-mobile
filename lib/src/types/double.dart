import 'package:flutter/cupertino.dart';

extension DoubleExtension on double {
  double vh(BuildContext context) {
    return MediaQuery.of(context).size.height * (this / 100);
  }

  double vw(BuildContext context) {
    return MediaQuery.of(context).size.width * (this / 100);
  }
}
