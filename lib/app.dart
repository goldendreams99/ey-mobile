library employ;

import 'dart:async';
/// [DART VENDORS]
import 'dart:io';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:employ/src/components/index.dart';
/// [APP]
import 'package:employ/src/config/application.dart';
import 'package:employ/src/providers/index.dart';
import 'package:employ/src/theme/index.dart';
import 'package:file_picker/file_picker.dart';
/// [FIREBASE VENDORS]
import 'package:firebase_analytics/observer.dart';
/// [VENDORS]
import 'package:fluro/fluro.dart' as fluro;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';  // Removed due to AGP 8.x namespace issue
/// [FLUTTER VENDORS]
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/geolocation.dart' as geoLocation;  // Removed due to AGP 8.x namespace issue
// import 'package:google_maps_webservice/places.dart';  // Removed due to AGP 8.x namespace issue
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart' as LocationManager;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render.dart';
/// [VENDORS]
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:localstorage/localstorage.dart';

part './src/helpers/attachment.dart';
part './src/helpers/index.dart';

class Employ extends StatelessWidget {
  static Analytic analytics = Analytic();
  final Authentication auth = Authentication();
  final Database db = Database();
  final Messaging messaging = Messaging();
  final Performer perform = Performer();
  final Storage st = Storage();
  final Crasher crasher;

  Employ({
    required this.crasher,
    Key? key,
  }) : super(key: key) {
    Intl.defaultLocale = "es";
    final router = fluro.FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;
    timeago.setLocaleMessages('es', timeago.EsMessages());
    timeago.setLocaleMessages('es_short', timeago.EsShortMessages());
    db.init();
  }

  @override
  Widget build(BuildContext context) {
    var config = AppConfig.of(context);
    return EmployProvider(
      analytics: analytics,
      auth: auth,
      database: db,
      messaging: messaging,
      performance: perform,
      crashlytics: crasher,
      storage: st,
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
          brightness: Brightness.light,
          canvasColor: Colors.transparent,
        ),
        supportedLocales: [
          const Locale('en'),
          const Locale('es'),
        ],
        debugShowCheckedModeBanner: false,
        title: config.appName,
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics.analyzer)
        ],
        onGenerateRoute: Application.router.generator,
        initialRoute: Routes.root,
        builder: FToastBuilder(),
      ),
    );
  }
}
