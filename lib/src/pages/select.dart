part of employ.pages;

class EmploySelect<T> extends ConsumerStatefulWidget {
  final String title;
  final List<T> options;
  final String Function(T option) render;
  final T? selected;

  const EmploySelect({
    required this.title,
    required this.options,
    required this.render,
    required this.selected,
  });

  @override
  _EmploySelectState<T> createState() => _EmploySelectState();
}

class _EmploySelectState<T> extends ConsumerState<EmploySelect<T>> {
  void select(T item) {
    Navigator.of(context).pop(item);
  }

  @override
  Widget build(BuildContext context) {
    final manager = ref.watch(appProvider);
    final padding = MediaQuery.of(context).padding;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: STYLES.vGradient(theme: manager.settings!.theme),
        ),
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.topLeft,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: calcSize(size, 116),
                  alignment: Alignment.bottomLeft,
                  width: size.width,
                  padding: EdgeInsets.fromLTRB(22.0, 0, 16.0, 16.0),
                  child: Text(
                    widget.title,
                    style: FONT.TITLE.merge(
                      TextStyle(fontSize: 34.0, color: COLOR.white),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 80.0),
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    addAutomaticKeepAlives: true,
                    itemCount: widget.options.length,
                    itemBuilder: (context, int index) {
                      T current = widget.options[index];
                      return InkResponse(
                        onTap: () => select(current),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0.0, 4.0, 16.0, 4.0),
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 18.0,
                                margin: EdgeInsets.only(right: 8.0),
                                child: widget.selected != null &&
                                        widget.selected == current
                                    ? Icon(Icons.check, color: COLOR.white)
                                    : null,
                              ),
                              Text(
                                widget.render(current),
                                style: FONT.TITLE.merge(
                                  TextStyle(color: COLOR.white, fontSize: 21.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 3.0,
              bottom: padding.bottom,
              child: FooterButton(
                action: () => Application.router.pop(context),
                icon: EmployIcons.btm_close_dark,
                size: calcSize(size, 60.0),
                theme: Brightness.light,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
