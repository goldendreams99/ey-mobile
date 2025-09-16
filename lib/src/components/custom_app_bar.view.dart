part of employ.widgets;

class SimpleAppBarView extends StatelessWidget {
  final String text;
  const SimpleAppBarView({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: COLOR.white,
      constraints: BoxConstraints(
        minHeight: calcSize(size, 100),
        minWidth: size.width,
        maxWidth: size.width,
      ),
      padding: EdgeInsets.fromLTRB(0.0, 0, 12.0, 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () => Application.router.pop(context),
            child: Container(
              padding: EdgeInsets.only(left: 22.0, top: 15.0, bottom: 10.0),
              margin: EdgeInsets.only(right: 10.0),
              child: Icon(
                EmployIcons.chevron_left,
                color: COLOR.greyish_brown_five,
                size: 16.0,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 0.0, bottom: 5.0),
            width: calcSize(size, 274.0),
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: FONT.TITLE.merge(
                TextStyle(
                  fontSize: 22.0,
                ),
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
