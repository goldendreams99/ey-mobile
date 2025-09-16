import 'dart:async';

/// [APP]
import 'package:employ/app.dart';
import 'package:employ/src/config/application.dart';
import 'package:employ/src/providers/index.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';

/// [FLUTTER LIBRARIES]
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Flavor { staging, production }

late Flavor flavor;

/// Background message handler for Firebase Messaging
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Background message received: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runZonedGuarded(
    () async {
      await initLocalStorage();
      await Firebase.initializeApp();
      
      // Register background message handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      
      final app = _configEnv();
      await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      FlutterError.onError = (FlutterErrorDetails details) {
        if (kDebugMode) {
          FlutterError.dumpErrorToConsole(details);
        } else {
          Zone.current.handleUncaughtError(
              details.exception, details.stack ?? StackTrace.current);
        }
      };
      runApp(app);
    },
    (error, stack) {
      debugPrint(error.toString());
    },
  );
}

AppConfig _configEnv() {
  final Crasher crasher = Crasher();
  crasher.init(kDebugMode);
  final flavorName = const String.fromEnvironment('FLAVOR', defaultValue: 'production');
  switch (flavorName) {
    case 'demo':
      flavor = Flavor.staging;
      return AppConfig(
        appName: 'Demo',
        flavorName: 'demo',
        project: '6e9e6',
        androidId: 'com.tangerine.employ.demo',
        iosId: '1475809135',
        apiBaseUrl: 'https://services-demo.employ.life/api/',
        isProduction: false,
        child: ProviderScope(
          child: Employ(
            crasher: crasher,
          ),
        ),
      );
    case 'production':
      flavor = Flavor.production;
      return AppConfig(
        appName: 'Employ',
        flavorName: 'production',
        project: '660d9',
        androidId: 'com.tangerine.employ.one',
        iosId: '1440474903',
        apiBaseUrl: 'https://services.employ.life/api/',
        isProduction: true,
        child: ProviderScope(
          child: Employ(
            crasher: crasher,
          ),
        ),
      );
    default:
      throw Exception('Invalid flavor');
  }
}
