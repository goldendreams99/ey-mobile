part of employ.widgets;

class AwardReceivedDialog {
  static void close(BuildContext context) {
    Application.router.pop(context);
  }

  static build(BuildContext context, Award award) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      builder: (BuildContext _context) {
        ImageProvider image;
        if (award.from.avatar.contains('http')) {
          image = NetworkImage(award.from.avatar);
        } else {
          image = AssetImage('assets/images/avatar/${award.to.avatar}.png');
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              padding:
                  EdgeInsets.fromLTRB(30.0, 40.0, 15.0, padding.bottom + 10),
              // height: 300.0,
              width: size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.0),
                  topRight: Radius.circular(32.0),
                ),
                gradient: STYLES.vGradient(
                  colors: [
                    Color.fromRGBO(149, 117, 205, 1.0),
                    Color.fromRGBO(161, 67, 198, 1.0),
                  ],
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "RECIBIDO ${award.relative}",
                                style: FONT.TITLE.merge(
                                  TextStyle(
                                    color: Color.fromRGBO(255, 243, 243, 0.95),
                                    fontSize: 12.6,
                                  ),
                                ),
                              ),
                              Text(
                                award.from.name,
                                style: FONT.TITLE.merge(
                                  TextStyle(
                                    color: Color.fromRGBO(255, 243, 243, 0.95),
                                    fontSize: 20.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '1',
                                style: FONT.TITLE.merge(
                                  TextStyle(
                                    color: Color.fromRGBO(255, 243, 243, 0.95),
                                    fontSize: 18.4,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 3.0,
                              ),
                              Image.asset(
                                'assets/images/icons/award_received_diamont.png',
                                width: 30.0,
                              ),
                            ],
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 25.0, bottom: 20.0),
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 22.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(35.0),
                          ),
                          color: Color.fromRGBO(0, 0, 0, 0.20),
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 45.0,
                              height: 45.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22.5),
                                color: Colors.blue,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: image,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            Container(
                              width: calcSize(size, 200.0),
                              child: Text(
                                '“${award.observation}”',
                                softWrap: true,
                                style: FONT.TITLE.merge(
                                  TextStyle(
                                      color: Colors.white, fontSize: 16.9),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.0),
                        alignment: Alignment.bottomLeft,
                        child: FooterButton(
                          action: () {
                            Application.router.pop(context);
                          },
                          icon: EmployIcons.btm_close_dark,
                          size: calcSize(size, 60.0),
                          theme: Brightness.light,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
