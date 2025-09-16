part of employ.data_model;

class EmployeeBook {
  final String mail;
  final String phone;
  final String timeZone;

  EmployeeBook({
    required this.mail,
    required this.phone,
    required this.timeZone,
  });

  EmployeeBook.fromJson(dynamic json)
      : mail = json['mail'] ?? '',
        phone = json['phone'] ?? '',
        timeZone = json['phone_timezone'] ?? '';

  Map<String, dynamic> toJson() => {
        'mail': mail,
        'phone': phone,
        'timeZone': timeZone,
      };
}
