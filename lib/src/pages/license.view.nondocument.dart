part of employ.pages;

class LicenseViewNonSignature extends ConsumerStatefulWidget {
  final License? license;
  final String? path;
  final Function? onSigned;
  final bool isRecently;

  const LicenseViewNonSignature({
    Key? key,
    this.license,
    this.path,
    this.onSigned,
    this.isRecently = false,
  }) : super(key: key);

  @override
  _LicenseViewNonSignatureState createState() =>
      _LicenseViewNonSignatureState();
}

class _LicenseViewNonSignatureState
    extends ConsumerState<LicenseViewNonSignature> {
  bool loading = true;
  List<dynamic> files = [];
  List<Widget> renderableAttachment = [];

  @override
  void initState() {
    super.initState();
    if (widget.isRecently)
      Timer(Duration(milliseconds: 200), () {
        openDocument();
      });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.license?.downloadAttachments(context).then((attachments) async {
        files = List.from(attachments ?? []).map((f) {
          return {'uploaded': true, 'file': f};
        }).toList();
        renderableAttachment = await AttachmentHelper.render(
          files.map((data) => data['file'] as File).toList(),
        );
        loading = false;
        if (mounted) setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final double columnWidth = (size.width / 2) - 30.0;
    final manager = ref.read(appProvider);
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
                        top: 50.0,
                      ),
                      child: Container(
                        height: constraints.maxHeight - 50.0,
                        width: size.width,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.license?.name ?? '',
                                style: FONT.TITLE.merge(
                                  TextStyle(
                                    color: COLOR.white,
                                    fontSize: 35.0,
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.only(top: 24.0, bottom: 20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: columnWidth,
                                          child: Text(
                                            'DESDE',
                                            style: subStyle,
                                          ),
                                        ),
                                        Container(
                                          width: columnWidth,
                                          child: Text(
                                            'HASTA',
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
                                              widget.license
                                                      ?.fromLabelRelative ??
                                                  '',
                                              style: subTextStyle,
                                            ),
                                          ),
                                          Container(
                                            width: columnWidth,
                                            child: Text(
                                              widget.license?.toLabelRelative ??
                                                  '',
                                              style: subTextStyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              (widget.license?.observation != null &&
                                      (widget.license?.observation.isNotEmpty ??
                                          false)
                                  ? Container(
                                      width: size.width,
                                      margin: EdgeInsets.only(bottom: 20.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'COMENTARIOS',
                                            style: subStyle,
                                          ),
                                          Container(
                                            width: size.width,
                                            child: Text(
                                              widget.license?.observation ?? '',
                                              style: subTextStyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container()),
                              (widget.license?.reply != null
                                  ? Container(
                                      margin: EdgeInsets.only(bottom: 10.0),
                                      width: size.width,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('RESPUESTA', style: subStyle),
                                          Container(
                                            width: size.width,
                                            child: Text(
                                              widget.license?.reply ?? '',
                                              style: subTextStyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container()),
                              (widget.license?.attachments != null &&
                                      (widget.license?.attachments.length ??
                                              0) >
                                          0
                                  ? Container(
                                      width: size.width,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 17.0, horizontal: 17.0),
                                      decoration: BoxDecoration(
                                        color: COLOR.black.withOpacity(0.13),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Adjuntos',
                                            style: FONT.TITLE.merge(
                                              TextStyle(
                                                color: COLOR.white,
                                                fontSize: 20.0,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 16.0, bottom: 10.0),
                                            width: calcSize(size, 90.0) * 3,
                                            height: calcSize(size, 95.0),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10.0),
                                                    child: InkResponse(
                                                      onTap: addAttachment,
                                                      child: Container(
                                                        width: calcSize(
                                                            size, 90.0),
                                                        height: calcSize(
                                                            size, 95.0),
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .transparent,
                                                          border: Border.all(
                                                            color: COLOR.white,
                                                            width: 2.4,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      6.0),
                                                        ),
                                                        child: Icon(
                                                          Icons.add,
                                                          size: 40.0,
                                                          color: COLOR.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ]..addAll(
                                                  renderAttachments(),
                                                  ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container()),
                              widget.license?.signRequired ?? false
                                  ? Container(
                                      margin: EdgeInsets.only(
                                          top: calcSize(size, 30.0)),
                                      alignment: Alignment.center,
                                      child: InkResponse(
                                        onTap: openDocument,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 15.0,
                                            horizontal: 25.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                255, 234, 234, 0.92),
                                            borderRadius:
                                                BorderRadius.circular(26.0),
                                          ),
                                          child: Text(
                                            "Ver documento",
                                            style: FONT.TITLE.merge(
                                              TextStyle(
                                                color: Color.fromRGBO(
                                                    84, 84, 84, 1.0),
                                                fontSize: 17.0,
                                              ),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            Positioned(
              bottom: padding.bottom,
              left: 3.0,
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

  void openDocument() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LicenseViewDocument(
            license: widget.license,
            path: widget.path,
            onSigned: widget.onSigned),
      ),
    );
  }

  List<Widget> renderAttachments() {
    final size = MediaQuery.of(context).size;
    List<Widget> list = [];
    for (var i = 0; i < files.length; i++) {
      list.insert(
        0,
        InkResponse(
          onTap: () => openAttachment(files[i]['file']),
          child: Container(
            margin: EdgeInsets.only(right: 10.0),
            width: calcSize(size, 90.0),
            height: calcSize(size, 95.0),
            decoration: BoxDecoration(
              color: COLOR.white,
              borderRadius: BorderRadius.circular(9.0),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                loading || !files[i]['uploaded']
                    ? Center(
                        child: SizedBox(
                          width: calcSize(size, 90.0),
                          height: calcSize(size, 90.0),
                          child: LottieAnim(
                            duration: Duration(milliseconds: 1500),
                            path: 'assets/animation/dot_animation.json',
                            size: Size(
                                calcSize(size, 90.0), calcSize(size, 90.0)),
                            itRepeatable: true,
                          ),
                        ),
                      )
                    : renderableAttachment[i],
              ],
            ),
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

  void addAttachment() async {
    try {
      AttachmentHelper.showAttachmentDialog(context, (File? file) {
        if (file?.path != null) {
          uploadFile(file!.path);
          if (mounted) setState(() {});
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void uploadFile(String path) async {
    final company = ref.read(appProvider).company;
    final storage = EmployProvider.of(context).storage;
    final db = EmployProvider.of(context).database;
    int index = files.length;
    files.add({'uploaded': false, 'file': File(path)});
    setState(() {});
    bool isDocument = path.toLowerCase().endsWith('.pdf');
    String name = path.substring(path.lastIndexOf('/') + 1);
    String refe = 'client/${company!.id}/employee/license_attach';
    String id = '${Uuid().v1()}.jpg';
    storage?.upload(
      path,
      '$refe/$id',
      (url) async {
        dynamic data = {
          'url': url,
          'name': name,
          'type': isDocument ? 'application/pdf' : 'image/jpg',
          'id': id,
        };
        String _ref = 'client/${company.id}/license/${widget.license?.id}';
        db.once(_ref).then((v) {
          List<dynamic> atts = List.from(v?['attachments'] ?? []);
          atts.add(data);
          db.update(_ref, {'attachments': List.from(atts)}).then((e) async {
            final image =
                await AttachmentHelper.fileToImageWidget(files[index]['file']);
            renderableAttachment.add(image);
            files[index]['uploaded'] = true;
            if (mounted) setState(() {});
          });
        });
      },
    );
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
