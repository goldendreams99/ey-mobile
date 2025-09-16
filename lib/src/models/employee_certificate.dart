part of employ.data_model;

class EmployeeCertificate {
  final DateTime? dueDate;
  final String? key;
  final int? status;
  final String? type;

  EmployeeCertificate({
    required this.dueDate,
    required this.key,
    required this.status,
    required this.type,
  });

  EmployeeCertificate.fromJson(dynamic json)
      : dueDate = json['date_due'] != null
            ? DateTime.tryParse(json['date_due'])
            : null,
        key = json['key'],
        status = json['status'],
        type = json['type'];

  Map<String, dynamic> toJson() => {
        'dueDate': dueDate?.toIso8601String(),
        'key': key,
        'status': status,
        'type': type,
      };

  bool get valid {
    return dueDate != null && (dueDate?.isAfter(DateTime.now()) ?? false);
  }
}
