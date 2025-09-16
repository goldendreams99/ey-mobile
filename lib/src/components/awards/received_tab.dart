part of employ.widgets;

class EmployAwardReceived extends StatelessWidget {
  final List<Award> documents;
  final VoidCallback onShowReceived;

  const EmployAwardReceived(this.documents, this.onShowReceived);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: calcSize(size, 400.0),
      width: size.width,
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
              decoration: BoxDecoration(
                gradient: STYLES.vGradient(
                  colors: [
                    Color.fromRGBO(23, 154, 155, 1.0),
                    Color.fromRGBO(50, 193, 255, 1.0),
                  ],
                ),
              ),
              height: calcSize(size, 400.0),
              width: size.width,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(32.0, 90.0, 32.0, 0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              Employee.receivedAwards(documents)
                                  .length
                                  .toString(),
                              style: FONT.TITLE.merge(
                                TextStyle(
                                  color: COLOR.white,
                                  fontSize: 34.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Image.asset(
                              'assets/images/icons/award_received_diamont.png',
                              width: 40.0,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "RECONOCIMIENTOS\n RECIBIDOS",
                          textAlign: TextAlign.left,
                          style: FONT.TITLE.merge(
                            TextStyle(
                              color: Colors.white,
                              fontSize: 14.9,
                            ),
                          ),
                        ),
                        Text(
                          "¡Nos alegra ver\ntu progreso!",
                          textAlign: TextAlign.left,
                          style: FONT.TITLE.merge(
                            TextStyle(
                              color: Colors.white,
                              fontSize: 40.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            EmployAwardPeople(
                              Employee.receivedAwards(documents),
                              isReceived: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 30.0,
                    right: 15.0,
                    child: Image.asset(
                      'assets/images/icons/award_icon_received_bg.png',
                      width: 150.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: Employee.receivedAwards(documents).length > 0
                ? Container(
                    height: 60.0,
                    width: size.width,
                    alignment: Alignment.center,
                    child: InkResponse(
                      onTap: onShowReceived,
                      child: Container(
                        width: 200.0,
                        height: 60.0,
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 18.0),
                        decoration: BoxDecoration(
                          gradient: STYLES.bhGradient(
                            colors: [
                              Color.fromRGBO(24, 88, 127, 1.0),
                              Color.fromRGBO(197, 67, 198, 1.0),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Ver",
                              textAlign: TextAlign.center,
                              style: FONT.SEMIBOLD.merge(
                                TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
