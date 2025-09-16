part of employ.widgets;

class RemoveExpenseDialog {
  static Future build(BuildContext context) async {
    Size size = MediaQuery.of(context).size;
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          child: Container(
            height: size.width * 0.50,
            padding: EdgeInsets.only(
                right: size.width * 0.044,
                left: size.width * 0.044,
                top: 16.0,
                bottom: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  LABEL.removeExpenseText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: COLOR.brownish_grey_four,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0,
                  ),
                ),
                Container(
                  width: size.width * 0.83,
                  height: size.width * 0.16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      OutlineButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        borderSide: BorderSide(
                          color: COLOR.very_light_pink_four,
                        ),
                        child: Container(
                          height: size.width * 0.13,
                          width: size.width * 0.20,
                          child: Center(
                            child: Text(
                              LABEL.cancel,
                              style: TextStyle(
                                color: COLOR.brown_grey_three,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 13.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      OutlineButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        borderSide: BorderSide(
                          color: COLOR.dark_sky_blue,
                        ),
                        child: Container(
                          height: size.width * 0.13,
                          width: size.width * 0.20,
                          child: Center(
                            child: Text(
                              LABEL.delete,
                              style: TextStyle(
                                color: COLOR.dark_sky_blue,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 13.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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

class RemoveLicenseDialog {
  static Future build(BuildContext context) async {
    Size size = MediaQuery.of(context).size;
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          child: Container(
            height: size.width * 0.50,
            padding: EdgeInsets.only(
                right: size.width * 0.044,
                left: size.width * 0.044,
                top: 16.0,
                bottom: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  LABEL.removeLicenseText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: COLOR.brownish_grey_four,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0,
                  ),
                ),
                Container(
                  width: size.width * 0.83,
                  height: size.width * 0.16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      OutlineButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        borderSide: BorderSide(
                          color: COLOR.very_light_pink_four,
                        ),
                        child: Container(
                          height: size.width * 0.13,
                          width: size.width * 0.20,
                          child: Center(
                            child: Text(
                              LABEL.cancel,
                              style: TextStyle(
                                color: COLOR.brown_grey_three,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 13.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      OutlineButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        borderSide: BorderSide(
                          color: COLOR.dark_sky_blue,
                        ),
                        child: Container(
                          height: size.width * 0.13,
                          width: size.width * 0.20,
                          child: Center(
                            child: Text(
                              LABEL.delete,
                              style: TextStyle(
                                color: COLOR.dark_sky_blue,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 13.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
