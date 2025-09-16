part of employ.widgets;

class CalendarMonth extends StatelessWidget {
  final EdgeInsets padding;
  final double maxWidth;
  final DateTime month;
  final List<DateTime> days;
  final int initialPos;

  CalendarMonth._({
    required this.maxWidth,
    required this.month,
    this.padding = EdgeInsets.zero,
    required this.days,
    required this.initialPos,
  });

  factory CalendarMonth({
    required double maxWidth,
    required DateTime month,
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    DateTime newValue = DateTime(month.year, month.month + 1, 0);
    DateTime initValue = DateTime(month.year, month.month, 1);
    List<DateTime> days = List.generate(
      newValue.day,
      ((i) {
        DateTime day = DateTime(month.year, month.month, i + 1);
        return day;
      }),
    );
    return CalendarMonth._(
      maxWidth: maxWidth,
      month: initValue,
      padding: padding,
      days: days,
      initialPos: month.weekday,
    );
  }

  double get daySize {
    return ((maxWidth - padding.horizontal) / 7).floorToDouble();
  }

  double get margin {
    return initialPos == 7 ? 0 : initialPos * daySize;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final monIndex = month.month - 1;
    return Container(
      margin: EdgeInsets.only(top: 11.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 12.0),
            child: Text(
              '${months[monIndex]} ${month.year}',
              style: FONT.TITLE.merge(
                TextStyle(color: COLOR.white, fontSize: 21.0),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[]..addAll(
                  List.generate(
                    7,
                    (int i) {
                      return Container(
                        width: daySize,
                        alignment: Alignment.center,
                        child: Text(
                          weekDays[i].toUpperCase(),
                          style: FONT.TITLE.merge(
                            TextStyle(
                              color: COLOR.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ),
          ),
          Wrap(
            direction: Axis.horizontal,
            children: <Widget>[
              SizedBox(
                width: margin,
              )
            ]..addAll(
                days.map((day) {
                  return CalendarDay(day, daySize, calcSize(size, 44.0));
                }).toList(),
              ),
          ),
        ],
      ),
    );
  }
}
