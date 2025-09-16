part of employ.pages;

class ExpenseView extends ConsumerStatefulWidget {
  final Expense expense;

  const ExpenseView({Key? key, required this.expense}) : super(key: key);

  @override
  _ExpenseViewState createState() => _ExpenseViewState();
}

class _ExpenseViewState extends ConsumerState<ExpenseView> {
  bool loading = true;
  List<File> files = [];
  List<Widget> renderableAttachment = [];

  @override
  void initState() {
    super.initState();
    widget.expense.downloadAttachments(context).then((attachments) async {
      files = attachments;
      renderableAttachment = await AttachmentHelper.render(files);
      loading = false;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final double imageSize = (size.width * 0.15);
    final double columnWidth = (size.width / 2) - 30.0;
    final manager = ref.watch(appProvider);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            LayoutBuilder(builder: (context, constraints) {
              return Container(
                height: constraints.maxHeight,
                width: size.width,
                decoration: BoxDecoration(
                  gradient: STYLES.vGradient(
                    theme: manager.settings!.theme,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: size.height,
                      width: size.width,
                      padding: EdgeInsets.only(
                        left: 30.0,
                        right: 30.0,
                        top: 36.0,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: padding.top + 22.0,
                              width: size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.expense.name ?? '-',
                                    style: FONT.TITLE.merge(
                                      TextStyle(
                                        color: COLOR.white,
                                        fontSize: 35.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 40.0, bottom: 20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: columnWidth,
                                        child: Text(
                                          'FECHA CARGA',
                                          style: subStyle,
                                        ),
                                      ),
                                      Container(
                                        width: columnWidth,
                                        child: Text(
                                          'CENTRO DE COSTO',
                                          style: subStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: columnWidth,
                                          child: Text(
                                            widget.expense.createdDateLabel ??
                                                '-',
                                            style: subTextStyle,
                                          ),
                                        ),
                                        Container(
                                          width: columnWidth,
                                          child: Text(
                                            widget.expense.costCenter?.name ??
                                                '-',
                                            style: subTextStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: columnWidth,
                                    child: Text(
                                      'IMPORTE',
                                      style: subStyle,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5.0),
                                    child: Container(
                                      width: size.width,
                                      child: RichText(
                                        text: TextSpan(
                                          children: <InlineSpan>[
                                            TextSpan(
                                              text: r'$' +
                                                  ' ${widget.expense.value?.toStringAsFixed(2)} ${widget.expense.currency?.name} ',
                                              style: subTextStyle,
                                            ),
                                            TextSpan(
                                              text:
                                                  '(${widget.expense.reimbursable ? 'Reembolsable' : 'No reembolsable'})',
                                              style: FONT.TITLE.merge(
                                                TextStyle(
                                                  color: COLOR.white,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15.0),
                                  Row(
                                    children: [
                                      Container(
                                        width: columnWidth,
                                        child: Text(
                                          'FECHA FACTURA',
                                          style: subStyle,
                                        ),
                                      ),
                                      if (widget.expense.client?.name != null &&
                                          manager.settings?.expenseClient ==
                                              true)
                                        Container(
                                          width: columnWidth,
                                          child: Text(
                                            'CLIENTE',
                                            style: subStyle,
                                          ),
                                        ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: columnWidth,
                                          child: Text(
                                            widget.expense.reportedDateLabel ??
                                                '-',
                                            style: subTextStyle,
                                          ),
                                        ),
                                        if (widget.expense.client?.name !=
                                                null &&
                                            manager.settings?.expenseClient ==
                                                true)
                                          Container(
                                            width: columnWidth,
                                            child: Text(
                                              widget.expense.client!.name ??
                                                  '-',
                                              style: subTextStyle,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (widget.expense.attachments?.isNotEmpty ?? false)
                              Container(
                                width: size.width,
                                margin: EdgeInsets.only(bottom: 15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'DOCUMENTOS',
                                      style: FONT.TITLE.merge(
                                        TextStyle(
                                          color: COLOR.white.withOpacity(0.78),
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 10.0,
                                        bottom: 10.0,
                                      ),
                                      width: calcSize(size, 90.0) * 3,
                                      height: calcSize(size, 95.0),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children:
                                              renderAttachments(imageSize),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (widget.expense.observation != null &&
                                (widget.expense.observation?.isNotEmpty ??
                                    false))
                              Container(
                                width: size.width,
                                margin: EdgeInsets.only(bottom: 20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'COMENTARIOS',
                                      style: subStyle,
                                    ),
                                    SizedBox(height: 5.0),
                                    Container(
                                      width: size.width,
                                      child: Text(
                                        widget.expense.observation ?? '',
                                        style: subTextStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (widget.expense.reply != null)
                              Container(
                                margin: EdgeInsets.only(bottom: 10.0),
                                width: size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('RESPUESTA', style: subStyle),
                                    Container(
                                      width: size.width,
                                      child: Text(
                                        widget.expense.reply!,
                                        style: subTextStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            Positioned(
              bottom: padding.bottom + 10.0,
              left: 16.0,
              child: Container(
                alignment: Alignment.bottomLeft,
                child: FooterButton(
                  action: () {
                    Application.router.pop(context);
                  },
                  icon: EmployIcons.btm_close_dark,
                  size: calcSize(size, 60.0),
                  theme: Brightness.light,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> renderAttachments(double imageSize) {
    if (widget.expense.attachments == null) return [];
    final size = MediaQuery.of(context).size;
    List<Widget> list = [];
    for (var i = 0; i < widget.expense.attachments!.length; i++) {
      list.insert(
        0,
        InkResponse(
          onTap: () => openAttachment(files[i]),
          child: Container(
            margin: EdgeInsets.only(right: 10.0),
            width: calcSize(size, 90.0),
            height: calcSize(size, 95.0),
            decoration: BoxDecoration(
              color: COLOR.white,
              borderRadius: BorderRadius.circular(9.0),
            ),
            child: loading
                ? Center(
                    child: SizedBox(
                      width: calcSize(size, 90.0),
                      height: calcSize(size, 90.0),
                      child: LottieAnim(
                        duration: Duration(milliseconds: 1500),
                        path: 'assets/animation/dot_animation.json',
                        size: Size(calcSize(size, 90.0), calcSize(size, 90.0)),
                        itRepeatable: true,
                      ),
                    ),
                  )
                : renderableAttachment[i],
          ),
        ),
      );
    }
    return list;
  }

  void openAttachment(File file) {
    Vibration.vibrate(duration: 100);
    OpenFilex.open(file.path);
  }

  TextStyle get subTextStyle {
    return FONT.TITLE.merge(
      TextStyle(
        color: COLOR.white,
        fontSize: 20.0,
      ),
    );
  }

  TextStyle get textStyle {
    return FONT.TITLE.merge(
      TextStyle(
        color: COLOR.brownish_grey,
        fontSize: 15.0,
      ),
    );
  }

  TextStyle get subStyle {
    return FONT.TITLE.merge(
      TextStyle(
        color: COLOR.white.withOpacity(0.78),
        fontSize: 15.0,
      ),
    );
  }

  Border get blockBorder {
    return Border(
      bottom: BorderSide(color: COLOR.very_light_pink_seven),
    );
  }
}
