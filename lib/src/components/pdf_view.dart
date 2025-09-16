import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:employ/src/components/index.dart';

class PdfView extends StatefulWidget {
  final String? path;

  const PdfView(this.path, {Key? key}) : super(key: key);

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  String? path;
  String? error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        path = await addMarginToPdfPages(5);
      } catch (e) {
        error = e.toString();
      } finally {
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Center(
        child: Text('Error: $error'),
      );
    }
    if (path == null) {
      return Center(
        child: LottieAnim(
          duration: Duration(milliseconds: 2000),
          path: 'assets/animation/loader.json',
          size: Size(40.0, 40.0),
          itRepeatable: true,
        ),
      );
    }
    return Container(
      child: PDFView(
        filePath: path,
        pageSnap: false,
        autoSpacing: false,
        nightMode: false,
        pageFling: false,
      ),
    );
  }

  Future<String> addMarginToPdfPages(int width) async {
    await Future.delayed(Duration(milliseconds: 500));
    final path = (await getTemporaryDirectory()).path + '/temp_show.pdf';
    final file = await File(widget.path ?? '').copy(path);
    final PdfDocument document = PdfDocument(
      inputBytes: file.readAsBytesSync(),
    );
    if (document.pages.count <= 1) {
      return path;
    }
    for (int i = 0; i < document.pages.count; i++) {
      document.pages[i].graphics.drawLine(
        PdfPen(PdfColor(0, 0, 0), width: width.toDouble()),
        Offset(
          0,
          document.pages[i].size.height - width,
        ),
        Offset(
          document.pages[i].size.width,
          document.pages[i].size.height - width,
        ),
      );
    }
    final bytes = await document.save();
    await file.writeAsBytes(bytes);
    document.dispose();
    return path;
  }
}
