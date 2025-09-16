part of employ.widgets;

class EmployCalendar extends StatefulWidget {
  final int monthCount;
  final int passCount;
  final EdgeInsets? padding;
  final Size size;

  const EmployCalendar({
    this.monthCount = 6,
    this.padding,
    this.passCount = 5,
    required this.size,
  }) : assert(monthCount >= passCount);

  @override
  _EmployCalendarState createState() => _EmployCalendarState();
}

class _EmployCalendarState extends State<EmployCalendar> {
  late PageController _controller;

  @override
  void initState() {
    final fraction = calcFraction(widget.size, (widget.size.width - 360)) - 1;
    _controller = PageController(
      initialPage: widget.passCount,
      keepPage: false,
      viewportFraction: 0.75 - fraction,
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 70.0,
                minWidth: constraints.maxWidth,
                maxHeight: constraints.maxHeight - 70.0,
                maxWidth: constraints.maxWidth,
              ),
              child: PageView.builder(
                itemCount: widget.monthCount + widget.passCount,
                scrollDirection: Axis.vertical,
                controller: _controller,
                itemBuilder: (context, index) {
                  DateTime month = DateTime(
                      now.year, (now.month - widget.passCount) + index, 1);
                  return Container(
                    child: CalendarMonth(
                      month: month,
                      maxWidth: constraints.maxWidth,
                    ),
                  );
                },
                pageSnapping: true,
              ),
            ),
          ],
        );
      },
    );
  }
}
