part of employ.widgets;

class EmployExpenseCameraFooter extends StatelessWidget {
  final bool cameraMode;
  final bool editMode;
  final bool previewMode;
  final bool canSkip;
  final VoidCallback back;
  final VoidCallback delete;
  final VoidCallback confirm;
  final VoidCallback gallery;
  final VoidCallback takePicture;

  EmployExpenseCameraFooter({
    this.cameraMode = true,
    this.editMode = false,
    this.previewMode = false,
    this.canSkip = false,
    required this.back,
    required this.delete,
    required this.confirm,
    required this.gallery,
    required this.takePicture,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: editMode ? 3.0 : 16.0),
      child: editMode || previewMode
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FooterButton(
                  action: back,
                  icon: editMode
                      ? EmployIcons.btm_back_dark
                      : EmployIcons.btm_close_dark,
                  size: calcSize(size, 60.0),
                  theme: Brightness.light,
                ),
                FooterButton(
                  action: editMode ? confirm : delete,
                  icon: EmployIcons.btm_check_dark,
                  size: calcSize(size, 60.0),
                  theme: Brightness.light,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 20.0),
                  child: IconButton(
                    onPressed: gallery,
                    padding: EdgeInsets.all(0.0),
                    icon: Icon(
                      EmployIcons.gallery_1,
                      color: COLOR.white,
                      size: 30.0,
                    ),
                  ),
                ),
                FlatButton(
                  padding: EdgeInsets.all(0.0),
                  onPressed: takePicture,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(38.5),
                    ),
                  ),
                  child: Container(
                    height: 77.0,
                    width: 77.0,
                    decoration: BoxDecoration(
                      color: COLOR.brown_grey.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(38.5),
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      height: 57.0,
                      width: 57.0,
                      decoration: BoxDecoration(
                        color: COLOR.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                canSkip
                    ? InkWell(
                        onTap: () {
                          Application.router.pop(context);
                          Application.router.navigateTo(
                            context,
                            Routes.newExpense,
                            routeSettings: RouteSettings(
                              arguments: {'fromScanner': false},
                            ),
                          );
                        },
                        child: Container(
                          width: calcSize(size, 65.0),
                          height: calcSize(size, 65.0),
                          alignment: Alignment.center,
                          child: Text(
                            "Omitir",
                            style: FONT.TITLE.merge(
                              TextStyle(
                                  color: COLOR.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
    );
  }
}
