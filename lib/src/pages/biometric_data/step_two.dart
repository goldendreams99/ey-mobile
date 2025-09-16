part of employ.pages;

class BiometricDataStepTwo extends StatefulWidget {
  final Map<String, String?> stepTwoData;
  final ValueChanged<Map<String, String?>> onChanged;
  final Key key;

  const BiometricDataStepTwo({
    required this.stepTwoData,
    required this.onChanged,
    this.key = const Key('dorso_page'),
  });

  @override
  BiometricDataStepTwoState createState() => BiometricDataStepTwoState();
}

class BiometricDataStepTwoState extends State<BiometricDataStepTwo> {
  late Map<String, String?> stepTwoData;

  @override
  void initState() {
    super.initState();
    stepTwoData = widget.stepTwoData;
  }

  Future<void> prepareCamera(String target, String title, int index) async {
    bool canOpenCamera = await canTakePicture(context);
    if (canOpenCamera) {
      List<CameraDescription> cameras = await availableCameras();
      if (cameras.length > 0)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmployCamera(
              cameras[index],
              title: title,
              file: stepTwoData[target],
              fileName: target,
            ),
          ),
        ).then((data) {
          if (data != null) {
            stepTwoData[target] =
                data['replace'] ? data['path'] : stepTwoData[target];
            widget.onChanged(stepTwoData);
          }
        });
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
              'Dorso Documento',
              style: FONT.TITLE.merge(
                TextStyle(color: COLOR.white, fontSize: 18.0),
              ),
            ),
          ),
          BiometricPictureModule(
            text: 'Dorso',
            onTap: (i) => prepareCamera('dorso', 'Dorso', i),
            image: stepTwoData['dorso'],
            height: calcSize(size, 230.0),
          ),
        ],
      ),
    );
  }
}
