part of employ.widgets;

class FixedListItem extends StatelessWidget {
  final String text;
  final String subText;
  final String tag;
  final Widget icon;
  final VoidCallback onView;

  const FixedListItem({
    required this.text,
    required this.subText,
    required this.tag,
    required this.icon,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onView,
      child: Container(
        width: size.width,
        height: calcSize(size, 85.7),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: COLOR.very_light_pink_three,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  text,
                  style: FONT.TITLE.merge(
                    TextStyle(color: COLOR.brownish_grey, fontSize: 17.0),
                  ),
                ),
                SizedBox(
                  height: calcSize(size, 14.5),
                ),
                Text(
                  subText,
                  style: FONT.MEDIUM.merge(
                    TextStyle(color: COLOR.bluey_grey, fontSize: 13.0),
                  ),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  tag,
                  style: FONT.MEDIUM.merge(
                    TextStyle(color: COLOR.brownish_grey, fontSize: 14.0),
                  ),
                ),
                SizedBox(
                  height: calcSize(size, 14.5),
                ),
                icon
              ],
            ),
          ],
        ),
      ),
    );
  }
}
