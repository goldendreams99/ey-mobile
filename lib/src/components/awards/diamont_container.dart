part of employ.widgets;

class AwardDiamontContainer extends StatelessWidget {
  final int value;
  final bool isReceived;

  const AwardDiamontContainer({
    required this.value,
    this.isReceived = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      decoration: BoxDecoration(
        gradient: STYLES.hGradient(
          colors: [
            Color.fromRGBO(226, 133, 128, 1.0),
            Color.fromRGBO(217, 113, 150, 1.0),
          ],
        ),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 8.0,
              bottom: 2.0,
            ),
            child: Text(
              value.toString(),
              textAlign: TextAlign.center,
              style: FONT.SEMIBOLD.merge(
                TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Image.asset(
            'assets/images/icons/award_${isReceived ? 'received' : 'sent'}_diamont.png',
            width: 25.0,
          ),
        ],
      ),
    );
  }
}
