part of employ.widgets;

class ChatItemMessage extends StatelessWidget {
  final TicketChat item;
  final int index;

  const ChatItemMessage({
    required this.item,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      margin: EdgeInsets.only(
        bottom: 6.0,
        top: index == 0 ? 23.0 : 6.5,
      ),
      alignment: item.me ? Alignment.topRight : Alignment.topLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment:
            item.me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(
              maxWidth: size.width * 0.75,
            ),
            padding: EdgeInsets.only(
              top: 22.0,
              bottom: 22.0,
              left: 24.0,
              right: 24.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11.0),
              color: !item.me
                  ? COLOR.black.withOpacity(0.13)
                  : Color.fromRGBO(64, 144, 228, 1.0),
            ),
            child: Text(
              item.message ?? '',
              textAlign: item.me ? TextAlign.right : TextAlign.left,
              style: FONT.MEDIUM.merge(
                TextStyle(
                  color: item.me ? COLOR.white : COLOR.greyish_brown_seven,
                  fontSize: calcSize(size, 15.0),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 5.0,
              left: item.me ? 0.0 : 20.0,
              right: item.me ? 20.0 : 0.0,
            ),
            child: Text(
              item.relative,
              textAlign: item.me ? TextAlign.right : TextAlign.left,
              style: FONT.TITLE.merge(
                TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(61, 61, 61, 1.0),
                  fontSize: 13.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
