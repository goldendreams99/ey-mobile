part of employ.pages;

class ExpenseScanner extends StatefulWidget {
  final String filePath;

  const ExpenseScanner(this.filePath);

  @override
  _ExpenseScannerState createState() => _ExpenseScannerState();
}

class _ExpenseScannerState extends State<ExpenseScanner> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Size? imageSize;
  dynamic scanResults;
  late File imageFile;
  // MLKit disabled for iOS build compatibility
  // final TextRecognizer recognizer =
  //     TextRecognizer(script: TextRecognitionScript.latin);
  List<Map<String, dynamic>> dates = [];
  List<Map<String, dynamic>> amounts = [];
  int selectedAmount = -1;
  int selectedDate = -1;
  List<String> format = [dd, '/', mm, '/', yyyy];

  @override
  void initState() {
    imageFile = File(widget.filePath);
    super.initState();
    getImageSize();
    scanImage();
  }

  @override
  void dispose() {
    // recognizer.close(); // MLKit disabled for iOS build
    super.dispose();
  }

  Future<void> getImageSize() async {
    final decodedImage = await decodeImageFromList(imageFile.readAsBytesSync());
    final imageSize =
        Size(decodedImage.width.toDouble(), decodedImage.height.toDouble());
    this.imageSize = imageSize;
    setState(() {});
  }

  Future<void> scanImage() async {
    scanResults = null;
    setState(() {});
    // MLKit disabled for iOS build - scanner not functional
    // Scanner functionality requires MLKit text recognition
    // which is incompatible with current iOS build setup
    return;
  }

  // MLKit disabled for iOS build
  // void processDates(TextElement? value) {
  //   // Implementation commented out
  // }

  // MLKit disabled for iOS build
  // void processAmounts(TextElement value) {
  //   // Implementation commented out
  // }

  void showAmount(int index) {
    selectedAmount = index;
    setState(() {});
  }

  void showDate(int index) {
    selectedDate = index;
    setState(() {});
  }

  // MLKit disabled for iOS build
  // Rect scaleRect(TextElement container) {
  //   // Implementation commented out
  // }

  void generateBottomSheet() {
    if (amounts.length > 0)
      ExpenseScannerDialog.build(_scaffoldKey, context, dates, amounts,
          showDate, showAmount, initStepper,
          selectedAmount: selectedAmount, selectedDate: selectedDate);
    else {
      Application.router.navigateTo(
        context,
        Routes.newExpense,
        transition: fluro.TransitionType.inFromBottom,
        routeSettings: RouteSettings(
          arguments: {
            'date': selectedDate != -1 ? dates[selectedDate]['date'] : null,
            'amount': selectedAmount != -1
                ? amounts[selectedAmount]['amount'].toString()
                : null,
            'file': imageFile.path,
            'fromScanner': true,
          },
        ),
      );
    }
  }

  void initStepper() {
    Application.router.pop(context); // Cerrar el bottomsheet
    Application.router.navigateTo(
      context,
      Routes.newExpense,
      routeSettings: RouteSettings(
        arguments: {
          'date': selectedDate != -1 ? dates[selectedDate]['date'] : null,
          'amount': selectedAmount != -1
              ? amounts[selectedAmount]['amount'].toString()
              : null,
          'file': imageFile.path,
          'fromScanner': true,
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // MLKit disabled - no position data available
    final amountPosition = Rect.zero;
    final datePosition = Rect.zero;
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          imageSize == null || scanResults == null
              ? Container(
                  color: COLOR.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      LottieAnim(
                        duration: Duration(milliseconds: 500),
                        path: 'assets/animation/dot_animation.json',
                        size: Size(size.width / 2, size.width / 2),
                        itRepeatable: true,
                      )
                    ],
                  ),
                )
              : Container(
                  constraints: BoxConstraints.expand(),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: Image.file(imageFile).image,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
        ]
          ..add(selectedDate != -1
              ? Positioned(
                  left: datePosition.left - 12.0,
                  top: datePosition.top - 5.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: COLOR.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(18.0),
                      border: Border.all(
                        width: 2.3,
                        color: Color.fromRGBO(40, 167, 162, 1.0),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child: Text(
                      formatDate(dates[selectedDate]['date'], format),
                      style: FONT.TITLE.merge(
                        TextStyle(
                          color: Color.fromRGBO(47, 47, 47, 1.0),
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                )
              : Container())
          ..add(selectedAmount != -1
              ? Positioned(
                  left: amountPosition.left - 12.0,
                  top: amountPosition.top - 5.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: COLOR.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(18.0),
                      border: Border.all(
                        width: 2.3,
                        color: Color.fromRGBO(155, 91, 202, 1.0),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child: Text(
                      '${amounts[selectedAmount]['amount']}',
                      style: FONT.TITLE.merge(
                        TextStyle(
                          color: Color.fromRGBO(47, 47, 47, 1.0),
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                )
              : Container())
          ..add(
            Positioned(
              bottom: 0.0,
              child: imageSize == null || scanResults == null
                  ? Container()
                  : Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: IconButton(
                        onPressed: generateBottomSheet,
                        icon: Icon(
                          EmployIcons.chevron_upward,
                          color: COLOR.white,
                          size: 20.0,
                        ),
                      ),
                    ),
            ),
          ),
      ),
    );
  }
}
