part of employ.data_model;

class EmployeeSignplify {
  final int status;
  final String frontal;
  final String dorso;
  final String selfie;
  final String signature;

  EmployeeSignplify({
    required this.status,
    required this.frontal,
    required this.dorso,
    required this.selfie,
    required this.signature,
  });

  EmployeeSignplify.fromJson(dynamic json)
      : status = json['status'],
        frontal = json['document_frontal'],
        dorso = json['document_back'],
        selfie = json['selfie'],
        signature = json['signature_image'];

  Map<String, dynamic> toJson() => {
        'status': status,
        'frontal': frontal,
        'dorso': dorso,
        'selfie': selfie,
        'signature': signature,
      };
}
