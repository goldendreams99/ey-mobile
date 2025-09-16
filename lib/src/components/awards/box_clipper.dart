part of employ.widgets;

class EmployAwardBoxClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0.0, size.height * 0.20);

    path.quadraticBezierTo(
      size.width * 0.01,
      size.height * 0.16,
      size.width * 0.10,
      size.height * 0.14,
    );
    path.lineTo(size.width * 0.80, size.height * 0.03);
    path.quadraticBezierTo(
      size.width * 0.97,
      size.height * 0.01,
      size.width,
      size.height * 0.18,
    );
    path.lineTo(size.width, size.height * 0.8);

    path.quadraticBezierTo(
      size.width * 0.99,
      size.height * 0.85,
      size.width * 0.80,
      size.height * 0.87,
    );

    path.lineTo(size.width * 0.20, size.height * 0.97);
    path.quadraticBezierTo(
      size.width * 0.03,
      size.height * 0.99,
      0.0,
      size.height * 0.82,
    );
    path.lineTo(0.0, size.height * 0.2);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
