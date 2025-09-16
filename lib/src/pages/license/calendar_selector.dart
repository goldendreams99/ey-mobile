part of employ.pages;

class LicenseCalendar extends ConsumerStatefulWidget {
  final Function onSelectDays;

  const LicenseCalendar(this.onSelectDays);

  @override
  _LicenseCalendarState createState() => _LicenseCalendarState();
}

class _LicenseCalendarState extends ConsumerState<LicenseCalendar> {
  TextStyle get disabledColor {
    return TextStyle(color: COLOR.white.withOpacity(0.17));
  }

  void selectDays() {
    final calendar = ref.read(calendarProvider);
    if (calendar.from == null) {
      Fluttertoast.showToast(
        msg: 'Seleccioná fecha desde',
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }
    if (calendar.to == null && calendar.period) {
      Fluttertoast.showToast(
        msg: 'Seleccioná fecha hasta',
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }
    calendar.period
        ? widget.onSelectDays([calendar.from, calendar.to])
        : widget.onSelectDays([calendar.from]);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        provider.from == null
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
                        style: FONT.TITLE
                            .merge(
                              TextStyle(color: COLOR.white, fontSize: 21.0),
                            )
                            .merge(
                                provider.from == null ? disabledColor : null),
                      ),
                      Text(
                        provider.to == null
                            ? 'Hasta'
                            : formatDate(
                          provider.to!,
                                List.from(format)
                                  ..insert(
                                    2,
                                    months[provider.to!.month - 1]
                                        .substring(0, 3),
                                  ),
                              ),
                        style: FONT.TITLE
                            .merge(
                              TextStyle(color: COLOR.white, fontSize: 21.0),
                            )
                            .merge(
                                provider.from == null ? disabledColor : null),
                      ),
                    ],
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
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
              bottom: padding.bottom,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.0),
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
                    FooterButton(
                      action: selectDays,
                      icon: EmployIcons.btm_check_dark,
                      size: calcSize(size, 60.0),
                      theme: Brightness.light,
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
