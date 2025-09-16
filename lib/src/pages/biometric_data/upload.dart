part of employ.pages;

class BiometricDataUpload extends ConsumerStatefulWidget {
  final Map<String, String> steps;
  final double percentPeerItem;

  BiometricDataUpload._({
    required this.steps,
    required this.percentPeerItem,
  });

  factory BiometricDataUpload({
    required Map<String, String> steps,
  }) {
    int stepsSize = 2;
    if (steps['frontal'] != null) stepsSize++;
    if (steps['dorso'] != null) stepsSize++;
    if (steps['selfie'] != null) stepsSize++;
    return BiometricDataUpload._(
      steps: steps,
      percentPeerItem: (1 / stepsSize),
    );
  }

  @override
  _BiometricDataUploadState createState() => _BiometricDataUploadState();
}

class _BiometricDataUploadState extends ConsumerState<BiometricDataUpload> {
  double percent = 0.0;
  bool uploading = false;
  Map<String, dynamic> data = Map();
  bool faceId = false;

  @override
  void initState() {
    percent += widget.percentPeerItem;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted && !uploading) upload();
    });
  }

  @override
  Widget build(BuildContext context) {
    final manager = ref.watch(appProvider);
    final size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: STYLES.vGradient(theme: manager.settings!.theme),
          ),
          width: size.width,
          height: size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Guardando...',
                style: FONT.TITLE.merge(
                  TextStyle(
                    fontSize: 36.5,
                    color: COLOR.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 32.0),
                padding: EdgeInsets.symmetric(horizontal: 64.0),
                child: LinearProgressIndicator(
                  value: percent,
                  backgroundColor: COLOR.white.withOpacity(0.5),
                  valueColor: AlwaysStoppedAnimation<Color>(COLOR.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void load(
    String url,
    String target,
    AppState manager,
    AppNotifier notifier,
  ) async {
    if (mounted) {
      setState(() {
        data[target] = url;
        percent += widget.percentPeerItem;
      });
    }

    final provider = EmployProvider.of(context);
    final config = AppConfig.of(context);
    String ref = 'client/${manager.company!.id}/signature/';
    provider.database.setData(
        '$ref${manager.employee!.id}', widget.steps['signature_metadata']);
    if (percent >= 0.91) {
      data['status'] = manager.settings!.signBioApprove ? 1 : 0;
      String _ref =
          'client/${manager.company!.id}/employee/${manager.employee!.id}';
      provider.database.update('$_ref/signplify', data);
      notifier.hashPin(
          config, widget.steps['pin']!, manager.company!, manager.employee!);
      if (data['document_frontal'] != null &&
          data['selfie'] != null &&
          !faceId) {
        dynamic response = await notifier.faceRecognition(
            config, data['document_frontal'], data['selfie']);
        faceId = true;
        if (response != null)
          provider.database
              .update('$_ref/signplify', {'recognition': jsonDecode(response)});
      }
      Fluttertoast.showToast(
        msg: 'Firma biométrica creada',
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
      );
      Timer(Duration(milliseconds: 500), () {
        Application.router.navigateTo(
          context,
          Routes.home,
          replace: true,
          clearStack: true,
        );
      });
    }
  }

  void upload() {
    if (!uploading) {
      uploading = true;
      DateTime now = DateTime.now();
      data['created'] = now.millisecondsSinceEpoch;
      data['date_due'] = now.add(Duration(days: 730)).millisecondsSinceEpoch;
      generateUplodable(
          'frontal', 'document-font.jpg', 'document_frontal', true);
      generateUplodable('dorso', 'document-back.jpg', 'document_back', true);
      generateUplodable('selfie', 'selfie.jpg', 'selfie', true);
      generateUplodable(
          'signature_image', 'signature.png', 'signature_image', false);
    }
  }

  void generateUplodable(
      String step, String target, String referente, bool validate) {
    final manager = ref.read(appProvider);
    String path =
        'client/${manager.company!.id}/employee/signplify/${manager.employee!.id}';
    final provider = EmployProvider.of(context);
    if (!validate || (validate && widget.steps[step] != null))
      provider.storage?.upload(
        widget.steps[step]!,
        '$path/$target',
        (url) => load(
          url,
          referente,
          manager,
          ref.read(appProvider.notifier),
        ),
      );
  }
}
