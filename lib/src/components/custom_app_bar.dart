part of employ.widgets;

class SimpleAppBar extends ConsumerWidget {
  final String text;
  final VoidCallback onFilter;
  final bool hasBorder;
  final bool hasAction;
  final IconData icon;

  const SimpleAppBar({
    required this.text,
    required this.onFilter,
    this.hasBorder = true,
    this.hasAction = true,
    this.icon = Icons.filter_list,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final settings = ref.watch(
      appProvider.select((value) => value.settings),
    );
    return Container(
      height: calcSize(size, 116),
      width: size.width,
      padding: EdgeInsets.fromLTRB(22.0, 0, 12.0, 16.0),
      decoration: hasBorder
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(color: COLOR.very_light_pink_three),
              ),
            )
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: hasAction
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(bottom: 3.0),
              width: calcSize(size, 274.0),
              child: GradientText(
                text,
                colors: COLOR.gradient[settings!.theme]!,
                style: FONT.TITLE.merge(
                  TextStyle(fontSize: 31.0),
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          hasAction
              ? IconButton(
                  padding: EdgeInsets.only(top: 11.0),
                  icon: Icon(icon),
                  onPressed: onFilter,
                  color: COLOR.cloudy_blue,
                )
              : Container()
        ],
      ),
    );
  }
}
