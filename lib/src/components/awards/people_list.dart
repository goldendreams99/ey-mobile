part of employ.widgets;

class EmployAwardPeople extends StatelessWidget {
  final List<Award> documents;
  final bool isReceived;

  const EmployAwardPeople(this.documents, {this.isReceived = false});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<Widget> avatars = [];
    int count = (documents.length > 3 ? 3 : documents.length);
    for (var i = 0; i < count; i++) {
      Award current = documents[i];
      ImageProvider image;
      if (isReceived) {
        image = NetworkImage(current.image);
      } else {
        if (current.to.avatar.contains('http')) {
          image = NetworkImage(current.to.avatar);
        } else {
          image = AssetImage('assets/images/avatar/${current.to.avatar}.png');
        }
      }
      avatars.add(
        Positioned(
          left: 0.0 + i * 21,
          child: Container(
            width: 45.0,
            height: 45.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21.0),
              color: COLOR.white
                  .withOpacity(current.to.avatar.contains('http') ? 1.0 : 0.8),
              image: DecorationImage(
                fit: BoxFit.cover,
                alignment: Alignment.center,
                image: image,
              ),
            ),
          ),
        ),
      );
    }
    if (documents.length > 3) {
      avatars.add(
        Positioned(
          left: 3 * 21.0,
          child: Container(
            width: 45.0,
            height: 45.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21.0),
              gradient: STYLES.hGradient(
                colors: [
                  Color.fromRGBO(149, 117, 205, 1.0),
                  Color.fromRGBO(161, 67, 198, 1.0),
                ],
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '+${documents.length - 3}',
              textAlign: TextAlign.center,
              style: FONT.TITLE.merge(
                TextStyle(color: COLOR.white, fontSize: 15.8),
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      width: size.width * 0.65,
      height: 45.0,
      child: Stack(
        children: <Widget>[]..addAll(avatars),
      ),
    );
  }
}
