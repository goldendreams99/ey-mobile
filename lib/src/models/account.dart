part of employ.data_model;

class Account {
  final String id;
  final String employee;
  final String company;

  Account({
    required this.id,
    required this.employee,
    required this.company,
  });

  Account.fromJson(dynamic json)
      : id = json['id'],
        company = Map.from(json['client']).keys.first.toString(),
        employee =
            json['client'][Map.from(json['client']).keys.first]['employee_id'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'employee': employee,
        'company': company,
      };

  static Future<String?> getAccountMail(String user, AppConfig config) async {
    String? email;
    final uri = Uri.parse('${config.apiBaseUrl}UserPortal/GetUsername');
    http.Response response = await http.post(
      uri,
      body: jsonEncode({'username': user}),
      headers: config.apiHeaders,
    );
    if (response.statusCode == 200) {
      String resolveEmail = jsonDecode(response.body);
      if (validateEmail(resolveEmail)) {
        return email = resolveEmail;
      }
    }
    return email;
  }

  static Future<dynamic> validAccount(Database db, String id) async {
    final portalUser = await db.once('user_portal/$id');
    if (portalUser == null) return null;
    Account acc = Account.fromJson(portalUser);
    final company = await db.once('client/${acc.company}/company');
    if (company == null) return null;
    final employee =
        await db.once('client/${acc.company}/employee/${acc.employee}');
    if (employee == null) return null;
    return {'company': company, 'employee': employee};
  }
}
