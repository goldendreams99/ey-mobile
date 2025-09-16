part of employ.pages;

class IncomeDataStepOne extends StatefulWidget {
  final Map<String, String>? stepOneData;
  final ValueChanged<Map<String, String>?> onChanged;

  const IncomeDataStepOne({this.stepOneData, required this.onChanged});

  @override
  IncomeDataStepOneState createState() => IncomeDataStepOneState();
}

class IncomeDataStepOneState extends State<IncomeDataStepOne> {
  Map<String, String>? stepOneData;

  @override
  void initState() {
    super.initState();
    stepOneData = widget.stepOneData ?? Map();
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
              file: stepOneData?[target],
              fileName: target,
            ),
          ),
        ).then((data) {
          if (data != null) {
            stepOneData?[target] =
                data['replace'] ? data['path'] : stepOneData?[target];
            widget.onChanged(stepOneData);
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
              'Cargar Documento de Identidad',
              style: FONT.TITLE.merge(
                TextStyle(color: COLOR.white, fontSize: 18.0),
              ),
            ),
          ),
          BiometricPictureModule(
            text: 'Frente',
            onTap: (i) => prepareCamera('frontal', 'Frente', i),
            image: stepOneData?['frontal'],
          ),
          BiometricPictureModule(
            text: 'Dorso',
            onTap: (i) => prepareCamera('dorso', 'Dorso', i),
            image: stepOneData?['dorso'],
          ),
        ],
      ),
    );
  }
}
