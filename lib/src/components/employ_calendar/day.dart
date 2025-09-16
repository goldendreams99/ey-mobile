part of employ.widgets;

class CalendarDay extends ConsumerWidget {
  final DateTime day;
  final double width;
  final double height;

  const CalendarDay(this.day, this.width, [this.height = 47.0]);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarNotifier = ref.read(calendarProvider.notifier);
    final isFrom = calendarNotifier.isFrom(day);
    final circle = calendarNotifier.isOnly();
    final isToday = calendarNotifier.isToday(day);
    final isTo = calendarNotifier.isTo(day);
    final isChoice = calendarNotifier.isSelected(day);
    return InkResponse(
      onTap: () {
        Vibration.vibrate(duration: 100);
        calendarNotifier.select(day);
      },
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        child: Container(
          alignment: Alignment.center,
          height: height - 6.0,
          width: width,
          decoration: isToday && !isChoice
              ? BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: COLOR.white, width: 2.3),
                  ),
                )
              : isChoice
                  ? circle
                      ? BoxDecoration(
                          border: Border.all(color: COLOR.white, width: 2.3),
                          borderRadius: BorderRadius.circular(width / 2),
                        )
                      : ShapeDecoration(
                          shape: isFrom
                              ? fromBorder
                              : isTo
                                  ? toBorder
                                  : betweenBorder,
                        )
                  : null,
          child: Text(
            '${day.day}',
            style: isChoice || (isToday && !isChoice) ? enabled : disabled,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  TextStyle get disabled {
    return FONT.TITLE.merge(
      TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 21.0),
    );
  }

  TextStyle get enabled {
    return FONT.TITLE.merge(
      TextStyle(color: Colors.white, fontSize: 21.0),
    );
  }

  BorderSide get border {
    return BorderSide(color: COLOR.white, width: 2.3);
  }

  BorderSide get borderNone {
    return BorderSide(color: Colors.transparent, width: 2.3);
  }

  CustomRoundedRectangleBorder get fromBorder {
    return CustomRoundedRectangleBorder(
      topSide: border,
      bottomSide: border,
      topLeftCornerSide: border,
      bottomLeftCornerSide: border,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(0.0),
        topLeft: Radius.circular(width * 0.45),
        bottomRight: Radius.circular(0.0),
        bottomLeft: Radius.circular(width * 0.42),
      ),
    );
  }

  CustomRoundedRectangleBorder get toBorder {
    return CustomRoundedRectangleBorder(
      topSide: border,
      bottomSide: border,
      topRightCornerSide: border,
      bottomRightCornerSide: border,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(0.0),
        topRight: Radius.circular(width * 0.45),
        bottomLeft: Radius.circular(0.0),
        bottomRight: Radius.circular(width * 0.42),
      ),
    );
  }

  CustomRoundedRectangleBorder get betweenBorder {
    return CustomRoundedRectangleBorder(
      topSide: border,
      bottomSide: border,
    );
  }
}
