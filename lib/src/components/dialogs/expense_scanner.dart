part of employ.widgets;

class ExpenseScannerDialog {
  static void close(BuildContext context) {
    Application.router.pop(context);
  }

  static build(
    GlobalKey<ScaffoldState> key,
    BuildContext context,
    List<Map<String, dynamic>> dates,
    List<Map<String, dynamic>> amounts,
    ValueChanged<int> onChangeDate,
    ValueChanged<int> onChangeAmount,
    VoidCallback onContinue, {
    int? selectedAmount,
    int? selectedDate,
  }) {
    key.currentState?.showBottomSheet((context) {
      return ExpenseScannerDialogBody(
          dates, amounts, onChangeAmount, onChangeDate, onContinue,
          selectedAmount: selectedAmount, selectedDate: selectedDate);
    });
  }
}

class ExpenseScannerDialogBody extends StatefulWidget {
  final List<Map<String, dynamic>> dates;
  final List<Map<String, dynamic>> amounts;
  final ValueChanged<int> onChangeDate;
  final ValueChanged<int> onChangeAmount;
  final VoidCallback onContinue;
  final int? selectedAmount;
  final int? selectedDate;

  const ExpenseScannerDialogBody(
    this.dates,
    this.amounts,
    this.onChangeAmount,
    this.onChangeDate,
    this.onContinue, {
    this.selectedAmount,
    this.selectedDate,
  });

  @override
  _ExpenseScannerDialogBodyState createState() =>
      _ExpenseScannerDialogBodyState();
}

class _ExpenseScannerDialogBodyState extends State<ExpenseScannerDialogBody> {
  List<String> format = [dd, '/', mm, '/', yyyy];
  late int selectedAmount;
  late int selectedDate;

  @override
  void initState() {
    selectedAmount = widget.selectedAmount ?? -1;
    selectedDate = widget.selectedDate ?? -1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    return Container(
      height: calcSize(size, 318.0),
      padding: EdgeInsets.only(bottom: padding.bottom),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 50.0,
            height: 9.0,
            margin: EdgeInsets.only(bottom: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: COLOR.white,
            ),
          ),
          Container(
            width: size.width,
            color: COLOR.white,
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, padding.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    widget.dates.length > 0
                        ? Padding(
                            padding: EdgeInsets.only(bottom: 10.0, left: 20.0),
                            child: Text(
                              "Fecha",
                              style: FONT.TITLE.merge(
                                TextStyle(
                                  color: Color.fromRGBO(46, 46, 46, 1.0),
                                  fontSize: 26.0,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    widget.dates.length > 0
                        ? Container(
                            width: size.width,
                            height: calcSize(size, 60.0),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.dates.length,
                              shrinkWrap: true,
                              itemBuilder: (context, int index) {
                                dynamic current = widget.dates[index];
                                return EmployChip(
                                  name: formatDate(current['date'], format),
                                  selected: selectedDate == index,
                                  onSelected: (e) {
                                    selectedDate = index;
                                    setState(() {});
                                    widget.onChangeDate(index);
                                  },
                                  color: Color.fromRGBO(25, 183, 172, 1.0),
                                  gradient: STYLES.hGradient(
                                    colors: [
                                      Color.fromRGBO(25, 183, 172, 1.0),
                                      Color.fromRGBO(55, 152, 152, 1.0),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(),
                    widget.amounts.length > 0
                        ? Padding(
                            padding: EdgeInsets.only(bottom: 10.0, left: 20.0),
                            child: Text(
                              "Importe",
                              style: FONT.TITLE.merge(
                                TextStyle(
                                  color: Color.fromRGBO(46, 46, 46, 1.0),
                                  fontSize: 26.0,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    widget.amounts.length > 0
                        ? Container(
                            width: size.width,
                            height: calcSize(size, 60.0),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.amounts.length,
                              shrinkWrap: true,
                              itemBuilder: (context, int index) {
                                dynamic current = widget.amounts[index];
                                return EmployChip(
                                  name: current['amount'].toStringAsFixed(2),
                                  selected: selectedAmount == index,
                                  onSelected: (e) {
                                    selectedAmount = index;
                                    setState(() {});
                                    widget.onChangeAmount(index);
                                  },
                                  color: Color.fromRGBO(156, 88, 201, 1.0),
                                  gradient: STYLES.hGradient(
                                    colors: [
                                      Color.fromRGBO(149, 117, 205, 1.0),
                                      Color.fromRGBO(161, 67, 198, 1.0),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.0),
            color: COLOR.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FooterButton(
                  action: () {
                    Application.router.pop(context);
                    Application.router.pop(context);
                  },
                  icon: EmployIcons.btm_close_dark,
                  size: calcSize(size, 60.0),
                  theme: Brightness.dark,
                ),
                FooterButton(
                  action: widget.onContinue,
                  icon: EmployIcons.btm_check_dark,
                  size: calcSize(size, 60.0),
                  theme: Brightness.dark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
