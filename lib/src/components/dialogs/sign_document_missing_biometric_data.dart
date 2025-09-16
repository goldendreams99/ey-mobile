part of employ.widgets;

class SignDocumentMissing {
  static void close(BuildContext context) {
    Application.router.pop(context);
  }

  static build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final settings = ref.read(appProvider).settings;
    final padding = MediaQuery.of(context).padding;
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        builder: (BuildContext _context) {
          return Container(
            width: size.width,
            height: calcSize(size, 250.0),
            decoration: BoxDecoration(
              gradient: STYLES.dGradient(theme: settings!.theme),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(32.0),
              ),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(36.0, 50.0, 36.0, 0.0),
                  child: Text(
                    'Para firmar documentos primero deberás generar tus credenciales',
                    textAlign: TextAlign.center,
                    style: FONT.TITLE.merge(
                      TextStyle(
                        color: COLOR.white,
                        fontSize: calcSize(size, 22.3),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: padding.bottom,
                      left: 3.0,
                      right: 3.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        FooterButton(
                          action: () {
                            Navigator.of(context).pop(false);
                          },
                          icon: EmployIcons.btm_close_dark,
                          size: calcSize(size, 60.0),
                          theme: Brightness.light,
                        ),
                        InkResponse(
                          onTap: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Container(
                            height: 60.0,
                            decoration: BoxDecoration(
                              color: COLOR.very_light_pink_eight,
                              borderRadius: BorderRadius.circular(32.5),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 20.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Crear datos biométricos",
                                  style: FONT.TITLE.merge(
                                    TextStyle(
                                      color: Color.fromRGBO(88, 88, 88, 1.0),
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Icon(
                                  EmployIcons.fingerprint,
                                  color: Color.fromRGBO(88, 88, 88, 1.0),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
