part of employ.widgets;

class SendFileDialog {
  static get buttonTextStyle => FONT.REGULAR.merge(
        TextStyle(
          fontSize: 13.0,
        ),
      );

  static Future<bool> build(
    BuildContext context,
    String fileName,
    String subjectName,
  ) async {
    Size size = MediaQuery.of(context).size;
    return await showDialog<bool>(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('¿Enviar el archivo a $subjectName?'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Container(
                    height: size.height * 0.070,
                    width: size.width * 0.20,
                    child: Center(
                      child: Text(
                        'Cancelar',
                        style: buttonTextStyle.merge(
                          TextStyle(color: COLOR.brown_grey_three),
                        ),
                      ),
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Container(
                    height: size.height * 0.070,
                    width: size.width * 0.20,
                    child: Center(
                      child: Text(
                        'Enviar',
                        style: buttonTextStyle.merge(
                          TextStyle(color: COLOR.dark_sky_blue),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
