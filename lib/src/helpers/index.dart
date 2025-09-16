part of employ;

String getMiMeType(String extension) {
  String e = extension.toLowerCase();
  switch (e) {
    case 'gif':
    case 'png':
    case 'jpg':
    case 'jpeg':
    case 'pjpeg':
      return 'image/$e';
    case 'ico':
      return 'image/x-icon';
    case 'pdf':
      return 'application/pdf';
    case 'csv':
      return 'text/csv';
    case 'json':
      return 'application/json';
    default:
      return e;
  }
}

double calcSize(Size size, double value) {
  double width = size.height > size.width ? size.width : size.height;
  return (width / 360) * value;
}

double calcFraction(Size size, double value) {
  double width = size.height > size.width ? size.width : size.height;
  return (width / 360);
}

bool validateEmail(String email) {
  String emailPattern =
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$';
  RegExp regex = RegExp(emailPattern);
  return regex.hasMatch(email);
}

Future<LatLng?> getUserLocation() async {
  var currentLocation;
  final location = LocationManager.Location();
  try {
    currentLocation = await location.getLocation();
    final lat = currentLocation.latitude;
    final lng = currentLocation.longitude;
    final center = LatLng(lat, lng);
    return center;
  } catch (e) {
    currentLocation = null;
    return null;
  }
}

Future<String?> resolveLocationDialog(BuildContext context,
    {String hint = 'Escribe tu dirección'}) async {
  try {
    final TextEditingController controller = TextEditingController();
    String? result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Dirección'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text('Aceptar'),
          ),
        ],
      ),
    );
    return result?.isNotEmpty == true ? result : null;
  } catch (e) {
    print(e);
  }
  return null;
}

Future<File?> downloadFile(BuildContext context, String? url, String? name) async {
  try {
    bool can = await canWriteOnStorage(context);
    if (!can) return null;
    var dir = await getApplicationSupportDirectory();
    final employDir = Directory('${dir.path}/Employ/Test');
    bool employExist = await employDir.exists();
    if (!employExist) await employDir.create(recursive: true);
    File file = File('${employDir.path}/$name');
    bool isdownloaded = await file.exists();
    if (isdownloaded)
      return file;
    else {
      if (url == null) return null;
      var data = await http.get(Uri.parse(url));
      var bytes = data.bodyBytes;
      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    }
  } catch (e) {
    throw Exception("Error opening url file");
  }
}

void containerForSheet<T>(
    {required BuildContext context, required Widget child}) {
  showCupertinoModalPopup<T>(
    context: context,
    builder: (BuildContext context) => child,
  );
}

Widget renderDotLoading(Size size) {
  return Container(
    alignment: Alignment.center,
    height: size.height,
    width: size.width,
    color: Colors.transparent,
    child: SizedBox(
      width: calcSize(size, 160.0),
      height: calcSize(size, 160.0),
      child: LottieAnim(
        duration: Duration(milliseconds: 1500),
        path: 'assets/animation/dot_animation.json',
        size: Size(calcSize(size, 160.0), calcSize(size, 160.0)),
        itRepeatable: true,
      ),
    ),
  );
}

Container renderEmptyState(
  BuildContext context,
  ConnectionState state, [
  String emptyImage = 'assets/images/empty-state.png',
  String loader = 'assets/animation/dot_animation.json',
]) {
  final size = MediaQuery.of(context).size;
  return Container(
    alignment: Alignment.center,
    child: state == ConnectionState.active
        ? Image.asset(
            emptyImage,
            height: calcSize(size, 280.6),
            width: calcSize(size, 300.0),
          )
        : SizedBox(
            width: calcSize(size, 120.0),
            height: calcSize(size, 120.0),
            child: LottieAnim(
              duration: Duration(milliseconds: 3000),
              path: loader,
              size: Size(120.0, 120.0),
              itRepeatable: true,
            ),
          ),
  );
}

Future<Uint8List?> lienzoToPng(Rect paintBounds, List<Offset> points) async {
  var recorder = ui.PictureRecorder();
  var canvas = Canvas(recorder, paintBounds);

  Paint paint = Paint()
    ..color = Colors.black
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 2.5;

  for (int i = 0; i < points.length - 1; i++) {
    canvas.drawLine(points[i], points[i + 1], paint);
  }
  var picture = recorder.endRecording();
  var image = await picture.toImage(
      paintBounds.width.round(), paintBounds.height.round());
  ByteData? data = await image.toByteData(format: ui.ImageByteFormat.png);
  return data?.buffer.asUint8List();
}
