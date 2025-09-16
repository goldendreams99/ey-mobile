part of employ.widgets;

class MenuButton extends StatefulWidget {
  final int index;
  final VoidCallback action;
  final int closePosition;
  final String assetName;
  final String? text;
  final bool filled;
  final bool outlined;

  const MenuButton({
    Key? key,
    required this.index,
    required this.closePosition,
    required this.assetName,
    required this.action,
    this.text,
    required this.filled,
    required this.outlined,
  }) : super(key: key);

  @override
  _MenuButtonState createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  late Animation<double> animation;

  @override
  void initState() {
    if (mounted) {
      controller = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: widget.closePosition != widget.index ? 200 : 0,
        ),
      );
      animation = Tween(begin: 0.0, end: 1.0).animate(controller!);
      Timer(
          Duration(
            milliseconds: widget.index * 40,
          ), () {
        if (mounted) controller?.forward();
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double iconWidth = !widget.outlined ? 38.0 : 24.3;
    final double iconHeight = !widget.outlined ? 34.0 : 24.3;
    return ScaleTransition(
      scale: animation,
      child: Container(
        height: calcSize(size, 84.0),
        width: calcSize(size, 70.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: widget.action,
              child: Container(
                height: calcSize(size, 60.0),
                width: calcSize(size, 60.0),
                alignment: Alignment.center,
                child: widget.closePosition != widget.index
                    ? Image.asset(
                        'assets/images/icons/${widget.assetName}',
                        fit: BoxFit.contain,
                        width: calcSize(size, iconWidth),
                        height: calcSize(size, iconHeight),
                      )
                    : Icon(
                        EmployIcons.btm_close_dark,
                        size: calcSize(size, 60.0),
                        color: COLOR.white,
                      ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    calcSize(size, 30.0),
                  ),
                  gradient: widget.filled
                      ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.3, 0.7],
                          colors: [
                            COLOR.very_light_pink,
                            COLOR.white,
                          ],
                        )
                      : null,
                ),
              ),
            ),
            SizedBox(height: calcSize(size, 6.0)),
            widget.text != null
                ? Text(
                    widget.text ?? '',
                    maxLines: 1,
                    style: FONT.TITLE
                        .merge(
                          TextStyle(
                            fontSize: calcSize(size, 12.0),
                          ),
                        )
                        .apply(
                          color: COLOR.white,
                        ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
