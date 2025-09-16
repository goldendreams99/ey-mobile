import 'dart:io';

import 'package:employ/app.dart';
import 'package:employ/src/pages/expense/expense_add/provider/expense_add_provider.dart';
import 'package:employ/src/providers/app/app_provider.dart';
import 'package:employ/src/theme/index.dart';
import 'package:employ/src/types/int.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseAddStepAttachments extends ConsumerStatefulWidget {
  const ExpenseAddStepAttachments();

  @override
  _ExpenseAddStepAttachmentState createState() =>
      _ExpenseAddStepAttachmentState();
}

class _ExpenseAddStepAttachmentState
    extends ConsumerState<ExpenseAddStepAttachments> {
  bool editMode = false;
  List<Widget> renderableAttachment = [];
  List<String> attachments = [];
  TextEditingController commentControl = TextEditingController();

  @override
  void initState() {
    super.initState();
    commentControl.text = ref.read(expenseAddProvider).observation ?? "";
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      attachments = ref.read(expenseAddProvider).attachments;
      renderableAttachment = await AttachmentHelper.render(
        attachments.map((e) => File(e)).toList(),
      );
      final observation = ref.read(expenseAddProvider).observation;
      if (observation == null) {
        ref.read(expenseAddProvider.notifier).setObservation("");
      }
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double imageSize = (size.width * 0.25);
    final manager = ref.watch(appProvider);
    attachments = ref.watch(
      expenseAddProvider.select((value) => value.attachments),
    );
    final observation = ref.watch(
      expenseAddProvider.select((value) => value.observation),
    );
    ref.listen<List<String>>(
      expenseAddProvider.select((value) => value.attachments),
      (previous, next) {
        if (next.isEmpty) editMode = false;
        setState(() {});
      },
    );
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: COLOR.black.withOpacity(0.13),
                borderRadius: BorderRadius.circular(5.0),
              ),
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
                                            manager.settings!.theme]![1],
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
                          onTap: addAttachment,
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
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10.0),
                            height: imageSize,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: renderAttachments(imageSize),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // OBSERVACIONES - Copiado exactamente de step_observations.dart
            SizedBox(height: 10.0),
            Container(
              margin: EdgeInsets.only(bottom: 12.0),
              child: Container(
                decoration: BoxDecoration(
                    color: COLOR.black.withOpacity(0.13),
                    borderRadius: BorderRadius.circular(5.0)),
                padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 11.35),
                child: TextField(
                  controller: commentControl,
                  style: inputStyle,
                  maxLength: 140,
                  textInputAction: TextInputAction.done,
                  maxLines: 10,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(140),
                  ],
                  onChanged: (text) {
                    ref.read(expenseAddProvider.notifier).setObservation(text);
                  },
                  decoration: InputDecoration(
                    hintStyle: inputStyle
                        .merge(TextStyle(color: COLOR.white.withOpacity(0.4))),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 18.0,
                    ),
                    hintText: 'Observaciones',
                    border: InputBorder.none,
                    counterText: "",
                  ),
                ),
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

  void addAttachment() async {
    AttachmentHelper.showAttachmentDialog(context, processFile);
  }

  void processFile(File? file) async {
    if (file != null) {
      final image = await AttachmentHelper.fileToImageWidget(file);
      renderableAttachment.add(image);
      ref.read(expenseAddProvider.notifier).addAttachment(path: file.path);
      if (mounted) setState(() {});
    }
  }

  void removeAttachment(int index) {
    ref.read(expenseAddProvider.notifier).removeAttachment(
          path: attachments[index],
        );
    renderableAttachment.removeAt(index);
    if (mounted) setState(() {});
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
    return FONT.TITLE.merge(TextStyle(color: COLOR.white, fontSize: 22.0));
  }
}
