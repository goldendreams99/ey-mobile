part of employ.widgets;

class BiometricPictureModule extends StatelessWidget {
  final String? image;
  final ValueChanged<int> onTap;
  final String text;
  final double height;
  final double spacing;

  const BiometricPictureModule({
    required this.onTap,
    required this.text,
    this.image,
    this.height = 150.0,
    this.spacing = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkResponse(
      onTap: () => onTap(text.toLowerCase() == 'selfie' ? 1 : 0),
      child: Container(
        margin: EdgeInsets.only(bottom: spacing),
        width: calcSize(size, size.width),
        height: calcSize(size, height),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(color: COLOR.white, width: 2.0),
          image: image != null
              ? DecorationImage(
            fit: BoxFit.fitWidth,
                  image: FileImage(File(image!)),
                )
              : null,
        ),
        child: image == null
            ? Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Icon(
                    EmployIcons.cam_filled,
                    size: 32.0,
                    color: COLOR.white,
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.only(bottom: 12.0, right: 21.0),
                    child: Text(
                      text,
                      style: FONT.TITLE.merge(
                        TextStyle(
                          color: COLOR.white.withOpacity(0.18),
                          fontSize: 21.0,
                        ),
                      ),
                    ),
                  )
                ],
              )
            : Container(),
      ),
    );
  }
}
