part of employ.pages;

class BiometricDataStepFour extends StatefulWidget {
  final Map<String, String?> stepFourData;
  final ValueChanged<Map<String, String?>> onChanged;
  final Key key;

  const BiometricDataStepFour({
    required this.stepFourData,
    required this.onChanged,
    this.key = const Key('signature_page'),
  });

  @override
  BiometricDataStepFourState createState() => BiometricDataStepFourState();
}

class BiometricDataStepFourState extends State<BiometricDataStepFour> {
  late Map<String, String?> stepFourData;

  @override
  void initState() {
    super.initState();
    stepFourData = {
      'signature': widget.stepFourData['signature_image'],
      'points': widget.stepFourData['signature_metadata'],
    };
  }

  void captureSignature() {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => SignaturePadPage(
          path: stepFourData['signature'],
          callback: generateSignature,
        ),
      ),
    );
  }

  void generateSignature(String? signature) {
    stepFourData = <String, String?>{
      'signature': signature,
      'points': null,
    };
    widget.onChanged(<String, String?>{
      'signature_image': signature,
      'signature_metadata': jsonEncode([]),
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 14.0),
            child: Text(
              'Firma',
              style: FONT.TITLE.merge(
                TextStyle(
                  color: COLOR.white,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          BiometricSignatureModule(
            text: 'Firma',
            onTap: captureSignature,
            image: stepFourData['signature'],
            height: calcSize(size, 300.0),
          ),
        ],
      ),
    );
  }
}
