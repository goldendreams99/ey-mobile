part of employ.data_model;

class Company {
  final String id;
  final String certificateKey;
  final String country;
  final String language;
  final DateTime created;
  final String logoNavbarHr;
  final String logoNavbarPortal;

  Company({
    required this.id,
    required this.certificateKey,
    required this.country,
    required this.language,
    required this.created,
    required this.logoNavbarHr,
    required this.logoNavbarPortal,
  });

  Company.fromJson(dynamic json)
      : id = json['id'] ?? '',
        certificateKey = json['certificate_key'] ?? '',
        country = ((json['country'] ?? Map())['id']) ?? '',
        language = ((json['language'] ?? Map())['id']) ?? '',
        created = (json['created'] != null
                ? DateTime.tryParse(json['created'])
                : null) ??
            DateTime.now(),
        logoNavbarHr = json['logo_navbar_hr'] ?? '',
        logoNavbarPortal = json['logo_navbar_portal'] ?? '';

  dynamic signApiData() {
    return {'company_id': id, 'company_certificate_key': certificateKey};
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'certificateKey': certificateKey,
        'country': country,
        'language': language,
        'created': created.toIso8601String(),
        'logoNavbarHr': logoNavbarHr,
        'logoNavbarPortal': logoNavbarPortal,
      };
}
