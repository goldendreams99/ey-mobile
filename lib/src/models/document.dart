part of employ.data_model;

class Document {
  final String category;
  final DateTime created;
  final String id;
  final String name;
  final String period;
  final dynamic type;
  final String url;
  final int year;
  final int month;
  final int status;
  final bool isPending;

  Document({
    required this.category,
    required this.created,
    required this.id,
    required this.name,
    required this.period,
    required this.type,
    required this.url,
    required this.year,
    required this.month,
    required this.status,
    required this.isPending,
  });

  Document.fromJson(dynamic json, {String category = 'Paycheck'})
      : category = category,
        created = (json['created'] != null
                ? DateTime.tryParse(json['created'])
                : null) ??
            DateTime.now(),
        id = json['id'] ?? '',
        isPending = json['status'] == 2,
        name = json['name'] ?? '',
        period = json['period'] ?? '',
        type = json['type'],
        url = json['url'] ?? '',
        status = json['status'],
        year = (int.tryParse(json['year'].toString().trim())) ??
            DateTime.now().year,
        month = (int.tryParse(json['month'].toString().trim())) ??
            DateTime.now().month;

  String get typeName => type['name'];

  String get monthName => months[month - 1];

  String get label {
    final DateTime now = DateTime.now();
    final String createdFormat = formatDate(created, [dd, '/', mm, '/', yyyy]);
    final DateTime thours = created.add(Duration(hours: 23, minutes: 59));
    final DateTime thours48 = created.add(Duration(hours: 47, minutes: 59));
    return thours.isAfter(now)
        ? 'Hoy'
        : thours48.isAfter(now)
            ? 'Ayer'
            : createdFormat;
  }

  Map<String, dynamic> toJson() => {
        'category': category,
        'created': created,
        'id': id,
        'name': name,
        'period': period,
        'type': type,
        'url': url,
        'year': year,
        'isPending': isPending,
      };

  Future<String?> sign({
    required AppConfig config,
    required int status,
    required int agree,
    required String observation,
    required Employee employee,
    required Company company,
    required String pin,
    bool isArg = false,
  }) async {
    Map<String, dynamic> payload = {
      'production': config.isProduction,
      'company_id': company.id,
      'employee_id': employee.id,
      'document_status': status,
      'signer_observation': observation,
      'signer_pin': pin,
      'company_certificate_key': company.certificateKey,
      'signer_certificate_key': employee.certificate?.key,
      'signer_document': employee.document,
      'signer_name': employee.name,
      'document': apiRequiredInfo,
    };
    if (!isArg) payload..addAll({'signer_employee_paycheck_agree': agree == 3});
    return await signRequest(
      payload: payload,
      url: '${config.apiBaseUrl}$category/EmployeeSign${isArg ? 'Ar' : ''}',
      headers: config.apiHeaders,
      isArg: isArg,
    );
  }

  Future<String?> signRequest({
    required dynamic payload,
    required String url,
    required dynamic headers,
    bool isArg = false,
  }) async {
    String body = jsonEncode(Map.from(payload));
    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    return response.statusCode != 200
        ? null
        : isArg
            ? jsonDecode(response.body)
            : 'ok';
  }

  dynamic get apiRequiredInfo {
    return {
      'url': url,
      'id': id,
      'type': type,
      'name': name,
    };
  }

  bool canSign(List<Document> documents) {
    try {
      documents.firstWhere((item) {
        return item.period.compareTo(period) <= 0 &&
            item.period != period &&
            item.id != id &&
            item.isPending;
      });
      return false;
    } catch (e) {
      return true;
    }
  }

  static sort(List<Document> documents) {
    documents.sort((a, b) => b.period.compareTo(a.period));
  }

  Future<File?> download(BuildContext context) async {
    try {
      bool can = await canWriteOnStorage(context);
      if (!can) return null;
      var dir = await getApplicationSupportDirectory();
      final employDir = Directory('${dir.path}/Employ/$category');
      bool employExist = await employDir.exists();
      if (!employExist) await employDir.create(recursive: true);
      File file = File('${employDir.path}/${isPending ? 'u' : 's'}_$name');
      bool isdownloaded = await file.exists();
      if (isdownloaded)
        return file;
      else {
        var data = await http.get(Uri.parse(url));
        var bytes = data.bodyBytes;
        File urlFile = await file.writeAsBytes(bytes);
        return urlFile;
      }
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  static List<Document> filter(
    List<Document> documents,
    int year,
    bool all,
    bool isPending,
    //---------- BEGIN ----------//
    String type,
    //---------- FINISH ----------//
  ) {
    //---------- BEGIN ----------//
    List<Document> filteredDocuments;
    //---------- FINISH ----------//
    if (all) {
      //---------- BEGIN ----------//
      filteredDocuments = documents
          //---------- FINISH ----------//
          .where((item) =>
              item.year == year && item.status >= 2 && item.status <= 4)
          //---------- BEGIN ----------//
          .toList();
          //---------- FINISH ----------//
    } else if (isPending) {
      //---------- BEGIN ----------//
      filteredDocuments = documents
          //---------- FINISH ----------//
          .where((item) => item.year == year && item.isPending == isPending)
          //---------- BEGIN ----------//
          .toList();
          //---------- FINISH ----------//
    } else
      //---------- BEGIN ----------//
      filteredDocuments = documents
          //---------- FINISH ----------//
          .where((item) =>
              item.year == year && item.status >= 3 && item.status <= 4)
          //---------- BEGIN ----------//
          .toList();
    
    // Aplicar filtro de tipo
    if (type != 'Todos') {
      filteredDocuments = filteredDocuments
          .where((item) => item.typeName == type)
          .toList();
    }
    
    return filteredDocuments;
    //---------- FINISH ----------//
  }

  static Stream<DatabaseEvent> getStream(
    FirebaseDatabase db,
    Company company,
    Employee employee,
    String docCategory,
  ) {
    String ref = 'client/${company.id}/$docCategory';
    Query query = db
        .ref()
        .child(ref)
        .orderByChild(docCategory == 'paycheck' ? 'employee_id' : 'employee/id')
        .equalTo(employee.id);
    query.keepSynced(true);
    return query.onValue;
  }
}
