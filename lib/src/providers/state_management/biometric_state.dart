part of employ.provider;

class BiometricManagement with ChangeNotifier {
  /// [VARIABLES]
  String _frontPath = '';
  String _backPath = '';
  String _selfiePath = '';
  String _signaturePath = '';
  dynamic _signatureData;

  /// [GETTERS]
  String get frontPath => _frontPath;
  String get backPath => _backPath;
  String get selfiePath => _selfiePath;
  String get signaturePath => _signaturePath;
  dynamic get signatureData => _signatureData;

  /// [SETTERS]
  set frontPath(String newValue) {
    _frontPath = newValue;
    notifyListeners();
  }
  set backPath(String newValue) {
    _backPath = newValue;
    notifyListeners();
  }
  set selfiePath(String newValue) {
    _selfiePath = newValue;
    notifyListeners();
  }
  set signaturePath(String newValue) {
    _signaturePath = newValue;
    notifyListeners();
  }
  set signatureData(dynamic newValue) {
    _signatureData = newValue;
    notifyListeners();
  }
}
