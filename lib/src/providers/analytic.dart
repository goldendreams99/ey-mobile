part of employ.provider;

class Analytic {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  FirebaseAnalytics get analyzer => analytics;

  Future<void> connect({required String userId}) async {
    await analytics.setUserId(id: userId);
    await analytics.setAnalyticsCollectionEnabled(true);
  }

  Future<void> disconnect() async {
    await analytics.setAnalyticsCollectionEnabled(false);
  }

  Future<void> log(
      {required String event, required Map<String, dynamic> body}) async {
    String name = event.replaceAll(' ', '_').replaceAll('-', '_').toLowerCase();
    await analytics.logEvent(
      name: name,
      //parameters: body,
      parameters: body.cast<String, Object>(),
    );
  }

  Future<void> trackScreen({required String screenName}) async {
    String className = screenName.replaceAll(' ', '').toLowerCase();
    // Updated for Firebase Analytics v12+
    await analytics.logScreenView(
      screenName: screenName,
      screenClass: className,
    );
  }
}
