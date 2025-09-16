part of employ.widgets;

class ChatTextBar extends ConsumerStatefulWidget {
  final ValueChanged<TicketChat> send;
  final String subject;
  final String? ticketId;

  const ChatTextBar({
    required this.subject,
    required this.send,
    required this.ticketId,
  });

  @override
  _ChatTextBarState createState() => _ChatTextBarState();
}

class _ChatTextBarState extends ConsumerState<ChatTextBar> {
  late TextEditingController controller;
  bool canSend = false;
  bool uploading = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller.addListener(() {
      canSend = controller.text.isNotEmpty;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    return Container(
      color: COLOR.greyish_brown_four,
      height: 65.0 + padding.bottom,
      width: size.width,
      padding: EdgeInsets.fromLTRB(12.0, 9.0, 12.0, 9.0 + padding.bottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 21.0, right: 14.0),
              width: size.width * 0.8,
              height: 65.0,
              decoration: BoxDecoration(
                color: COLOR.very_light_pink_nine,
                borderRadius: BorderRadius.circular(35.0),
              ),
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: size.width * 0.63,
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        controller: controller,
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 9.0),
                          hintText: 'Escribe un mensaje...',
                        ),
                      ),
                    ),
                    if (widget.ticketId != null)
                      Positioned(
                        right: 0.0,
                        top: 0.0,
                        child: Container(
                          height: 50.0,
                          width: 56.0,
                          alignment: Alignment.centerRight,
                          child: uploading
                              ? Padding(
                                  padding: EdgeInsets.only(right: 2.0),
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      COLOR.black.withOpacity(0.2),
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: showAttachmentDialog,
                                  child: Container(
                                    height: 50.0,
                                    width: 56.0,
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      EmployIcons.plus,
                                      color: COLOR.black,
                                      size: 24.0,
                                    ),
                                  ),
                                ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
          InkResponse(
            borderRadius: BorderRadius.circular(20.0),
            onTap: send,
            child: Container(
              height: 60.0,
              width: 48.0,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Icon(
                EmployIcons.send_outline,
                color: COLOR.white.withOpacity(canSend ? 1.0 : 0.30),
                size: 27.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void send() {
    if (!canSend) return;
    widget.send(TicketChat(
      message: controller.text,
    ));
    controller.clear();
  }

  void findFile() async {
    try {
      bool canGenerate = await canWriteOnStorage(context);
      if (!canGenerate) return;
      final res = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (res?.files.isEmpty ?? true) return;
      if (res?.files.first.path == null) return;
      File file = File(res!.files.first.path!);
      if (file.existsSync()) processFile(file, true);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void findOnGallery() async {
    try {
      bool canGenerate = await canWriteOnStorage(context);
      if (!canGenerate) return;
      final res = await FilePicker.platform.pickFiles(type: FileType.image);
      if (res?.files.isEmpty ?? true) return;
      if (res?.files.first.path == null) return;
      File file = File(res!.files.first.path!);
      if (file.existsSync()) processFile(file, true);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Widget paintAction(String text, IconData icon, {double size = 24.0}) {
    final _size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 12.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 25.0,
            height: 25.0,
            alignment: Alignment.centerLeft,
            child: Icon(
              icon,
              color: Colors.blue,
              size: size,
            ),
          ),
          SizedBox(width: 10.0),
          Text(
            text,
            style: FONT.TITLEREGULAR.merge(
              TextStyle(color: COLOR.black, fontSize: calcSize(_size, 20.0)),
            ),
          ),
        ],
      ),
    );
  }

  void showAttachmentDialog() {
    containerForSheet<String>(
      context: context,
      child: CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child:
                paintAction('Cámara', EmployIcons.camera_outlined, size: 18.0),
            onPressed: () {
              Navigator.pop(context);
              Timer(Duration(milliseconds: 300), takePicture);
            },
          ),
          CupertinoActionSheetAction(
            child: paintAction('Galería', EmployIcons.gallery_outlined,
                size: 16.0),
            onPressed: () {
              Navigator.pop(context);
              Timer(Duration(milliseconds: 300), findOnGallery);
            },
          ),
          CupertinoActionSheetAction(
            child: paintAction('Documentos', EmployIcons.file, size: 20.0),
            onPressed: () {
              Navigator.pop(context);
              Timer(Duration(milliseconds: 300), findFile);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text('Cancelar'),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void takePicture() async {
    try {
      bool canStorage = await canWriteOnStorage(context);
      if (!canStorage) return;
      bool canGenerate = await canTakePicture(context);
      List<CameraDescription> cameras = await availableCameras();
      if (canGenerate) {
        Navigator.push<String?>(
          context,
          MaterialPageRoute(
            builder: (context) => CustomCamera(
              cameras[0],
              title: '',
            ),
          ),
        ).then((filePath) async {
          if (filePath != null) {
            File file = File(filePath);
            processFile(file, true);
          }
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void processFile(File file, bool fromCamera) async {
    uploading = true;
    if (mounted) setState(() {});
    final manager = ref.read(appProvider);
    final provider = EmployProvider.of(context);
    String name = file.path.split('/').last;
    String extension = file.path.split('.').last;
    String fileName = '${Uuid().v1()}.$extension';
    File? _file = await TicketChat.generateCopy(
      context,
      file,
      widget.ticketId!,
      fileName,
    );
    if (_file == null) return;
    String firebase = 'client/${manager.company!.id}/employee/ticket_attach';
    provider.storage?.upload(_file.path, '$firebase/$fileName', (url) {
      widget.send(TicketChat(
        fileMime: getMiMeType(extension),
        fileName: fileName,
        displayName: name,
        fileUrl: url,
      ));
    }).then((e) {
      uploading = false;
      if (mounted) setState(() {});
    });
  }
}
