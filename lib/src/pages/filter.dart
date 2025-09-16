part of employ.pages;

class Filter extends ConsumerStatefulWidget {
  final String? company;
  final String? employee;

  const Filter({this.company, this.employee});

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends ConsumerState<Filter> {
  late int year;
  late String state;
  //---------- BEGIN ----------//
  late String type;
  //---------- FINISH ----------//

  @override
  initState() {
    final filters = ref.read(filterProvider);
    year = filters.year;
    state = filters.state;
    //---------- BEGIN ----------//
    type = filters.type;
    //---------- FINISH ----------//
    super.initState();
  }

  void applyFilters() {
    final filtersNotifier = ref.read(filterProvider.notifier);
    filtersNotifier.setYear(year);
    filtersNotifier.setState(state);
    //---------- BEGIN ----------//
    filtersNotifier.setType(type);
    //---------- FINISH ----------//
    Application.router.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(filterProvider);
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    return Scaffold(
      backgroundColor: COLOR.white,
      body: Column(
        children: <Widget>[
          Container(
            height: calcSize(size, 95.0),
            width: size.width,
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: filters.years.isNotEmpty
                            ? FilterCard(
                          title: 'Año',
                                options: filters.years
                                    .map((e) => e.toStringAsFixed(0))
                                    .toList(),
                                selected: year.toString(),
                                onSelect: (value) {
                                  setState(() {
                                    year = int.parse(value);
                                  });
                                },
                              )
                            : Container(),
                      ),
                      filters.states.isNotEmpty
                          ? FilterCard(
                        title: 'Estado',
                              options: filters.states,
                              selected: state,
                              onSelect: (value) {
                                setState(() {
                                  state = value;
                                });
                              },
                            )
                          : Container(),
                      //---------- BEGIN ----------//
                      filters.types.isNotEmpty
                          ? FilterCard(
                              title: 'Tipo',
                              options: filters.types,
                              selected: type,
                              onSelect: (value) {
                                setState(() {
                                  type = value;
                                });
                              },
                            )
                          : Container(),
                      //---------- FINISH ----------//
                    ],
                  ),
                  Positioned(
                    bottom: padding.bottom,
                    left: 0.0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.0),
                      width: size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          FooterButton(
                            action: () => Application.router.pop(context),
                            icon: EmployIcons.btm_close_dark,
                            size: calcSize(size, 60.0),
                            theme: Brightness.dark,
                          ),
                          FooterButton(
                            action: applyFilters,
                            icon: EmployIcons.btm_check_dark,
                            size: calcSize(size, 60.0),
                            theme: Brightness.dark,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
