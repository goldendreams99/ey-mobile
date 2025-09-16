part of employ.widgets;

class HomeBording extends StatefulWidget {
  @override
  _HomeBordingState createState() => _HomeBordingState();
}

class _HomeBordingState extends State<HomeBording>
    with SingleTickerProviderStateMixin {
  TabController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, initialIndex: 0, length: 2);
    controller?.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void runToHome() {
    Application.router.navigateTo(
      context,
      Routes.home,
      replace: true,
      clearStack: true,
    );
  }

  Container generateTemplate(String title, String assetName) {
    final size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: calcSize(size, 20.0)),
            height: calcSize(size, 283.0),
            width: calcSize(size, 280.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/$assetName'),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: FONT.TITLE.merge(
                TextStyle(
                  color: COLOR.white,
                  fontSize: calcSize(size, 22.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: COLOR.gradient['teal']![0],
        body: Container(
          decoration: BoxDecoration(gradient: STYLES.vGradient(theme: 'teal')),
          height: size.height,
          width: size.width,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    width: size.width,
                    height: size.height * 0.8,
                    child: TabBarView(
                      controller: controller,
                      children: <Widget>[
                        generateTemplate(
                          'Recibís y almacenás toda tu documentación al instante y sin límite\n',
                          'on_bording_step1.png',
                        ),
                        generateTemplate(
                          'Firmás cualquier documento de forma rápida y segura\n\n',
                          'on_bording_step2.png',
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: calcSize(size, padding.bottom + 95.0),
                child: Container(
                  width: size.width,
                  child: Center(
                    child: TabPageSelector(
                      controller: controller,
                      indicatorSize: calcSize(size, 10.0),
                      color: Colors.transparent,
                      selectedColor: COLOR.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: calcSize(size, padding.bottom + 21.0),
                child: Container(
                  child: InkResponse(
                    onTap: runToHome,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 20.0),
                      decoration: BoxDecoration(
                        color: COLOR.white,
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            offset: Offset(0, 7),
                            blurRadius: 12,
                            spreadRadius: -4,
                            color: Color.fromRGBO(92, 136, 255, 0.5),
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          LABEL.beginLabel,
                          style: FONT.TITLE.merge(
                            TextStyle(
                              fontWeight: FontWeight.w600,
                              color: COLOR.greyish_brown_three,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
