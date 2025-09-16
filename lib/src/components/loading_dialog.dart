part of employ.widgets;

class LoadingDialog {
  static Future<void> build(BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            titlePadding: EdgeInsets.all(0.0),
            contentPadding: EdgeInsets.all(0.0),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 120,
                  height: 120,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: COLOR.white,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Center(
                    child: LottieAnim(
                      duration: Duration(milliseconds: 3000),
                      path: 'assets/animation/dot_animation.json',
                      size: Size(90.0, 90.0),
                      itRepeatable: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
