part of employ.widgets;

class EmployExpenseCameraHeader extends StatelessWidget {
  final bool onCamera;
  final bool editMode;
  final VoidCallback crop;
  final VoidCallback close;

  EmployExpenseCameraHeader({
    required this.onCamera,
    this.editMode = false,
    required this.crop,
    required this.close,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          onCamera || editMode
              ? InkResponse(
                  onTap: close,
                  child: Icon(
                    EmployIcons.close,
                    color: COLOR.white,
                    size: 32.0,
                  ),
                )
              : Container(
                  width: 31.4,
                ),
          Text(
            '',
            style: FONT.TITLE.merge(
              TextStyle(color: COLOR.white, fontSize: 30.0),
            ),
          ),
          editMode
              ? InkResponse(
                  onTap: crop,
                  child: Icon(
                    EmployIcons.crop,
                    color: COLOR.white,
                    size: 28.0,
                  ),
                )
              : Container(
                  width: 31.4,
                ),
        ],
      ),
    );
  }
}
