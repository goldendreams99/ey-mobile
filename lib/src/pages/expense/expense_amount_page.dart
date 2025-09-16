part of employ.pages;

class ExpenseAmountPage extends ConsumerStatefulWidget {
  final String? amount;

  const ExpenseAmountPage({this.amount, Key? key}) : super(key: key);

  @override
  ExpenseAmountPageState createState() => ExpenseAmountPageState();
}

class ExpenseAmountPageState extends ConsumerState<ExpenseAmountPage> {
  final tController = MoneyMaskedTextController(
    initialValue: 0.0,
    decimalSeparator: ',',
    thousandSeparator: '.',
    precision: 2,
  );
  final node = FocusNode();

  @override
  void initState() {
    if (widget.amount != null) {
      tController.updateValue(double.parse(widget.amount!));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final settings = ref.watch(
      appProvider.select((value) => value.settings),
    );
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: STYLES.vGradient(theme: settings!.theme),
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: calcSize(size, 96),
              width: size.width,
              padding: EdgeInsets.fromLTRB(22.0, 0, 16.0, 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Importe',
                    style: FONT.TITLE.merge(
                      TextStyle(fontSize: 30.0, color: COLOR.white),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: NonBorderTextField(
                height: calcSize(size, 51.0),
                controller: tController,
                margin: EdgeInsets.symmetric(vertical: 10.0),
                node: node,
                autoFocus: true,
                hint: '0.00',
                hintStyle: FONT.TITLE.merge(
                  TextStyle(
                    color: COLOR.white.withOpacity(0.13),
                    fontSize: 24.0,
                  ),
                ),
                type: TextInputType.number,
                insidePadding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 9.0),
                align: TextAlign.right,
                style: FONT.TITLE.merge(
                  TextStyle(
                    color: COLOR.white,
                    fontSize: 24.0,
                  ),
                ),
              ),
            ),
            Spacer(),
            Container(
              width: size.width,
              color: COLOR.greyish_brown_four,
              padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FooterButton(
                    action: () {
                      node.unfocus();
                      Timer(Duration(milliseconds: 200), () {
                        Application.router.pop(context);
                      });
                    },
                    icon: EmployIcons.btm_close_dark,
                    size: calcSize(size, 60.0),
                    theme: Brightness.light,
                  ),
                  FooterButton(
                    action: () {
                      node.unfocus();
                      Navigator.of(context)
                          .pop(tController.numberValue.toString());
                    },
                    icon: EmployIcons.btm_check_dark,
                    size: calcSize(size, 60.0),
                    theme: Brightness.light,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
