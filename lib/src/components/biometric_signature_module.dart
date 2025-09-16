part of employ.widgets;

class BiometricSignatureModule extends StatelessWidget {
  final String? image;
  final String text;
  final double height;
  final double spacing;
  final VoidCallback? onTap;

  const BiometricSignatureModule({
    required this.text,
    this.image,
    this.height = 398.0,
    this.spacing = 14.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkResponse(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: spacing),
        width: calcSize(size, size.width),
        height: calcSize(size, height),
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(color: COLOR.white, width: 2.0),
        ),
        child: image == null
            ? Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Icon(
                    EmployIcons.sign_1,
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
            : Image(
                image: FileImage(
                  File(image!),
                ),
              ),
      ),
    );
  }
}
