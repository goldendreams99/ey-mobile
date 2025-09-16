part of employ.provider;

class Crasher {
  final FirebaseCrashlytics analytics = FirebaseCrashlytics.instance;

  Future<void> init(bool inDebug) async {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(inDebug);
    FlutterError.onError = (FlutterErrorDetails details) {
      FirebaseCrashlytics.instance.recordFlutterError(details);
    };
  }

  void trace(String key, dynamic value) {
    analytics.setCustomKey(key, value);
  }

  void log(String event) {
    analytics.log(event);
  }

  void report(dynamic e) {
    if (e is Error)
      throw e;
    else
      throw StateError(e);
  }

  void close() {
    analytics.crash();
  }
}
