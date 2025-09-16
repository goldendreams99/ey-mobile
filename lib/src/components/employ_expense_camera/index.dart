part of employ.widgets;

class EmployExpenseCamera extends StatefulWidget {
  final CameraDescription camera;
  final bool canSkip;

  const EmployExpenseCamera(this.camera, {this.canSkip = false});

  @override
  _EmployExpenseCamera createState() => _EmployExpenseCamera();
}

class _EmployExpenseCamera extends State<EmployExpenseCamera>
    with WidgetsBindingObserver {
  CameraController? controller;
  bool cameraMode = true;
  bool previewMode = false;
  bool editMode = false;
  bool fromCamera = true;
  bool clean = false;
  String? uriPath;

  @override
  void initState() {
    cameraMode = true;
    initCamera();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (controller?.value.isInitialized != true) return;
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        instanceCamera();
      }
    }
  }

  void instanceCamera() async {
    if (controller == null) {
      controller = CameraController(
        widget.camera,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      controller?.addListener(() {
        if (mounted) setState(() {});
      });
      await controller?.initialize();
      await controller?.setFlashMode(FlashMode.off);
    } else if (controller?.value.isInitialized == false) {
      await controller?.initialize();
    }
  }

  Future<void> initCamera() async {
    cameraMode = true;
    setState(() {});
    instanceCamera();
    if (mounted) setState(() {});
  }

  void initGallery() async {
    Vibration.vibrate(duration: 100);
    if (controller != null) await controller?.dispose();
    final res = await FilePicker.platform.pickFiles(type: FileType.image);
    if (res?.files.isEmpty ?? true) {
      await initCamera();
    } else {
      uriPath = res?.files.first.path;
      cameraMode = false;
      editMode = true;
      fromCamera = false;
      setState(() {});
    }
  }

  Future<Null> initCrop() async {
    Vibration.vibrate(duration: 100);
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: uriPath!,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Editar Foto',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      uriPath = croppedFile.path;
      cameraMode = false;
      editMode = true;
      if (mounted) setState(() {});
    }
  }

  void take() async {
    Vibration.vibrate(duration: 100);
    setState(() {
      cameraMode = false;
      editMode = true;
      fromCamera = true;
    });
    String name = 'expense';
    String id = Uuid().v1();
    final String fileName = '$name-$id.jpg';
    final Directory extDir = await getTemporaryDirectory();
    final String dirPath = '${extDir.path}/Pictures/Employ';
    final bool dirExist = await Directory(dirPath).exists();
    if (!dirExist) await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/$fileName';
    if (controller?.value.isTakingPicture ?? true) return null;
    try {
      final res = await controller?.takePicture();
      await res?.saveTo(filePath);
      uriPath = filePath;
      setState(() {});
    } on CameraException catch (e) {
      debugPrint(e.description);
    }
  }

  void confirm() async {
    Vibration.vibrate(duration: 100);
    // File compressed = await FlutterNativeImage.compressImage(
    //   uriPath,
    //   quality: 90,
    //   percentage: 100,
    // );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ExpenseScanner(uriPath!),
      ),
    );
  }

  void back() {
    Vibration.vibrate(duration: 100);
    Navigator.of(context).pop();
  }

  void close() {
    Vibration.vibrate(duration: 100);
    Navigator.of(context).pop({'path': null, 'replace': clean});
  }

  void deletePicture() async {
    Vibration.vibrate(duration: 100);
    previewMode = false;
    cameraMode = true;
    uriPath = null;
    clean = true;
    await initCamera();
    setState(() {});
  }

  void returnToCamera() async {
    Vibration.vibrate(duration: 100);
    editMode = false;
    previewMode = false;
    uriPath = null;
    setState(() {});
    await initCamera();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          alignment: Alignment.topLeft,
          children: <Widget>[
            ((editMode || previewMode) && uriPath != null)
                ? Container(
                    width: size.width,
                    height: size.height,
                    decoration: BoxDecoration(
                      color: COLOR.black,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(uriPath!)),
                      ),
                    ),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(
                        sigmaX: 15.0,
                        sigmaY: 15.0,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(0.0),
                        height: size.height * 0.6,
                        width: size.width * 0.8,
                        color: Colors.transparent,
                        child: Image.file(
                          File(uriPath!),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  )
                : cameraMode &&
                controller?.value.isInitialized == true
                    ? Container(
              height: size.height,
                        width: size.width,
                        color: Colors.black,
                        constraints: BoxConstraints.expand(),
                        child: Transform.scale(
                          scale: 1 /
                              (controller!.value.aspectRatio *
                                  size.aspectRatio),
                          child: Center(
                            child: AspectRatio(
                              aspectRatio: 1 / controller!.value.aspectRatio,
                              child: CameraPreview(controller!),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        height: size.height,
                        width: size.width,
                        color: COLOR.black,
                      ),
            Positioned(
              top: 0.0,
              left: 0.0,
              child: Container(
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.3, 0.7, 1.0],
                    colors: [
                      COLOR.black_20,
                      Colors.transparent,
                      COLOR.black_20,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: padding.top + 20.0,
              child: EmployExpenseCameraHeader(
                onCamera: cameraMode,
                editMode: editMode,
                crop: initCrop,
                close: close,
              ),
            ),
            Positioned(
              bottom: padding.bottom + 10.0,
              child: EmployExpenseCameraFooter(
                cameraMode: cameraMode,
                editMode: editMode,
                previewMode: previewMode,
                back: previewMode ? close : returnToCamera,
                delete: deletePicture,
                confirm: confirm,
                gallery: initGallery,
                takePicture: take,
                canSkip: widget.canSkip,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
