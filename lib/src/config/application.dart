library employ.config;

/// [DART VENDORS]
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
/// [APP]
import 'package:employ/src/models/index.dart';
import 'package:employ/src/pages/expense/expense_add/expense.add.dart';
import 'package:employ/src/pages/index.dart';

/// [VENDORS]
import 'package:fluro/fluro.dart' as fluro;
import 'package:flutter/cupertino.dart';
/// [FLUTTER LIBRARIES]
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

part './constants.dart';
part './redux/actions.dart';
part './router/index.dart';
part './router/routes.dart';
part 'environment.dart';

class Application {
  static fluro.FluroRouter router = fluro.FluroRouter();

  static showInSnackBar(GlobalKey<ScaffoldState> key, String value) {
    ScaffoldMessenger.of(key.currentState!.context).showSnackBar(
      SnackBar(
        content: Text(value),
      ),
    );
  }
}
