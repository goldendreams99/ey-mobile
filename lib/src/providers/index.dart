library employ.provider;

import 'dart:async';
import 'dart:io';

/// [APP]
import 'package:employ/src/config/application.dart';
import 'package:employ/src/helpers/object.dart';
import 'package:employ/src/models/index.dart';

/// [FIREBASE VENDORS]
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart'; // Disabled for iOS build
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_storage/firebase_storage.dart';
/// [FLUTTER VENDORS]
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

part './analytic.dart';
part './authentication.dart';
part './crashlytic.dart';
part './database.dart';
part './linking.dart';
part './messaging.dart';
part './performance.dart';
part './state_management/biometric_state.dart';
part './storage.dart';

class EmployProvider extends InheritedWidget {
  final Analytic? analytics;
  final Authentication? auth;
  final Database database;
  final Messaging? messaging;
  final Performer? performance;
  final Crasher? crashlytics;
  final Linking? linking;
  final Storage? storage;

  EmployProvider({
    Key? key,
    required Widget child,
    this.analytics,
    this.auth,
    this.crashlytics,
    required this.database,
    this.linking,
    this.messaging,
    this.performance,
    this.storage,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static EmployProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<EmployProvider>()!;
  }
}
