part of employ.widgets;

class EmployCameraFooter extends StatelessWidget {
  final bool cameraMode;
  final bool editMode;
  final bool previewMode;
  final VoidCallback back;
  final VoidCallback delete;
  final VoidCallback confirm;
  final VoidCallback gallery;
  final VoidCallback takePicture;

  EmployCameraFooter({
    this.cameraMode = true,
    this.editMode = false,
    this.previewMode = false,
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
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: editMode || previewMode
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FooterButton(
                  action: back,
                  icon: EmployIcons.btm_back_dark,
                  size: calcSize(size, 60.0),
                  theme: Brightness.light,
                ),
                FooterButton(
                  action: previewMode ? delete : confirm,
                  icon: previewMode
                      ? EmployIcons.btm_close_dark
                      : EmployIcons.btm_check_dark,
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
                Container(width: calcSize(size, 65.0)),
              ],
            ),
    );
  }
}
