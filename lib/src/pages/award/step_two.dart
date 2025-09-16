part of employ.pages;

class AwardStepTwo extends ConsumerStatefulWidget {
  final dynamic stepTwoData;
  final ValueChanged<Map<dynamic, dynamic>> onChanged;

  const AwardStepTwo({
    this.stepTwoData,
    required this.onChanged,
  });

  @override
  AwardStepTwoState createState() => AwardStepTwoState();
}

class AwardStepTwoState extends ConsumerState<AwardStepTwo> {
  String? query;
  List<Employee> documents = [];
  List<Employee> subDocuments = [];
  dynamic stepData;

  @override
  void initState() {
    super.initState();
    stepData = Map.from(widget.stepTwoData);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final company = ref.read(appProvider).company;
      final employee = ref.read(appProvider).employee;
      final db = EmployProvider.of(context).database;
      String refEmployee = 'client/${company!.id}/employee';
      final values = await db.once(refEmployee);
      if (values != null) {
        Map.from(values).forEach((k, v) => documents.add(Employee.fromJson(v)));
      }
      Employee.sortByName(documents);
      documents = documents.where((e) {
        return e.id != employee!.id && e.active;
      }).toList();
      subDocuments = List.from(documents);
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final manager = ref.watch(appProvider);
    final double circleSize = 90.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0),
          child: Row(
            children: <Widget>[
              Container(
                height: calcSize(size, 50.0),
                width: calcSize(size, 280.0),
                margin: EdgeInsets.symmetric(vertical: 10.0),
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                decoration: BoxDecoration(
                  color: COLOR.black.withOpacity(0.13),
                  borderRadius: BorderRadius.only(
                    bottomLeft: const Radius.circular(5.0),
                    topLeft: const Radius.circular(5.0),
                  ),
                ),
                child: NonBorderTextField(
                  height: calcSize(size, 50.0),
                  color: COLOR.greyish_brown,
                  autoFocus: false,
                  hint: 'Buscar',
                  hintStyle: style.merge(
                    TextStyle(
                      color: COLOR.white.withOpacity(0.2),
                    ),
                  ),
                  type: TextInputType.emailAddress,
                  insidePadding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 9.0),
                  style: style,
                  onChange: (value) {
                    query = value;
                    subDocuments = Employee.awardFilter(
                      documents,
                      manager.employee!,
                      query: query,
                    );
                    setState(() {});
                  },
                ),
              ),
              Container(
                height: calcSize(size, 50.0),
                width: calcSize(size, 50.0),
                margin: EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
                  color: COLOR.black.withOpacity(0.26),
                  borderRadius: BorderRadius.only(
                    bottomRight: const Radius.circular(5.0),
                    topRight: const Radius.circular(5.0),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.search,
                    color: COLOR.white,
                  ),
                ),
              )
            ],
          ),
        ),
        if (manager.valid && documents.length > 0)
          Expanded(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
                height: 50.vh(context),
                width: size.width,
                margin: EdgeInsets.only(top: 15.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  addRepaintBoundaries: true,
                  itemCount:
                      subDocuments.length > 30 ? 30 : subDocuments.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, int index) {
                    Employee current = subDocuments[index];
                    bool isChoiced = stepData['employee'] == null ||
                        stepData['employee'].id == current.id;
                    ImageProvider image;
                    if (current.avatar.contains('http')) {
                      image = NetworkImage(current.avatar);
                    } else {
                      image = AssetImage(
                        'assets/images/avatar/${current.avatar}.png',
                      );
                    }
                    return InkResponse(
                      onTap: () {
                        stepData['employee'] = current;
                        widget.onChanged(stepData);
                        setState(() {});
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10.3),
                            height: circleSize + (isChoiced ? 5.0 : 0.0),
                            width: circleSize + (isChoiced ? 5.0 : 0.0),
                            decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: COLOR.black.withOpacity(0.5),
                                  offset: Offset(0, 9),
                                  spreadRadius: -11,
                                  blurRadius: 26,
                                )
                              ],
                              borderRadius: BorderRadius.circular(45.0),
                              color: COLOR.white.withOpacity(
                                  current.avatar.contains('http')
                                      ? 0.3
                                      : 1.0),
                              border: isChoiced &&
                                      stepData['employee'] != null
                                  ? Border.all(
                                      color:
                                          Color.fromRGBO(37, 174, 205, 1.0),
                                      width: 5.0,
                                    )
                                  : null,
                            ),
                            child: Container(
                              height: circleSize,
                              width: circleSize,
                              foregroundDecoration: isChoiced
                                  ? null
                                  : BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        45.0 + (isChoiced ? 2.5 : 0.0),
                                      ),
                                      color: Colors.grey,
                                      backgroundBlendMode:
                                          BlendMode.saturation,
                                    ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  45.0 + (isChoiced ? 2.5 : 0.0),
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: image,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            width: 120,
                            child: Text(
                              '${current.firstName}',
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.center,
                              style: FONT.TITLE.merge(
                                TextStyle(
                                  color: COLOR.white.withOpacity(
                                    isChoiced ? 1.0 : 0.25,
                                  ),
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 120,
                            child: Text(
                              '${current.lastName}',
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.center,
                              style: FONT.TITLE.merge(
                                TextStyle(
                                  color: COLOR.white.withOpacity(
                                    isChoiced ? 1.0 : 0.25,
                                  ),
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        else
          Expanded(
            flex: 1,
            child: Center(
              child: LottieAnim(
                duration: Duration(milliseconds: 500),
                path: 'assets/animation/dot_animation.json',
                size: Size(200.0, size.width),
                itRepeatable: true,
              ),
            ),
          ),
      ],
    );
  }

  TextStyle get style {
    return FONT.TITLE.merge(
      TextStyle(
        color: Colors.white,
        fontSize: 27.0,
      ),
    );
  }
}
