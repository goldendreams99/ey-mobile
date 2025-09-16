part of employ.widgets;

class FilterCard extends StatefulWidget {
  final String title;
  final String selected;
  final List<String> options;
  final ValueChanged<String> onSelect;

  const FilterCard({
    required this.title,
    required this.selected,
    required this.options,
    required this.onSelect,
  });

  @override
  _FilterCardState createState() => _FilterCardState();
}

class _FilterCardState extends State<FilterCard> {
  void select(String value) {
    widget.onSelect(value);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: calcSize(size, 36.0),
            width: size.width,
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 25.0, right: 50.0),
                  child: Text(
                    widget.title,
                    style: FONT.TITLE.merge(
                      TextStyle(
                        color: Color.fromRGBO(46, 46, 46, 1.0),
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 5.0),
                          height: 1.0,
                          color: COLOR.very_light_pink_three,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 21.0, bottom: 36.0),
            width: size.width,
            height: calcSize(size, 105.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.options.length,
              shrinkWrap: true,
              itemBuilder: (context, int index) {
                return EmployChip(
                  name: widget.options[index],
                  selected: widget.options[index] == widget.selected,
                  onSelected: select,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
