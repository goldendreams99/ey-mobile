part of employ.pages;

class LicenseAddStepTwo extends ConsumerStatefulWidget {
  final dynamic stepTwoData;
  final ValueChanged<Map<dynamic, dynamic>> onChanged;

  const LicenseAddStepTwo({
    this.stepTwoData,
    required this.onChanged,
  });

  @override
  LicenseAddStepTwoState createState() => LicenseAddStepTwoState();
}

class LicenseAddStepTwoState extends ConsumerState<LicenseAddStepTwo> {
  dynamic stepTwoData;
  bool editMode = false;
  List<String> attachments = [];
  List<Widget> renderableAttachment = [];
  late TextEditingController commentControl;

  @override
  void initState() {
    super.initState();
    stepTwoData = widget.stepTwoData ?? {};
    commentControl = TextEditingController(
      text: stepTwoData['observation'] ?? '',
    );
    attachments = List.from(stepTwoData['attachments'] ?? []);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      renderableAttachment = await AttachmentHelper.render(
          attachments.map((e) => File(e)).toList());
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double imageSize = (size.width * 0.25);
    final manager = ref.watch(appProvider);
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: COLOR.black.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 11.35),
                child: TextField(
                  controller: commentControl,
                  style: inputStyle,
                  maxLength: 140,
                  maxLines: 4,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(140),
                  ],
                  textInputAction: TextInputAction.done,
                  onChanged: (text) {
                    dynamic value = Map.from(stepTwoData);
                    value['observation'] = text;
                    stepTwoData = Map.from(value);
                    widget.onChanged(stepTwoData);
                  },
                  decoration: InputDecoration(
                      hintStyle: inputStyle.merge(
                        TextStyle(
                          color: COLOR.white.withOpacity(0.4),
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 18.0,
                      ),
                      hintText: 'Observaciones',
                      border: InputBorder.none,
                      counterText: ""),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: COLOR.black.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(5.0)),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 11.35),
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 35.0,
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Adjuntos',
                          style: inputStyle,
                        ),
                        attachments.length > 0
                            ? InkResponse(
                                onTap: onEditMode,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 15.0),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    color: COLOR.white,
                                  ),
                                  child: Text(
                                    (editMode ? 'Cancelar' : 'Editar')
                                        .toUpperCase(),
                                    style: FONT.TITLE.merge(
                                      TextStyle(
                                        color: COLOR.gradient[
                                            manager.settings!.theme]![0],
                                        fontSize: 13.0,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16.0, bottom: 10.0),
                    child: Row(
                      children: <Widget>[
                        InkResponse(
                          onTap: showAttachmentDialog,
                          child: Container(
                            width: imageSize,
                            height: imageSize,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: COLOR.white,
                                width: 2.4,
                              ),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Icon(
                              Icons.add,
                              size: 40.0,
                              color: COLOR.white,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.0),
                          width: size.width - (imageSize + 70),
                          height: imageSize,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: renderAttachments(imageSize),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onEditMode() {
    editMode = !editMode;
    setState(() {});
  }

  void processFile(File? file) async {
    if (file != null) {
      final image = await AttachmentHelper.fileToImageWidget(file);
      renderableAttachment.add(image);
      attachments.add(file.path);
      dynamic value = Map.from(stepTwoData);
      value['attachments'] = List.from(attachments);
      stepTwoData = Map.from(value);
      widget.onChanged(stepTwoData);
      setState(() {});
    }
  }

  void showAttachmentDialog() async {
    AttachmentHelper.showAttachmentDialog(context, processFile);
  }

  void removeAttachment(int index) {
    attachments.removeAt(index);
    renderableAttachment.removeAt(index);
    dynamic value = Map.from(stepTwoData);
    value['attachments'] = List.from(attachments);
    stepTwoData = Map.from(value);
    widget.onChanged(stepTwoData);
    if (attachments.isEmpty) editMode = false;
    setState(() {});
  }

  List<Widget> renderAttachments(double imageSize) {
    List<Widget> list = [];
    for (var i = 0; i < renderableAttachment.length; i++) {
      list.insert(
        0,
        Container(
            margin: EdgeInsets.only(right: 10.0),
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              color: COLOR.white,
              borderRadius: BorderRadius.circular(9.0),
            ),
            child: Stack(
              clipBehavior: Clip.hardEdge,
              fit: StackFit.expand,
              children: <Widget>[
                renderableAttachment[i],
                editMode
                    ? Container(
                        width: imageSize,
                        height: imageSize,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                          borderRadius: BorderRadius.circular(9.0),
                        ),
                        child: IconButton(
                          onPressed: () {
                            removeAttachment(i);
                          },
                          icon: Icon(Icons.delete),
                          color: COLOR.white,
                        ),
                      )
                    : Container(),
              ],
            )),
      );
    }
    return list;
  }

  TextStyle get inputStyle {
    return FONT.TITLE.merge(
      TextStyle(color: COLOR.white, fontSize: 22.0),
    );
  }
}
