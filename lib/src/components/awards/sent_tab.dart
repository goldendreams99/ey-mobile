import 'package:employ/app.dart';
import 'package:employ/src/components/index.dart';
import 'package:employ/src/models/index.dart';
import 'package:employ/src/providers/app/app_provider.dart';
import 'package:employ/src/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmployAwardSent extends ConsumerWidget {
  final List<Award> documents;
  final VoidCallback onSend;
  final VoidCallback onWatch;

  const EmployAwardSent(this.documents, this.onSend, this.onWatch);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final settings = ref.watch(
      appProvider.select((value) => value.settings),
    );
    final totalSent = Employee.getSendedAwards(
      settings!.awardLimitMonthlyTotal,
      documents,
    );
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
                gradient: STYLES.dlGradient(
                  colors: [
                    Color.fromRGBO(194, 46, 160, 1.0),
                    Color.fromRGBO(95, 19, 117, 1.0),
                  ],
                ),
              ),
              height: calcSize(size, 400.0),
              width: size.width,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(32.0, 90.0, 32.0, 0.0),
                    child: totalSent > 0
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    totalSent.toString(),
                                    style: FONT.TITLE.merge(
                                      TextStyle(
                                        color: COLOR.white,
                                        fontSize: calcSize(size, 34.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Image.asset(
                                    'assets/images/icons/award_sent_diamont.png',
                                    width: 40.0,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "RECONOCIMIENTOS\nRESTANTES",
                                textAlign: TextAlign.left,
                                style: FONT.TITLE.merge(
                                  TextStyle(
                                    color: Colors.white,
                                    fontSize: calcSize(size, 14.9),
                                  ),
                                ),
                              ),
                              Text(
                                "¡Compartilos\nahora!",
                                textAlign: TextAlign.left,
                                style: FONT.TITLE.merge(
                                  TextStyle(
                                    color: Colors.white,
                                    fontSize: calcSize(size, 40.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  EmployAwardPeople(
                                    Employee.sendedAwards(documents),
                                  ),
                                  Text(
                                    Award.getNewMonth(),
                                    textAlign: TextAlign.left,
                                    style: FONT.TITLE.merge(
                                      TextStyle(
                                        color: COLOR.black.withOpacity(0.28),
                                        // color: COLOR.white.withOpacity(0.58),
                                        fontSize: calcSize(size, 15.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 30.0,
                              ),
                              Text(
                                "¡Buen\n Trabajo!",
                                textAlign: TextAlign.left,
                                style: FONT.TITLE.merge(
                                  TextStyle(
                                    color: Colors.white,
                                    fontSize: calcSize(size, 40.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "HAS ENVIADO TODOS TUS RECONOCIMIENTOS",
                                textAlign: TextAlign.left,
                                style: FONT.TITLE.merge(
                                  TextStyle(
                                    color: Colors.white,
                                    fontSize: calcSize(size, 14.9),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  EmployAwardPeople(
                                    Employee.sendedAwards(documents),
                                  ),
                                  Text(
                                    Award.getNewMonth(),
                                    textAlign: TextAlign.left,
                                    style: FONT.TITLE.merge(
                                      TextStyle(
                                        color: COLOR.black.withOpacity(0.28),
                                        fontSize: calcSize(size, 15.0),
                                      ),
                                    ),
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
                      'assets/images/icons/award_icon_sent_bg.png',
                      width: 150.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
              height: 60.0,
              width: size.width,
              alignment: Alignment.center,
              child: InkResponse(
                onTap: totalSent == 0 ? onWatch : onSend,
                child: Container(
                  width: 200.0,
                  height: 60.0,
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        totalSent == 0 ? 'Ver' : "Enviar",
                        textAlign: TextAlign.center,
                        style: FONT.SEMIBOLD.merge(
                          TextStyle(
                            color: Colors.white,
                            fontSize: calcSize(size, 22.4),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      totalSent == 0
                          ? Container()
                          : Image.asset(
                              'assets/images/icons/award_sent_diamont.png',
                              width: 35.0,
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
