part of employ.pages;

class IncomeDataStepTwo extends StatefulWidget {
  final Map<String, String>? stepTwoData;
  final ValueChanged<Map<String, String>?> onChanged;

  const IncomeDataStepTwo({this.stepTwoData, required this.onChanged});

  @override
  IncomeDataStepTwoState createState() => IncomeDataStepTwoState();
}

class IncomeDataStepTwoState extends State<IncomeDataStepTwo> {
  Map<String, String>? stepTwoData;

  @override
  void initState() {
    super.initState();
    stepTwoData = widget.stepTwoData ?? Map();
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
              file: stepTwoData?[target],
              fileName: target,
            ),
          ),
        ).then((data) {
          if (data != null) {
            stepTwoData?[target] =
                data['replace'] ? data['path'] : stepTwoData?[target];
            widget.onChanged(stepTwoData);
          }
        });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            image: stepTwoData?['selfie'],
            height: 300.0,
          ),
        ],
      ),
    );
  }
}
