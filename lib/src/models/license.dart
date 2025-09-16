part of employ.data_model;

class License {
  final String id;
  final String name;
  final DateTime created;
  final DateTime from;
  final DateTime to;
  final int? year;
  final String url;
  final bool signed;
  final List<dynamic> attachments;
  final bool signRequired;
  final bool toSign;
  final bool employeeSigned;
  final bool pending;
  final bool approved;
  final bool rejected;
  final dynamic item;
  final int? status;
  final String observation;
  final String reply;
  final bool isRemovable;

  License({
    required this.id,
    required this.name,
    required this.created,
    required this.from,
    required this.to,
    required this.year,
    required this.url,
    required this.signed,
    required this.signRequired,
    required this.toSign,
    required this.employeeSigned,
    required this.pending,
    required this.approved,
    required this.rejected,
    required this.attachments,
    required this.item,
    required this.observation,
    required this.reply,
    required this.isRemovable,
    this.status,
  });

  License.fromJson(dynamic json)
      : id = json['id'] ?? '',
        name = json['type']['name'] ?? '',
        url = json['url'] ?? '',
        signed = json['date_sign_employee'] != null,
        item = json,
        status = json['status'],
        observation = json['observation'] ?? '',
        reply = json['reply'] ?? '',
        signRequired = json['type']['sign'] != null && json['type']['sign'],
        toSign = json['status'] == 0,
        employeeSigned = json['status'] == 1 || json['status'] == 3,
        rejected = json['status'] == 5,
        approved = json['status'] == 4,
        pending = json['status'] > 0 && json['status'] <= 3,
        created = json['created'] != null
            ? DateTime.tryParse(json['created']) ?? DateTime.now()
            : DateTime.now(),
        from = json['date_from'] != null
            ? DateTime.tryParse(json['date_from']) ?? DateTime.now()
            : DateTime.now(),
        year = DateTime.tryParse(json['date_from'])?.year,
        to = json['date_to'] != null
            ? DateTime.tryParse(json['date_to']) ?? DateTime.now()
            : DateTime.now(),
        attachments = List.from(json['attachments'] ?? []),
        isRemovable = json['status'] <= 2 && json['status'] >= 0;

  bool get hasDocument {
    return signRequired;
  }

  Future<File?> download(BuildContext context) async {
    try {
      bool can = await canWriteOnStorage(context);
      if (!can) return null;
      var dir = await getApplicationSupportDirectory();
      final employDir = Directory('${dir.path}/Employ/License');
      bool employExist = await employDir.exists();
      if (!employExist) await employDir.create(recursive: true);
      String fileName = 'license_';
      if (status == 0)
        fileName = '${fileName}u';
      else if (status! > 0 && status! < 4)
        fileName = '${fileName}es';
      else if (status == 4) fileName = '${fileName}s';
      fileName = '${fileName}_$id.pdf';
      File file = File('${employDir.path}/$fileName');
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

  String get relative {
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

  String get label {
    return '$fromLabel - $toLabel';
  }

  String get fromLabelRelative {
    return formatDate(
        from, [dd, ' ', months[from.month - 1].substring(0, 3), ' ', yyyy]);
  }

  String get toLabelRelative {
    return formatDate(
        to, [dd, ' ', months[to.month - 1].substring(0, 3), ' ', yyyy]);
  }

  String get fromLabel {
    return formatDate(from, [dd, '/', mm, '/', yyyy]);
  }

  String get toLabel {
    return formatDate(to, [dd, '/', mm, '/', yyyy]);
  }

  Future<List<File>?> downloadAttachments(BuildContext context) async {
    List<File> files = [];
    if (attachments.length > 0) {
      try {
        bool can = await canWriteOnStorage(context);
        if (!can) return null;
        var dir = await getApplicationSupportDirectory();
        final employDir = Directory('${dir.path}/Employ/Media');
        bool employExist = await employDir.exists();
        if (!employExist) await employDir.create(recursive: true);
        List<File> _attachments = attachments
            .map((attachment) =>
                File('${employDir.path}/license-${attachment['name']}'))
            .toList();
        var exists =
            await Future.wait(_attachments.map((f) => f.exists()).toList());
        bool isdownloaded = List.from(exists).reduce((curr, next) {
          return curr && next;
        });
        if (isdownloaded)
          files = List.from(_attachments);
        else {
          var data = await Future.wait(
              attachments.map((a) => http.get(Uri.parse(a['url']))).toList());
          var bytes = data.map((d) => d.bodyBytes).toList();
          var futures = <Future>[];
          for (var i = 0; i < _attachments.length; i++) {
            futures.add(_attachments[i].writeAsBytes(bytes[i]));
          }
          files = List.from(await Future.wait(futures));
        }
      } catch (e) {
        throw Exception("Error opening url file");
      }
    }
    return files;
  }

  Future<String?> sign({
    required AppConfig config,
    required int status,
    required String observation,
    required Employee employee,
    required Company company,
    required String pin,
    required License license,
    bool isArg = false,
  }) async {
    Map<String, dynamic> payload = {
      'production': config.isProduction,
      'company_id': company.id,
      'employee_id': employee.id,
      'company_certificate_key': company.certificateKey,
      'signer_certificate_key': employee.certificate?.key,
      'signer_document': employee.document,
      'signer_name': employee.name,
      'document_status': status,
      'signer_observation': observation,
      'signer_pin': pin,
      'document': license.item,
    };
    return signRequest(
      payload: payload,
      url: '${config.apiBaseUrl}/$License/EmployeeSign${isArg ? 'Ar' : ''}',
      headers: config.apiHeaders,
      isArg: isArg,
    );
  }

  Future<String?> signRequest({
    dynamic payload,
    required String url,
    dynamic headers,
    required bool isArg,
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

  static dynamic register(
    AppConfig config,
    Company company,
    dynamic license,
  ) async {
    String body = jsonEncode({'license': license, 'company_id': company.id});
    http.Response response = await http.post(
      Uri.parse('${config.apiBaseUrl}/License/EmployeeRequest'),
      headers: config.apiHeaders,
      body: body,
    );
    return jsonDecode(response.body);
  }

  static sort(List<License> documents) {
    documents.sort((b, a) => a.from.compareTo(b.from));
  }

  static List<License> filter(
    List<License> documents,
    int year,
    bool all,
    bool isPending,
    bool approved,
    bool rejected,
    //---------- BEGIN ----------//
    String type,
    //---------- FINISH ----------//
  ) {
    //---------- BEGIN ----------//
    List<License> filteredDocuments;
    //---------- FINISH ----------//
    if (all) {
      //---------- BEGIN ----------//
      filteredDocuments = documents.where((item) {
        return item.year == year;
      }).toList();
      //---------- FINISH ----------//
    } else {
      //---------- BEGIN ----------//
      filteredDocuments = documents
          //---------- FINISH ----------//
          .where(
            (item) =>
                item.year == year &&
                item.pending == isPending &&
                item.approved == approved &&
                item.rejected == rejected,
          )
          //---------- BEGIN ----------//
          .toList();
    }
    
    // Aplicar filtro de tipo
    if (type != 'Todos') {
      filteredDocuments = filteredDocuments
          .where((item) => item.name == type)
          .toList();
    }
    
    return filteredDocuments;
    //---------- FINISH ----------//
  }

  static Stream<DatabaseEvent> getStream(
    FirebaseDatabase db,
    Company company,
    Employee employee,
  ) {
    String ref = 'client/${company.id}/license';
    Query query =
        db.ref().child(ref).orderByChild('employee/id').equalTo(employee.id);
    query.keepSynced(true);
    return query.onValue;
  }
}
