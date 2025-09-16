part of employ.widgets;

class ChatItemFile extends StatefulWidget {
  final TicketChat item;
  final int index;
  final String ticketId;

  const ChatItemFile({
    required this.item,
    required this.index,
    required this.ticketId,
  });

  @override
  _ChatItemFileState createState() => _ChatItemFileState();
}

class _ChatItemFileState extends State<ChatItemFile> {
  String? path;
  bool downloading = false;
  bool isDownloaded = false;

  @override
  void initState() {
    super.initState();
    widget.item.isDownloaded(context,widget.ticketId).then((v) {
      isDownloaded = v != null;
      path = v;
      if (mounted) setState(() {});
    });
  }

  void openImage() {
    Vibration.vibrate(duration: 100);
    OpenFilex.open(path!);
  }

  void download() {
    Vibration.vibrate(duration: 100);
    downloading = true;
    if (mounted) setState(() {});
    widget.item.download(context,widget.ticketId).then((e) {
      path = e?.path;
      downloading = false;
      isDownloaded = path != null;
      if (mounted) setState(() {});
    }).catchError((e) {
      downloading = false;
      isDownloaded = false;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkResponse(
      onTap: downloading
          ? null
          : isDownloaded
              ? openImage
              : download,
      child: Container(
        width: size.width,
        margin: EdgeInsets.only(
          bottom: 6.0,
          top: widget.index == 0 ? 23.0 : 6.5,
        ),
        alignment: widget.item.me ? Alignment.topRight : Alignment.topLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: widget.item.me
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.75,
              ),
              padding: EdgeInsets.only(
                top: 11.0,
                bottom: 9.0,
                left: 18.8,
                right: 10.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11.0),
                color: widget.item.me
                    ? Color.fromRGBO(64, 144, 228, 1.0)
                    : COLOR.very_light_pink_eight,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(
                    Icons.insert_drive_file,
                    color: widget.item.me
                        ? COLOR.white
                        : COLOR.greyish_brown_seven,
                  ),
                  Expanded(
                    child: Container(
                      width: size.width * (isDownloaded ? 0.50 : 0.43),
                      child: Text(
                        widget.item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign:
                            widget.item.me ? TextAlign.right : TextAlign.left,
                        style: FONT.MEDIUM.merge(
                          TextStyle(
                            color: widget.item.me
                                ? COLOR.white
                                : COLOR.greyish_brown_seven,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (downloading)
                    SizedBox(
                      height: 24.0,
                      width: 24.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          COLOR.white,
                        ),
                      ),
                    )
                  else if (!isDownloaded)
                    IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.file_download,
                        color: COLOR.white,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 5.0,
                left: widget.item.me ? 0.0 : 20.0,
                right: widget.item.me ? 20.0 : 0.0,
              ),
              child: Text(
                widget.item.relative,
                textAlign: widget.item.me ? TextAlign.right : TextAlign.left,
                style: FONT.TITLE.merge(
                  TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(61, 61, 61, 1.0),
                    fontSize: 13.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
