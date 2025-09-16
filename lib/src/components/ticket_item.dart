part of employ.widgets;

class TicketItem extends StatelessWidget {
  final Ticket item;
  final Function(Ticket) watchDocument;

  const TicketItem({
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
            Expanded(
              child: Container(
                width: calcSize(size, 220.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FONT.TITLEMEDIUM.merge(
                        TextStyle(
                            color: COLOR.bluey_grey,
                            fontSize: calcSize(size, 15.0)),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: calcSize(size, 86.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    item.relative,
                    textAlign: TextAlign.right,
                    style: FONT.TITLEMEDIUM.merge(
                      TextStyle(
                          color: COLOR.brownish_grey,
                          fontSize: calcSize(size, 14.0)),
                    ),
                  ),
                  SizedBox(
                    height: calcSize(size, 8.5),
                  ),
                  Icon(
                    item.open ? EmployIcons.unlock : EmployIcons.lock,
                    color: item.open
                        ? Color.fromRGBO(76, 175, 80, 1.0)
                        : Color.fromRGBO(233, 30, 99, 1.0),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
