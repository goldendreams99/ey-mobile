part of employ.pages;

class DocumentFixed extends ConsumerStatefulWidget {
  final String? name;
  final String? url;
  final String? title;

  const DocumentFixed({
    Key? key,
    this.name,
    this.url,
    this.title,
  }) : super(key: key);

  @override
  _DocumentDixedState createState() => _DocumentDixedState();
}

class _DocumentDixedState extends ConsumerState<DocumentFixed> {
  String? path;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final manager = ref.watch(appProvider);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: path != null
          ? InkResponse(
              onTap: sign,
              child: Container(
                height: calcSize(size, 53.0),
                width: calcSize(size, 166.0),
                padding: EdgeInsets.symmetric(horizontal: calcSize(size, 32.0)),
                decoration: BoxDecoration(
                  gradient: STYLES.dGradient(theme: manager.settings!.theme),
                  borderRadius: BorderRadius.circular(calcSize(size, 26.6)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Firmar",
                      style: FONT.TITLE.merge(
                        TextStyle(
                            color: COLOR.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 17.0),
                      ),
                    ),
                    Icon(EmployIcons.sign, size: 25.0, color: COLOR.white)
                  ],
                ),
              ),
            )
          : null,
      body: Container(
        height: size.height,
        width: size.width,
        color: COLOR.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SimpleAppBar(
              text: widget.title ?? widget.name ?? '',
              icon: Icons.share,
              onFilter: share,
              hasAction: path != null,
            ),
            Container(
              height: size.height - calcSize(size, 116),
              width: size.width,
              child: Stack(
                children: <Widget>[
                  (path != null)
                      ? PdfView(path)
                      : Container(
                          alignment: Alignment.center,
                          child: Container(
                            width: 150,
                            height: 150,
                            padding: EdgeInsets.all(10.0),
                            child: LottieAnim(
                              duration: Duration(milliseconds: 3000),
                              path: 'assets/animation/dot_animation.json',
                              size: Size(150.0, 150.0),
                              itRepeatable: true,
                            ),
                          ),
                        ),
                  Positioned(
                    top: 50.0,
                    right: 27.0,
                    child: path != null
                        ? Container(
                            height: 42.0,
                            width: 42.0,
                            decoration: BoxDecoration(
                                color: COLOR.very_light_pink,
                                borderRadius: BorderRadius.circular(8.8),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 14,
                                    color: COLOR.black_50,
                                    offset: Offset(0, 5),
                                    spreadRadius: -6,
                                  )
                                ]),
                            child: InkResponse(
                              onTap: openFile,
                              child: Icon(
                                EmployIcons.expand,
                                size: 19.0,
                                color: COLOR.very_light_pink_six,
                              ),
                            ),
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void share() {
    Vibration.vibrate(duration: 100);
    Share.shareXFiles([XFile(path!)]);
  }

  void openFile() {
    Vibration.vibrate(duration: 100);
    OpenFilex.open(path!);
  }

  @override
  void initState() {
    super.initState();
    downloadFile(context,widget.url, widget.name).then((File? file) {
      path = file?.path;
      if (mounted) setState(() {});
    });
  }

  void sign() async {
    final manager = ref.read(appProvider);
    final v = await SignDialog.build(context, manager.employee!.name);
    if (v != null) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }
}
