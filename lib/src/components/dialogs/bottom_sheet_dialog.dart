import 'package:employ/app.dart';
import 'package:employ/src/components/index.dart';
import 'package:employ/src/config/application.dart';
import 'package:employ/src/providers/app/app_provider.dart';
import 'package:employ/src/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomSheetDialog {
  static void close(BuildContext context) {
    Application.router.pop(context);
  }

  static build(
    BuildContext context,
    WidgetRef ref,
    String text, {
    double height = 250.0,
    Widget? widget,
    VoidCallback? onAccept,
    Widget? textWidget,
  }) {
    final size = MediaQuery.of(context).size;
    final settings = ref.read(appProvider).settings;
    final padding = MediaQuery.of(context).padding;
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      builder: (BuildContext _context) {
        return Container(
          width: size.width,
          height: height,
          padding: EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 0.0),
          decoration: BoxDecoration(
            gradient: STYLES.vGradient(theme: settings!.theme),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(32.0),
            ),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: textWidget ??
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: FONT.TITLE.merge(
                        TextStyle(
                          color: COLOR.white,
                          fontSize: 20.3,
                        ),
                      ),
                    ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(bottom: padding.bottom),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      FooterButton(
                        action: () => close(context),
                        icon: EmployIcons.btm_close_dark,
                        size: calcSize(size, 60.0),
                        theme: Brightness.light,
                      ),
                      widget != null
                          ? widget
                          : FooterButton(
                              action: () => onAccept != null
                                  ? onAccept()
                                  : close(context),
                              icon: EmployIcons.btm_check_dark,
                              size: calcSize(size, 60.0),
                              theme: Brightness.light,
                            ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
