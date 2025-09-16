part of employ.widgets;

class GradientCanvas extends CustomPainter {
  double fraction = 0.0;
  String theme;
  Size screenSize;

  GradientCanvas(this.theme, this.fraction, this.screenSize);

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromCircle(
      center: Offset(165.0, 55.0),
      radius: 180.0,
    );
    final Gradient gradient = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: COLOR.backgroundGradient[theme]!
          .map((Color c) => c.withOpacity(0.92))
          .toList(),
      stops: [0.0, 0.8],
    );

    var finalRadius = sqrt(pow(screenSize.width / 2, 2) +
            pow(screenSize.height - 32.0 - 48.0, 2)) *
        1.30;
    var radius = 24.0 + finalRadius * fraction;
    final Paint paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawCircle(
      Offset(size.width, size.height),
      radius,
      paint,
    );
  }

  @override
  bool shouldRepaint(GradientCanvas oldDelegate) {
    return oldDelegate.fraction != fraction;
  }
}
