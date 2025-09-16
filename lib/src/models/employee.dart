part of employ.data_model;

class Employee {
  /// Basic data
  final String id;
  final String? document;
  final String name;
  final String lastName;
  final String firstName;
  final String portalId;
  final String portalUser;
  final String gender;
  final String avatar;
  final String dateBirth;
  final String bankAccount;
  final bool active;
  final bool portal;
  final bool portalPassword;
  final dynamic costCenter;
  final dynamic department;
  final dynamic place;
  final dynamic position;

  /// Alerts
  final bool alertLicense;
  final bool alertAward;
  final bool alertPaycheck;
  final bool alertDocument;
  final bool alertMessage;

  /// Modules
  final bool moduleAward;
  final bool moduleChat;
  final bool moduleDocument;
  final bool moduleExpense;
  final bool moduleLicense;
  final bool modulePaycheck;
  final bool moduleSignplify;

  // Module Signature Type
  final String? moduleDocumentSign;
  final String? moduleLicenseSign;
  final String? modulePaycheckSign;

  /// Custom Objects
  final EmployeeCertificate? certificate;
  final EmployeeSignplify? signplify;
  final EmployeeBook book;

  Employee({
    required this.id,
    required this.document,
    required this.name,
    required this.lastName,
    required this.firstName,
    required this.portalId,
    required this.portal,
    required this.portalPassword,
    required this.portalUser,
    required this.gender,
    required this.avatar,
    required this.dateBirth,
    required this.active,
    required this.moduleAward,
    required this.moduleChat,
    required this.moduleDocument,
    required this.moduleExpense,
    required this.moduleLicense,
    required this.modulePaycheck,
    required this.moduleSignplify,
    required this.moduleDocumentSign,
    required this.moduleLicenseSign,
    required this.modulePaycheckSign,
    required this.certificate,
    required this.signplify,
    required this.book,
    required this.bankAccount,
    required this.alertLicense,
    required this.alertAward,
    required this.alertPaycheck,
    required this.alertDocument,
    required this.alertMessage,
    required this.costCenter,
    required this.department,
    required this.place,
    required this.position,
  });

  Employee.fromJson(dynamic json)
      : id = json['id'],
        document = json['document']?.toString(),
        name = json['name'] ??
            ('${json['last_name'] ?? ''}, ${json['first_name'] ?? ''}'),
        lastName = json['last_name'] ?? '',
        firstName = json['first_name'] ?? '',
        portalId = json['portal_id'] ?? '',
        department = json['department'],
        place = json['place'],
        position = json['position'],
        bankAccount = json['bank_account_key'] ?? '',
        portal = json['portal'] != null && json['portal'],
        portalPassword = json['portal_password'] != null,
        portalUser = json['portal_user'].toString(),
        gender = json['gender'] ?? '',
        avatar = json['avatar'] == null ||
                !json['avatar'].toLowerCase().contains('http')
            ? getRandomAvatar(
                json['first_name'] ?? json['last_name'] ?? json['name'] ?? '')
            : json['avatar'],
        dateBirth = json['date_birth'] ?? '',
        active = json['active'] != null && json['active'],
        moduleAward = json['module_award'] != null && json['module_award'],
        moduleChat = json['module_chat'] != null && json['module_chat'],
        moduleDocument =
            json['module_document'] != null && json['module_document'],
        moduleExpense =
            json['module_expense'] != null && json['module_expense'],
        moduleLicense =
            json['module_license'] != null && json['module_license'],
        modulePaycheck =
            json['module_paycheck'] != null && json['module_paycheck'],
        moduleSignplify =
            json['module_signplify'] != null && json['module_signplify'],
        moduleDocumentSign = json['module_document_sign'] is String
            ? json['module_document_sign']
            : null,
        moduleLicenseSign = json['module_license_sign'] is String
            ? json['module_license_sign']
            : null,
        modulePaycheckSign = json['module_paycheck_sign'] is String
            ? json['module_paycheck_sign']
            : null,
        signplify = json['signplify'] != null
            ? EmployeeSignplify.fromJson(json['signplify'] is String
                ? jsonDecode(json['signplify'])
                : json['signplify'])
            : null,
        book = EmployeeBook.fromJson(json['book'] != null
            ? (json['book'].runtimeType == String
                ? jsonDecode(json['book'])
                : json['book'])
            : Map()),
        certificate = EmployeeCertificate.fromJson(json['certificate'] != null
            ? (json['certificate'].runtimeType == String
                ? jsonDecode(json['certificate'])
                : json['certificate'])
            : Map()),
        alertLicense = json['alert_license'] != null && json['alert_license'],
        alertAward = json['alert_award'] != null && json['alert_award'],
        alertPaycheck =
            json['alert_paycheck'] != null && json['alert_paycheck'],
        alertDocument =
            json['alert_document'] != null && json['alert_document'],
        costCenter = json['costcenter'],
        alertMessage = json['alert_message'] != null && json['alert_message'];

  static getRandomAvatar(String name) {
    if (name.isEmpty) return avatarList[12];
    String _name = name.toLowerCase();
    if (_name.startsWith('a')) return avatarList[0];
    if (_name.startsWith('b')) return avatarList[1];
    if (_name.startsWith('c')) return avatarList[2];
    if (_name.startsWith('d')) return avatarList[3];
    if (_name.startsWith('e')) return avatarList[4];
    if (_name.startsWith('f')) return avatarList[5];
    if (_name.startsWith('g')) return avatarList[6];
    if (_name.startsWith('h')) return avatarList[7];
    if (_name.startsWith('i')) return avatarList[0];
    if (_name.startsWith('j')) return avatarList[1];
    if (_name.startsWith('k')) return avatarList[2];
    if (_name.startsWith('l')) return avatarList[3];
    if (_name.startsWith('n')) return avatarList[4];
    if (_name.startsWith('m')) return avatarList[5];
    if (_name.startsWith('ñ')) return avatarList[6];
    if (_name.startsWith('o')) return avatarList[7];
    if (_name.startsWith('p')) return avatarList[8];
    if (_name.startsWith('q')) return avatarList[9];
    if (_name.startsWith('r')) return avatarList[10];
    if (_name.startsWith('s')) return avatarList[11];
    if (_name.startsWith('t')) return avatarList[12];
    if (_name.startsWith('v')) return avatarList[10];
    if (_name.startsWith('u')) return avatarList[11];
    if (_name.startsWith('w')) return avatarList[12];
    if (_name.startsWith('z')) return avatarList[7];
    if (_name.startsWith('y')) return avatarList[8];
    if (_name.startsWith('x')) return avatarList[9];
    if (_name.startsWith('1')) return avatarList[1];
    if (_name.startsWith('2')) return avatarList[2];
    if (_name.startsWith('3')) return avatarList[3];
    if (_name.startsWith('4')) return avatarList[4];
    if (_name.startsWith('5')) return avatarList[5];
    if (_name.startsWith('6')) return avatarList[6];
    if (_name.startsWith('7')) return avatarList[7];
    if (_name.startsWith('8')) return avatarList[8];
    if (_name.startsWith('9')) return avatarList[9];
    if (_name.startsWith('0')) return avatarList[0];
  }

  String get profileName {
    return '$firstName $lastName';
  }

  static int getSendedAwards(int limit, List<Award> documents) {
    int value = limit;
    DateTime now = DateTime.now();
    List<String> format = [yyyy, mm];
    String period = formatDate(now, format);
    documents.forEach((doc) {
      if (doc.period == period && doc.isSended) value--;
    });
    return value;
  }

  static List<Award> sendedAwards(List<Award> documents) {
    List<Award> docs = [];
    DateTime now = DateTime.now();
    List<String> format = [yyyy, mm];
    String period = formatDate(now, format);
    documents.forEach((doc) {
      if (doc.period == period && doc.isSended) docs.add(doc);
    });
    return docs;
  }

  static List<Award> receivedAwards(List<Award> documents) {
    return documents.where((doc) => doc.isReceived).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'document': document,
        'name': name,
        'lastName': lastName,
        'firstName': firstName,
        'portalId': portalId,
        'portalUser': portalUser,
        'gender': gender,
        'avatar': avatar,
        'dateBirth': dateBirth,
        'bankAccount': bankAccount,
        'active': active,
        'portal': portal,
        'costCenter': costCenter,
        'department': department,
        'place': place,
        'position': position,
        'alertLicense': alertLicense,
        'alertAward': alertAward,
        'alertPaycheck': alertPaycheck,
        'alertDocument': alertDocument,
        'alertMessage': alertMessage,
        'moduleAward': moduleAward,
        'moduleChat': moduleChat,
        'moduleDocument': moduleDocument,
        'moduleExpense': moduleExpense,
        'moduleLicense': moduleLicense,
        'modulePaycheck': modulePaycheck,
        'moduleSignplify': moduleSignplify,
        'moduleDocumentSign': moduleDocumentSign,
        'moduleLicenseSign': moduleLicenseSign,
        'modulePaycheckSign': modulePaycheckSign,
        'certificate': certificate?.toJson(),
        'signplify': signplify?.toJson(),
        'book': book.toJson(),
      };

  Map<String, dynamic> apiData() {
    return {
      'avatar': avatar,
      'date_birth': dateBirth,
      'document': document,
      'gender': gender,
      'id': id,
      'mail': book.mail,
      'name': name,
    };
  }

  Map<String, dynamic> apiExpenseData() {
    return Map<String, dynamic>.from(this.apiData())
      ..addAll(Map<String, dynamic>.from({
        'department': json.decode(json.encode(department)),
        'place': place,
        'position': position,
      }));
  }

  dynamic signApiData() {
    return {
      'employee_id': id,
      'signer_certificate_key': certificate?.key,
      'signer_document': document,
      'signer_name': name,
    };
  }

  String get shortName {
    String subName = '';
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      // Use firstName first, then lastName (correct order)
      subName = '${firstName[0]}${lastName[0]}';
    } else if (name.isNotEmpty) {
      List<String> fullName = name.split(' ');
      fullName = fullName.where((l) => l.isNotEmpty).toList();
      subName = fullName.length > 1
          ? '${fullName[0][0]}${fullName[1][0]}'
          : fullName[0][0];
    }
    return subName;
  }

  bool getBadge(String key) {
    switch (key) {
      case 'alert_paycheck':
        return alertPaycheck;
      case 'alert_document':
        return alertDocument;
      case 'alert_message':
        return alertMessage;
      case 'alert_license':
        return alertLicense;
      case 'alert_award':
        return alertAward;
      default:
        return false;
    }
  }

  static sortByName(List<Employee> documents) {
    documents.sort((a, b) => a.name.compareTo(b.name));
  }

  static List<Employee> awardFilter(List<Employee> documents, Employee employee,
      {String? query}) {
    if (query != null && query.isNotEmpty) {
      String _query = query.toLowerCase();
      List<Employee> values = documents.where((item) {
        String _firstName = item.firstName.toLowerCase();
        String _lastName = item.lastName.toLowerCase();
        bool noIsMe = item.id != employee.id;
        bool hasFirstName = _firstName.contains(_query);
        bool hasLastName = _lastName.contains(_query);
        return noIsMe && (hasFirstName || hasLastName);
      }).toList();
      return values;
    } else
      return documents.where((item) => item.id != employee.id).toList();
  }

  static Stream<DatabaseEvent> getStream(
    FirebaseDatabase db,
    Company company,
  ) {
    String ref = 'client/${company.id}/employee';
    Query query = db.ref().child(ref);
    query.keepSynced(true);
    return query.onValue;
  }
}
