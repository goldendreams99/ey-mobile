part of employ.widgets;

class ChatItemImage extends StatefulWidget {
  final TicketChat item;
  final int index;
  final String ticketId;

  const ChatItemImage({
    required this.item,
    required this.index,
    required this.ticketId,
  });

  @override
  _ChatItemImageState createState() => _ChatItemImageState();
}

class _ChatItemImageState extends State<ChatItemImage> {
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
    ImageProvider image;
    if (isDownloaded && path != null) {
      image = FileImage(File(path!));
    } else {
      image = NetworkImage(widget.item.fileUrl!);
    }
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
          crossAxisAlignment: widget.item.me
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 150.0,
              width: size.width * 0.75,
              alignment: Alignment.center,
              child: isDownloaded
                  ? null
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(11.0),
                      child: BackdropFilter(
                        filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Container(
                          height: 150.0,
                          width: size.width * 0.75,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: 150.0,
                            width: size.width * 0.75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11.0),
                              color: Color.fromRGBO(0, 0, 0, 0.2),
                            ),
                            alignment: Alignment.bottomRight,
                            padding: EdgeInsets.only(
                              bottom: 8.0,
                              right: 8.0,
                            ),
                            child: downloading
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      COLOR.white,
                                    ),
                                  )
                                : IconButton(
                                    onPressed: null,
                                    icon: Icon(
                                      Icons.file_download,
                                      color: COLOR.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11.0),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: image,
                ),
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
