part of employ.widgets;

class EmployChip extends StatelessWidget {
  final String name;
  final bool selected;
  final ValueChanged<String> onSelected;
  final Color color;
  final gradient;

  const EmployChip({
    required this.name,
    required this.selected,
    required this.onSelected,
    this.color = COLOR.greyish_brown,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 7.0),
      child: Column(
        children: <Widget>[
          if (selected)
            if (gradient != null)
              Expanded(
                child: InkResponse(
                    onTap: () => onSelected(name),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 35.0),
                      decoration: BoxDecoration(
                        // color: color,
                        gradient: gradient,
                        borderRadius: BorderRadius.all(
                          Radius.circular(24.0),
                        ),
                      ),
                      child: Text(
                        name.toString(),
                        style: FONT.SEMIBOLD.merge(
                          TextStyle(color: COLOR.white, fontSize: 14.0),
                        ),
                      ),
                    )),
              )
            else
              Expanded(
                child: RaisedButton(
                  onPressed: () => onSelected(name),
                  color: color,
                  padding: EdgeInsets.symmetric(horizontal: 35.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(24.0),
                    ),
                  ),
                  child: Text(
                    name.toString(),
                    style: FONT.SEMIBOLD.merge(
                      TextStyle(color: COLOR.white, fontSize: 14.0),
                    ),
                  ),
                ),
              )
          else
            Expanded(
              child: OutlineButton(
                onPressed: () => onSelected(name),
                highlightedBorderColor: color,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 35.0),
                child: Text(
                  name.toString(),
                  style: FONT.SEMIBOLD.merge(
                    TextStyle(color: color, fontSize: 14.0),
                  ),
                ),
                borderSide: BorderSide(color: color, width: 2.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(24.0),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
