part of employ.pages;

class OnBording extends StatefulWidget {
  final String? screen;

  const OnBording({this.screen});

  @override
  _OnBordingState createState() => _OnBordingState();
}

class _OnBordingState extends State<OnBording> {
  final dynamic containers = {
    'home': HomeBording(),
    'change': ChangePasswordOnBording(),
    'reset': AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ResetPasswordBording(),
    ),
  };

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: COLOR.white,
      height: size.height,
      width: size.width,
      child: containers[widget.screen],
    );
  }
}
