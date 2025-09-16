part of employ;

class AttachmentHelper {
  static Future<File?> findOnGallery(BuildContext context) async {
    try {
      bool canGenerate = await canWriteOnStorage(context);
      if (!canGenerate) return null;
      final res = await FilePicker.platform.pickFiles(type: FileType.image);
      if (res?.files.isEmpty ?? true) return null;
      if (res?.files.first.path == null) return null;
      File file = File(res!.files.first.path!);
      if (file.existsSync()) {
        return file;
      }
      return null;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  static Future<File?> findFile(BuildContext context) async {
    try {
      bool canGenerate = await canWriteOnStorage(context);
      if (!canGenerate) return null;
      final res = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (res?.files.isEmpty ?? true) return null;
      if (res?.files.first.path == null) return null;
      File file = File(res!.files.first.path!);
      if (file.existsSync()) return file;
      return null;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  static Future<dynamic> takePicture(BuildContext context) async {
    try {
      bool canStorage = await canWriteOnStorage(context);
      if (!canStorage) return null;
      bool canGenerate = await canTakePicture(context);
      List<CameraDescription> cameras = await availableCameras();
      if (canGenerate) {
        String? filePath = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomCamera(cameras[0], title: ''),
          ),
        );
        if (filePath != null) {
          File file = File(filePath);
          return file;
        } else
          return null;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static void showAttachmentDialog(
    BuildContext context,
    ValueChanged<File> onSelect,
  ) async {
    containerForSheet(
      context: context,
      child: CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: paintAction(
              context,
              'Cámara',
              EmployIcons.camera_outlined,
              size: 18.0,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Timer(Duration(milliseconds: 300), () async {
                File file = await takePicture(context);
                onSelect(file);
              });
            },
          ),
          CupertinoActionSheetAction(
            child: paintAction(context, 'Galería', EmployIcons.gallery_outlined,
                size: 16.0),
            onPressed: () {
              Navigator.of(context).pop();
              Timer(Duration(milliseconds: 300), () async {
                final file = await findOnGallery(context);
                if (file != null) {
                  onSelect(file);
                }
              });
            },
          ),
          CupertinoActionSheetAction(
            child: paintAction(context, 'Documentos', EmployIcons.file,
                size: 20.0),
            onPressed: () {
              Navigator.of(context).pop();
              Timer(Duration(milliseconds: 300), () async {
                final file = await findFile(context);
                if (file != null) {
                  onSelect(file);
                }
              });
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text('Cancelar'),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  static Widget paintAction(BuildContext context, String text, IconData icon,
      {double size = 24.0}) {
    final _size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 12.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 25.0,
            height: 25.0,
            alignment: Alignment.centerLeft,
            child: Icon(
              icon,
              color: Colors.blue,
              size: size,
            ),
          ),
          SizedBox(width: 10.0),
          Text(
            text,
            style: FONT.TITLEREGULAR.merge(
              TextStyle(color: COLOR.black, fontSize: calcSize(_size, 20.0)),
            ),
          ),
        ],
      ),
    );
  }

  static Future<Widget> fileToImageWidget(File file) async {
    bool isDocument = file.path.toLowerCase().endsWith('.pdf');
    DecorationImage? image;
    if (isDocument) {
      PdfDocument doc = await PdfDocument.openFile(file.path);
      PdfPage page = await doc.getPage(1);
      PdfPageImage pageImage = await page.render();
      await pageImage.createImageIfNotAvailable();
      final rawImage = RawImage(
        image: pageImage.imageIfAvailable,
        fit: BoxFit.contain,
      );
      final byteData = await rawImage.image?.toByteData(
        format: ui.ImageByteFormat.png,
      );
      image = byteData != null
          ? DecorationImage(
              image: MemoryImage(byteData.buffer.asUint8List()),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            )
          : null;
    } else {
      image = DecorationImage(
        image: FileImage(file),
        fit: BoxFit.cover,
        alignment: Alignment.center,
      );
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9.0),
        image: image,
      ),
    );
  }

  static Future<List<Widget>> render(List<File> files) async {
    return Future.wait(
      files.map((e) => fileToImageWidget(e)).toList(),
    );
  }
}
