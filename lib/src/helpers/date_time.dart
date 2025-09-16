import 'package:date_format/date_format.dart';

extension DateTimeExtension on DateTime {
  String get formattedDate => formatDate(this, [yyyy, '-', mm, '-', dd]);

  String get formattedYear => formatDate(this, [yyyy]);

  String get formattedMonth => formatDate(this, [mm]);

  String get formattedPeriod => formatDate(this, [yyyy, mm]);
}
