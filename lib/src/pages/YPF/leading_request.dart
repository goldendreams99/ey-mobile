part of employ.pages;

class LeadingRequest extends ConsumerStatefulWidget {
  const LeadingRequest();

  @override
  _LeadingRequestState createState() => _LeadingRequestState();
}

class _LeadingRequestState extends ConsumerState<LeadingRequest> {
  var amountController;
  TextEditingController? observationController;
  FocusNode? amount;
  FocusNode? comments;

  @override
  void initState() {
    super.initState();
    amountController = MoneyMaskedTextController();
    observationController = TextEditingController();
    amount = FocusNode();
    comments = FocusNode();
  }

  @override
  void dispose() {
    amount?.dispose();
    comments?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(
      appProvider.select((value) => value.settings),
    );
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final bool showActions = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: STYLES.vGradient(theme: settings!.theme),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              height: size.height,
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          'Solicitud de Préstamo',
                          style: FONT.TITLE.merge(
                            TextStyle(fontSize: 30.0, color: COLOR.white),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          constraints: BoxConstraints(
                            maxHeight: constraints.maxHeight,
                            maxWidth: constraints.maxWidth,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                UnderlineTextField(
                                  height: calcSize(size, 51.0),
                                  controller: amountController,
                                  margin: EdgeInsets.symmetric(vertical: 20.0),
                                  label: '',
                                  autoFocus: true,
                                  hint: '45.90',
                                  color: COLOR.white,
                                  type: TextInputType.number,
                                  insidePadding:
                                      EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 9.0),
                                  decoration: Container(
                                    width: 30.0,
                                    height: 30.0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(
                                            color: COLOR.white, width: 2.8),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(EmployIcons.currency,
                                            size: 16.0, color: COLOR.white),
                                      ),
                                    ),
                                  ),
                                  align: TextAlign.end,
                                  style: textStyle,
                                  hintStyle: hintStyle,
                                  labelStyle: labelStyle,
                                  action: TextInputAction.next,
                                  onSubmit: (e) {
                                    amount?.unfocus();
                                    FocusScope.of(context)
                                        .requestFocus(comments);
                                  },
                                ),
                                Container(
                                  height: 30.0,
                                  margin: EdgeInsets.only(bottom: 13.0),
                                  child: Text(
                                    "Observaciones",
                                    style: FONT.TITLE.merge(
                                      TextStyle(
                                          color: COLOR.white, fontSize: 21.0),
                                    ),
                                  ),
                                ),
                                TextField(
                                  textInputAction: TextInputAction.done,
                                  controller: observationController,
                                  focusNode: comments,
                                  style: textStyle,
                                  maxLines: 4,
                                  onSubmitted: (e) {
                                    comments?.unfocus();
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 12.0,
                                    ),
                                    hintText: 'Mudanza',
                                    hintStyle: hintStyle,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14.0),
                                      borderSide: BorderSide(
                                          color: COLOR.white, width: 2.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14.0),
                                      borderSide: BorderSide(
                                        color: COLOR.white,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: padding.bottom + 10.0,
              child: showActions
                  ? Container(
                      width: size.width,
                      padding: EdgeInsets.symmetric(horizontal: 3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FooterButton(
                            action: close,
                            icon: EmployIcons.btm_close_dark,
                            size: calcSize(size, 60.0),
                            theme: Brightness.light,
                          ),
                          FooterButton(
                            action: send,
                            icon: EmployIcons.btm_send_dark,
                            size: calcSize(size, 60.0),
                            theme: Brightness.light,
                          ),
                        ],
                      ),
                    )
                  : Container(),
            )
          ],
        ),
      ),
    );
  }

  void close() {
    Application.router.pop(context);
  }

  void send() {
    if ((observationController?.text.isNotEmpty ?? false) &&
        observationController?.text != null &&
        amountController.text.isNotEmpty &&
        amountController.text != null)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DocumentFixed(
            title: 'Solicitud Préstamo',
            name: 'income_data_test.pdf',
            url: fixedDocument,
          ),
        ),
      );
  }

  TextStyle get hintStyle => FONT.REGULAR.merge(
        TextStyle(color: COLOR.white.withOpacity(0.5), fontSize: 20.0),
      );

  TextStyle get labelStyle => FONT.SEMIBOLD.merge(
        TextStyle(
          color: COLOR.very_light_pink_five,
          fontSize: 11.0,
        ),
      );

  TextStyle get textStyle => FONT.BOLD.merge(
        TextStyle(color: COLOR.white, fontSize: 21.0),
      );
}
