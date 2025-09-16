part of employ.pages;

class BiometricDataStepThree extends StatefulWidget {
  final Map<String, String?> stepThreeData;
  final ValueChanged<Map<String, String?>> onChanged;
  final Key key;

  const BiometricDataStepThree({
    required this.stepThreeData,
    required this.onChanged,
    this.key = const Key('selfie_page'),
  });

  @override
  BiometricDataStepThreeState createState() => BiometricDataStepThreeState();
}

class BiometricDataStepThreeState extends State<BiometricDataStepThree> {
  late Map<String, String?> stepThreeData;

  @override
  void initState() {
    super.initState();
    stepThreeData = widget.stepThreeData;
  }

  Future<void> prepareCamera(String target, String title, int index) async {
    bool canOpenCamera = await canTakePicture(context);
    if (canOpenCamera) {
      List<CameraDescription> cameras = await availableCameras();
      if (cameras.length > 0) {
        if (cameras.length == 1) {
          index = 0;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmployCamera(
              cameras[index],
              title: title,
              file: stepThreeData[target],
              fileName: target,
            ),
          ),
        ).then((data) {
          if (data != null) {
            stepThreeData[target] =
                data['replace'] ? data['path'] : stepThreeData[target];
            widget.onChanged(stepThreeData);
          }
        });
      }
    }
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
              'Selfie',
              style: FONT.TITLE.merge(
                TextStyle(color: COLOR.white, fontSize: 18.0),
              ),
            ),
          ),
          BiometricPictureModule(
            text: 'Selfie',
            onTap: (i) => prepareCamera('selfie', 'Selfie', i),
            image: stepThreeData['selfie'],
            height: calcSize(size, 300.0),
          ),
        ],
      ),
    );
  }
}
