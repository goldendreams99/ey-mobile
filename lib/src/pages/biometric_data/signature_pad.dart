part of employ.pages;

class SignaturePadPage extends ConsumerStatefulWidget {
  final String? path;
  final ValueChanged<String?> callback;

  const SignaturePadPage({
    required this.path,
    required this.callback,
  });

  @override
  SignaturePadPageState createState() => SignaturePadPageState();
}

class SignaturePadPageState extends ConsumerState<SignaturePadPage> {
  GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  bool isSigned = false;
  bool startSign = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final settings = ref.watch(
      appProvider.select((value) => value.settings),
    );
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: STYLES.vGradient(theme: settings!.theme),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                alignment: Alignment.bottomLeft,
                height: calcSize(size, 116),
                width: size.width,
                padding: EdgeInsets.fromLTRB(22.0, 0.0, 12.0, 19.0),
                child: Text(
                  'Crea tu firma',
                  style: FONT.TITLE.merge(
                    TextStyle(color: COLOR.white, fontSize: 30.0),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Image.asset('assets/images/signature_limit.png'),
            ),
            if (!startSign && widget.path != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    SizedBox(height: calcSize(size, 116)),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.file(
                          File(widget.path!),
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            SfSignaturePad(
              key: _signaturePadKey,
              strokeColor: Colors.black,
              minimumStrokeWidth: 1,
              maximumStrokeWidth: 3,
              onDrawStart: () {
                startSign = true;
                setState(() {});
                return false;
              },
              onDrawEnd: () {
                isSigned = true;
              },
            ),
            if (loading)
              CircularProgressIndicator()
            else
              Positioned(
                bottom: padding.bottom,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.0),
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FooterButton(
                        action: onClear,
                        icon: EmployIcons.btm_close_dark,
                        size: calcSize(size, 60.0),
                        theme: Brightness.light,
                      ),
                      FooterButton(
                        action: onSavePng,
                        icon: EmployIcons.btm_next_dark,
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

  Future<ui.Image> _cropImage({
    required ui.Image originalImage,
    required double aspectRatio,
  }) async {
    ByteData byteData = (await originalImage.toByteData(
      format: ui.ImageByteFormat.png,
    ))!;
    Uint8List pngBytes = byteData.buffer.asUint8List();
    img.Image image = img.decodeImage(pngBytes)!;

    final coordinates = img.findTrim(image);
    double x = coordinates[0].toDouble();
    double y = coordinates[1].toDouble();
    double w = coordinates[2].toDouble();
    double h = coordinates[3].toDouble();
    double width;
    double height;
    if (w / aspectRatio < h) {
      width = h * aspectRatio;
      height = h;
    } else {
      width = w;
      height = w / aspectRatio;
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawImage(
      originalImage,
      Offset(
        -x + (width - w) / 2,
        -y + (height - h) / 2,
      ),
      Paint(),
    );
    return recorder.endRecording().toImage(
          width.toInt(),
          height.toInt(),
        );
  }

  Future<void> onSavePng() async {
    loading = true;
    setState(() {});
    try {
      bool can = await canWriteOnStorage(context);
      if (!can) return null;
      if (isSigned) {
        final pixelRatio = 3.0;
        ui.Image image = await _signaturePadKey.currentState!.toImage(
          pixelRatio: pixelRatio,
        );
        image = await _cropImage(
          originalImage: image,
          aspectRatio: 65 / 30,
        );
        var dir = await getApplicationSupportDirectory();
        final employDir = Directory('${dir.path}/Employ/Media');
        bool employExist = await employDir.exists();
        if (!employExist) await employDir.create(recursive: true);
        String id = Uuid().v1();
        File file = File('${employDir.path}/signature-$id.png');
        ByteData byteData = (await image.toByteData(
          format: ui.ImageByteFormat.png,
        ))!;
        Uint8List pngBytes = byteData.buffer.asUint8List();
        file = await file.writeAsBytes(pngBytes);
        widget.callback(file.path);
      } else {
        widget.callback(null);
      }
      Application.router.pop(context);
    } catch (e) {
      loading = false;
      setState(() {});
    }
  }

  void onClear() {
    isSigned = false;
    startSign = true;
    _signaturePadKey.currentState!.clear();
    setState(() {});
  }
}
