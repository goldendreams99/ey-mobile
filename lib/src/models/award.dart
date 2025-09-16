part of employ.data_model;

class Award {
  final String id;
  final DateTime created;
  final String name;
  final String image;
  final String employee;
  final Employee from;
  final Employee to;
  final String employeeId;
  final String observation;
  final String type;
  final String period;
  final int year;
  final bool isSended;
  final bool isReceived;

  Award({
    required this.created,
    required this.employee,
    required this.from,
    required this.to,
    required this.employeeId,
    required this.id,
    required this.image,
    required this.isSended,
    required this.isReceived,
    required this.name,
    required this.observation,
    required this.period,
    required this.type,
    required this.year,
  });

  Award.fromJson(Employee employee, dynamic json)
      : id = json['id'],
        created = (json['created'] != null
                ? DateTime.tryParse(json['created'])
                : null) ??
            DateTime.now(),
        isSended = json['employee_from']['id'] == employee.id,
        isReceived = json['employee_to']['id'] == employee.id,
        name = (json['award_type'] ?? Map())['name'],
        image = (json['award_type'] ?? Map())['image'],
        employee = json['employee_to']['name'],
        from = Employee.fromJson(json['employee_from']),
        to = Employee.fromJson(json['employee_to']),
        employeeId = json['employee_to']['id'],
        observation = json['observation'] ?? '',
        period = json['period'],
        type = (json['award_type'] ?? Map())['id'],
        year = (int.tryParse(json['year'].toString().trim())) ??
            DateTime.now().year;

  String get label {
    return formatDate(created, [dd, '/', mm, '/', yyyy]);
  }

  String get relative {
    final DateTime now = DateTime.now();
    final String createdFormat =
        formatDate(created, [dd, ' ', months[created.month - 1], ' ', yyyy]);
    final DateTime thours = created.add(Duration(hours: 23, minutes: 59));
    final DateTime thours48 = created.add(Duration(hours: 47, minutes: 59));
    return thours.isAfter(now)
        ? 'Hoy'
        : thours48.isAfter(now)
            ? 'Ayer'
            : createdFormat;
  }

  static Future<String?> sendAward({
    required FirebaseDatabase db,
    required dynamic selectedType,
    required String text,
    required Employee from,
    required Employee to,
    required Company company,
    required CompanySettings settings,
    required List<Award> senteds,
  }) async {
    DateTime now = DateTime.now();
    var award = {
      'created': formatDate(now, [yyyy, '-', mm, '-', dd]),
      'year': formatDate(now, [yyyy]),
      'month': formatDate(now, [mm]),
      'period': formatDate(now, [yyyy, mm]),
      'award_type': selectedType,
      'observation': text.isNotEmpty ? text : null,
      'employee_from': from.apiData(),
      'employee_to': to.apiData(),
    };
    String? message = Award.validate(
      settings: settings,
      data: senteds,
      award: award,
    );
    if (message == null) {
      String ref = 'client/${company.id}/award/';
      DatabaseReference item = db.ref().child(ref);
      dynamic newAwardRef = item.push();
      dynamic newAward = Map.from(award);
      newAward['id'] = newAwardRef.key;
      await newAwardRef.set(newAward);
      return null;
    }
    return message;
  }

  static Stream<DatabaseEvent> getReceivedStream(
    FirebaseDatabase db,
    Company company,
    Employee employee,
  ) {
    String ref = 'client/${company.id}/award';
    Query query = db.ref().child(ref);
    query.keepSynced(true);
    return query.onValue;
  }

  static Stream<DatabaseEvent> getTypeStream(
    FirebaseDatabase db,
    Company company,
  ) {
    String ref = 'client/${company.id}/setting/award_type';
    Query query = db.ref().child(ref);
    query.keepSynced(true);
    return query.onValue;
  }

  static String getNewMonth() {
    DateTime now = DateTime.now();
    DateTime month = DateTime(now.year, now.month + 1, 1, 0, 0, 0);
    Duration differente = month.difference(now);
    int days = differente.inDays;
    int hours = differente.inHours - (days * 24);
    return '${days}d ${hours}h';
  }

  static Stream<DatabaseEvent> getSentStream(
    FirebaseDatabase db,
    Company company,
    Employee employee,
  ) {
    String ref = 'client/${company.id}/award';
    Query query = db
        .ref()
        .child(ref)
        .orderByChild('employee_from/id')
        .equalTo(employee.id);
    query.keepSynced(true);
    return query.onValue;
  }

  static sort(List<Award> documents) {
    documents.sort((a, b) => b.created.compareTo(a.created));
  }

  static void notify({
    required AppConfig config,
    required Company company,
    required Employee employee,
  }) {
    http.post(
      Uri.parse('${config.apiBaseUrl}/Award/AlertEmployee'),
      headers: config.apiHeaders,
      body: jsonEncode({
        'company_id': company.id,
        'employee_id': employee.id,
      }),
    );
  }

  static String? validate({
    required CompanySettings settings,
    required List<Award> data,
    required dynamic award,
  }) {
    String? message;
    int limitMonthlyTotal = 0;
    int limitMonthlyEmployee = 0;
    data.forEach((aw) {
      if (aw.period == award.period) limitMonthlyTotal++;
      if (aw.period == award.period && aw.employeeId == award.employeeId)
        limitMonthlyEmployee++;
      if (aw.type == award.type &&
          aw.period == award.period &&
          aw.employeeId == award.employeeId) {
        message = 'Pss.. ya le enviaste este reconocimiento!';
      } else if (settings.awardLimitMonthlyTotal <= limitMonthlyTotal) {
        message = 'Pss.. superaste el limite total del mes!';
      } else if (settings.awardLimitMonthlyEmployee <= limitMonthlyEmployee) {
        message = 'Pss.. superaste el limite para este compañero!';
      }
    });
    return message;
  }
}
