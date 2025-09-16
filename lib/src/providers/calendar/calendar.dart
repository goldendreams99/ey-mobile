import 'package:copy_with_extension/copy_with_extension.dart';

part 'calendar.g.dart';

@CopyWith()
class CalendarState {
  final DateTime? from;
  final DateTime? to;
  final bool period;

  CalendarState({
    this.from,
    this.to,
    required this.period,
  });
}
