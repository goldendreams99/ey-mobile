part of employ.pages;

class AwardCreated extends StatefulWidget {
  final Award award;

  const AwardCreated({
    required this.award,
  });

  @override
  AwardCreatedState createState() => AwardCreatedState();
}

class AwardCreatedState extends State<AwardCreated> {
  late AlignmentGeometry boxOne;
  late AlignmentGeometry boxTwo;

  @override
  void initState() {
    super.initState();
    boxOne = Alignment.centerLeft;
    boxTwo = Alignment.centerRight;
    Timer(Duration(milliseconds: 300), () {
      boxOne = Alignment.centerRight;
      boxTwo = Alignment.centerLeft;
      if (mounted) setState(() {});
    });
    Timer(Duration(seconds: 6), () {
      Application.router.pop(context);
    });
  }

  TextStyle get style {
    return FONT.TITLE.merge(
      TextStyle(
        color: Colors.white,
        fontSize: 27.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double boxWidth = size.width / 2;
    final current = widget.award;
    ImageProvider image;
    if (current.from.avatar.contains('http')) {
      image = NetworkImage(current.from.avatar);
    } else {
      image = AssetImage('assets/images/avatar/${current.to.avatar}.png');
    }
    return Scaffold(
      backgroundColor: COLOR.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
              gradient: STYLES.bhGradient(colors: [
                Color.fromRGBO(78, 12, 195, 1.0),
                Color.fromRGBO(161, 67, 198, 1.0),
              ]),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: size.width,
                  height: calcSize(size, 450.0),
                  child: Stack(
                    children: <Widget>[
                      ClipShadowPath(
                        shadow: Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 10,
                          color: COLOR.black.withOpacity(0.5),
                        ),
                        clipper: EmployAwardBoxClipper(),
                        child: Container(
                          padding: EdgeInsets.only(top: calcSize(size, 65.0)),
                          decoration: BoxDecoration(
                            gradient: STYLES.vGradient(
                              colors: [
                                Color.fromRGBO(194, 46, 160, 1.0),
                                Color.fromRGBO(95, 19, 117, 1.0),
                              ],
                            ),
                          ),
                          height: calcSize(size, 450.0),
                          width: size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    alignment: boxOne,
                                    width: boxWidth,
                                    height: 120.0,
                                    padding: EdgeInsets.only(right: 5.0),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: 120.0,
                                          width: 120.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(60.0),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: image,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    alignment: boxTwo,
                                    width: boxWidth,
                                    height: 120.0,
                                    padding: EdgeInsets.only(left: 5.0),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: 120.0,
                                          width: 120.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(60.0),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image:
                                                  NetworkImage(current.image),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.0),
                              Container(
                                width: size.width,
                                child: Text(
                                  (List.from(awardSentText)..shuffle()).first,
                                  style: FONT.TITLE.merge(
                                    TextStyle(
                                      color: COLOR.white,
                                      fontSize: calcSize(size, 20),
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: 12.0),
                              Container(
                                alignment: Alignment.center,
                                width: size.width,
                                child: Container(
                                  width: 300.0,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 12.0),
                                  decoration: BoxDecoration(
                                      color: COLOR.black.withOpacity(0.34),
                                      borderRadius:
                                          BorderRadius.circular(47.0)),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        height: 45.0,
                                        width: 45.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(60.0),
                                          color: COLOR.black.withOpacity(0.2),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: image,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Container(
                                        width: 260.0 - 45.0,
                                        child: Text(
                                          "“${current.observation}”",
                                          maxLines: 3,
                                          style: FONT.SEMIBOLD.merge(
                                            TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.9,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 60.0,
                            width: size.width,
                            alignment: Alignment.center,
                            child: Container(
                              width: 145.0,
                              height: 60.0,
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    width: 120.0,
                                    height: 60.0,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30.0, vertical: 12.0),
                                    decoration: BoxDecoration(
                                      gradient: STYLES.bhGradient(
                                        colors: [
                                          Color.fromRGBO(247, 94, 78, 1.0),
                                          Color.fromRGBO(197, 67, 198, 1.0),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "+1",
                                          textAlign: TextAlign.center,
                                          style: FONT.SEMIBOLD.merge(
                                            TextStyle(
                                              color: Colors.white,
                                              fontSize: 30.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 0.0,
                                    child: Image.asset(
                                      'assets/images/icons/award_sent_diamont.png',
                                      height: 60.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.transparent,
            child: LottieAnim(
              duration: Duration(milliseconds: 7000),
              path: 'assets/animation/confetti.json',
              size: Size(size.width, size.height),
              itRepeatable: false,
            ),
          )
        ],
      ),
    );
  }
}
