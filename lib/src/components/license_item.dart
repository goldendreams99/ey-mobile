part of employ.widgets;

class LicenseItem extends StatelessWidget {
  final License item;
  final Function(License) watchDocument;

  const LicenseItem({
    required this.item,
    required this.watchDocument,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () => watchDocument(item),
      child: Container(
        width: size.width,
        height: calcSize(size, 80.0),
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
                  item.name,
                  style: FONT.TITLE.merge(
                    TextStyle(
                        color: COLOR.brownish_grey,
                        fontSize: calcSize(size, 18.0)),
                  ),
                ),
                SizedBox(
                  height: calcSize(size, 8.5),
                ),
                Text(
                  item.label,
                  style: FONT.TITLEMEDIUM.merge(
                    TextStyle(
                        color: COLOR.bluey_grey,
                        fontSize: calcSize(size, 15.0)),
                  ),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  item.relative,
                  style: FONT.TITLEMEDIUM.merge(
                    TextStyle(
                      color: COLOR.brownish_grey,
                      fontSize: calcSize(size, 14.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: calcSize(size, 8.5),
                ),
                Icon(
                  item.pending
                      ? Icons.done
                      : item.toSign
                          ? EmployIcons.warning
                          : item.rejected
                              ? Icons.clear
                              : Icons.done_all,
                  color: item.pending
                      ? COLOR.blue_grey
                      : item.toSign
                          ? Colors.amber
                          : item.rejected
                              ? COLOR.pink_red
                              : COLOR.bright_blue,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
