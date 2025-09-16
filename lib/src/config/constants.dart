part of employ.config;

const List<dynamic> relationships = [
  {'name': 'Madre'},
  {'name': 'Padre'},
  {'name': 'Herman@'},
  {'name': 'Ti@'},
  {'name': 'Prim@'},
];

const avatarList = [
  'bear',
  'buho',
  'cat',
  'coala',
  'cow',
  'fox',
  'frog',
  'jabali',
  'lion',
  'monkey',
  'mouse',
  'pig',
  'tiger',
];

const awardSentText = [
  'Reconocer es\nvalorar el esfuerzo',
  'Los resultados que consigues\nestarán en proporción directa\nal esfuerzo que aplicas',
  'Los líderes se hacen,\nno nacen',
  'Lo único que importa\nes el esfuerzo',
  'La felicidad está en la alegría\ndel logro y la emoción\ndel esfuerzo creativo',
  'Si uno no lo ha dado todo,\nno ha dado nada',
  'Mucho esfuerzo,\nmucha prosperidad',
  'Los logros de una organización\nson los resultados del\nesfuerzo combinado',
  'Es siempre el comienzo lo que\nrequiere el mayor esfuerzo',
  'El modo por el cual lo inevitable\nllega a pasar es el esfuerzo',
  'El sudor es la\ncolonia del logro',
  'El éxito depende\ndel esfuerzo',
  'Ganar no lo es todo,\npero el esfuerzo\npara ganar si',
  'El éxito es la suma\nde pequeños esfuerzos,\nrepetidos día tras día',
  'Lo que no se comienza hoy\nnunca se termina mañana',
  'Sacas lo mejor de los demás\ncuando das lo mejor de ti',
  'Uno nunca sabe de lo que es\ncapaz hasta que lo intenta',
  'Te das a ti mismo\ndando de ti mismo',
  'Te ganas la vida con lo\nque obtienes; haces una vida\ncon lo que das',
  'El significado de la vida\nes encontrar tu regalo.\nEl propósito en la vida es regalarlo',
  'La recompensa de una vida\neterna requiere esfuerzo',
  'Para cada esfuerzo disciplinado\nhay una recompensa múltiple',
  'Dar es mejor que recibir, porque el\nproceso de recibir empieza dando',
  'Un gran esfuerzo brota\nnaturalmente de una gran actitud',
  'La calidad nunca es un accidente.\nSiempre es resultado de un\nesfuerzo inteligente',
  'No existe gran talento\nsin gran voluntad',
  'La diferencia entre lo ordinario y\nlo extraordinario es\nese pequeño extra',
  'Cualquier esfuerzo resulta\nligero con el hábito',
  'Lo que se escribe sin esfuerzo\nsuele leerse sin placer',
  'El esfuerzo es lo que\nte hace grande',
  'Sigue así,\neres un gran referente!',
];

const List<String> months = [
  'Enero',
  'Febrero',
  'Marzo',
  'Abril',
  'Mayo',
  'Junio',
  'Julio',
  'Agosto',
  'Septiembre',
  'Octubre',
  'Noviembre',
  'Diciembre'
];
const List<String> weekDays = [
  'Dom',
  'Lun',
  'Mar',
  'Mié',
  'Jue',
  'Vie',
  'Sáb',
];

var kGoogleApiKey = Platform.isIOS
    ? 'AIzaSyDdtjCzMCECThQUndO6RO07-Kc4zHWtiCo'
    : 'AIzaSyBRzWg3t0usytVwx61wBZFiqRjc4UvrCU8';

Future<bool> checkPermission(BuildContext context, Permission value) async {
  PermissionStatus status = await value.status;
  if (status.isGranted) return true;
  status = await value.request();
  if (status.isPermanentlyDenied) {
    String permission = '-';
    if (value == Permission.camera) permission = 'cámara';
    if (value == Permission.microphone) permission = 'micrófono';
    if (value == Permission.photos) permission = 'fotos';
    if (value == Permission.videos) permission = 'videos';
    if (value == Permission.notification) permission = 'notificaciones';
    if (value == Permission.storage) permission = 'almacenamiento';

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Permisos denegados'),
          content: SingleChildScrollView(
            child: Text(
                'Por favor, otorgue los permisos necesarios de $permission '
                'en la configuración de la aplicación.'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Otorgar permisos'),
              onPressed: () async {
                await openAppSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return false;
  }
  return status.isGranted;
}

Future<bool> canWriteOnStorage(BuildContext context) async {
  bool videos = true;
  bool photos = true;
  bool storage = true;

  bool checked() => videos && photos && storage;

  if (Platform.isIOS || Platform.isMacOS) {
    storage = await checkPermission(context, Permission.storage);
    return checked();
  }

  AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
  if (androidInfo.version.sdkInt >= 33) {
    videos = await checkPermission(context, Permission.videos);
    photos = await checkPermission(context, Permission.photos);
    return checked();
  } else {
    storage = await checkPermission(context, Permission.storage);
    return checked();
  }
}

Future<bool> canTakePicture(BuildContext context) async {
  return checkPermission(context, Permission.camera);
}

Future<bool> canUserLocation(BuildContext context) async {
  return checkPermission(context, Permission.location);
}

/// todo remove
String fixedDocument =
    'https://firebasestorage.googleapis.com/v0/b/employ-6e9e6.appspot.com/o/client%2F-LOWU1aoeoCnJr24EqCY%2Femployee%2Fpaycheck%2F636967481287312383_2020060130303030.pdf?alt=media&token=8890f920-c372-4a4d-a7ae-0252e3b2d3d7';
