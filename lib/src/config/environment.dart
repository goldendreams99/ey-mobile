part of employ.config;

class AppConfig extends InheritedWidget {
  final String apiBaseUrl;
  final String appName;
  final bool isProduction;
  final String flavorName;
  final dynamic apiHeaders;
  final String project;
  final String androidId;
  final String iosId;

  AppConfig({
    required this.apiBaseUrl,
    required this.appName,
    required this.isProduction,
    required this.flavorName,
    required this.project,
    required this.androidId,
    required this.iosId,
    required Widget child,
  })  : apiHeaders = {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        super(child: child);

  static AppConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>()!;
  }

  Future<bool> forceUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appVersion = packageInfo.version;
    String url =
        'https://us-central1-employ-$project.cloudfunctions.net/compareVersion?version=$appVersion';
    var response = await http.post(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return false;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
