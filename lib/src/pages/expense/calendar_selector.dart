part of employ.pages;

class ExpenseCalendar extends ConsumerStatefulWidget {
  final Function(CalendarState calendarState) onSelectDays;

  const ExpenseCalendar({required this.onSelectDays});

  @override
  _ExpenseCalendarState createState() => _ExpenseCalendarState();
}

class _ExpenseCalendarState extends ConsumerState<ExpenseCalendar> {
  TextStyle get disabledColor {
    return TextStyle(color: COLOR.white.withOpacity(0.17));
  }

  void selectDays() {
    CalendarState calendar = ref.read(calendarProvider);
    if (calendar.from == null) {
      Fluttertoast.showToast(
        msg: 'Seleccioná fecha',
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }
    widget.onSelectDays(calendar);
    close();
  }

  void close() {
    ref.invalidate(calendarProvider);
    Application.router.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final manager = ref.watch(appProvider);
    final padding = MediaQuery.of(context).padding;
    final size = MediaQuery.of(context).size;
    final provider = ref.watch(calendarProvider);
    final List<String> format = [dd, ' ', ' ', yyyy];
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              height: size.height,
              width: size.width,
              padding: EdgeInsets.fromLTRB(
                26.0,
                padding.top + 20.0,
                26.0,
                padding.bottom,
              ),
              decoration: BoxDecoration(
                gradient: STYLES.vGradient(theme: manager.settings!.theme),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      style: FONT.TITLE.merge(
                        TextStyle(color: COLOR.white, fontSize: 21.0),
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: provider.from == null
                              ? 'Desde'
                              : formatDate(
                                  provider.from!,
                                  List.from(format)
                                    ..insert(
                                      2,
                                      months[provider.from!.month - 1]
                                          .substring(0, 3),
                                    ),
                                ),
                          style: provider.from == null ? disabledColor : null,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(bottom: calcSize(size, 5.0)),
                      child: EmployCalendar(
                        monthCount: 12,
                        passCount: 3,
                        padding: EdgeInsets.zero,
                        size: size,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: padding.bottom + 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    FooterButton(
                      action: close,
                      icon: EmployIcons.btm_close_dark,
                      size: calcSize(size, 60.0),
                      theme: Brightness.light,
                    ),
                    InkResponse(
                      onTap: selectDays,
                      child: Container(
                        width: 60.0,
                        height: 60.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: COLOR.white, width: 3.6),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            EmployIcons.check,
                            color: COLOR.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
