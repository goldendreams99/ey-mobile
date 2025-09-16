import 'dart:math';

import 'package:flutter/painting.dart';

class CustomRoundedRectangleBorder extends ShapeBorder {
  final BorderSide? leftSide;
  final BorderSide? rightSide;
  final BorderSide? topSide;
  final BorderSide? bottomSide;
  final BorderSide? topLeftCornerSide;
  final BorderSide? topRightCornerSide;
  final BorderSide? bottomLeftCornerSide;
  final BorderSide? bottomRightCornerSide;

  const CustomRoundedRectangleBorder({
    this.leftSide,
    this.rightSide,
    this.topSide,
    this.bottomSide,
    this.topLeftCornerSide,
    this.topRightCornerSide,
    this.bottomLeftCornerSide,
    this.bottomRightCornerSide,
    this.borderRadius = BorderRadius.zero,
  });

  double get biggestWidth => max(
      max(
          max(
              max(
                  max(
                      max(max(topSide?.width ?? 0.0, rightSide?.width ?? 0.0),
                          bottomSide?.width ?? 0.0),
                      leftSide?.width ?? 0.0),
                  bottomRightCornerSide?.width ?? 0.0),
              bottomLeftCornerSide?.width ?? 0.0),
          topRightCornerSide?.width ?? 0.0),
      topLeftCornerSide?.width ?? 0.0);

  final BorderRadius borderRadius;

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.all(biggestWidth);
  }

  @override
  ShapeBorder scale(double t) {
    return CustomRoundedRectangleBorder(
      topSide: topSide?.scale(t),
      leftSide: leftSide?.scale(t),
      bottomSide: bottomSide?.scale(t),
      rightSide: bottomSide?.scale(t),
      topLeftCornerSide: topLeftCornerSide?.scale(t),
      topRightCornerSide: topRightCornerSide?.scale(t),
      bottomLeftCornerSide: bottomLeftCornerSide?.scale(t),
      bottomRightCornerSide: bottomRightCornerSide?.scale(t),
      borderRadius: borderRadius * t,
    );
  }

  Rect rectForCorner(
    double sideWidth,
    Offset offset,
    Radius radius,
    num signX,
    num signY,
  ) {
    double d = sideWidth / 2;
    double borderRadiusX = radius.x - d;
    double borderRadiusY = radius.y - d;
    Rect rect = Rect.fromPoints(
        offset + Offset(signX.sign * d, signY.sign * d),
        offset +
            Offset(signX.sign * d, signY.sign * d) +
            Offset(signX.sign * 2 * borderRadiusX,
                signY.sign * 2 * borderRadiusY));

    return rect;
  }

  Paint createPaintForBorder(BorderSide side) {
    return Paint()
      ..style = PaintingStyle.stroke
      ..color = side.color
      ..strokeWidth = side.width;
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(borderRadius
          .resolve(textDirection)
          .toRRect(rect)
          .deflate(biggestWidth));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    Paint paint;

    if (topLeftCornerSide != null) {
      paint = createPaintForBorder(topLeftCornerSide!);
      if (borderRadius.topLeft.x != 0.0) {
        canvas.drawArc(
          rectForCorner(topLeftCornerSide!.width, rect.topLeft,
              borderRadius.topLeft, 1, 1),
          pi / 2 * 2,
          pi / 2,
          false,
          paint,
        );
      }
    }

    if (topSide != null) {
      paint = createPaintForBorder(topSide!);
      canvas.drawLine(
          rect.topLeft +
              Offset(
                  borderRadius.topLeft.x +
                      (borderRadius.topLeft.x == 0
                          ? (leftSide?.width ?? 0.0)
                          : 0.0),
                  (topSide?.width ?? 0.0) / 2),
          rect.topRight +
              Offset(-borderRadius.topRight.x, (topSide?.width ?? 0.0) / 2),
          paint);
    }

    if (topRightCornerSide != null) {
      paint = createPaintForBorder(topRightCornerSide!);
      if (borderRadius.topRight.x != 0.0) {
        canvas.drawArc(
          rectForCorner(topRightCornerSide!.width, rect.topRight,
              borderRadius.topRight, -1, 1),
          pi / 2 * 3,
          pi / 2,
          false,
          paint,
        );
      }
    }

    if (rightSide != null) {
      paint = createPaintForBorder(rightSide!);
      canvas.drawLine(
          rect.topRight +
              Offset(
                  -1 * (rightSide?.width ?? 0.0) / 2,
                  borderRadius.topRight.y +
                      (borderRadius.topRight.x == 0
                          ? (topSide?.width ?? 0.0)
                          : 0.0)),
          rect.bottomRight +
              Offset(-1 * (rightSide?.width ?? 0.0) / 2,
                  -borderRadius.bottomRight.y),
          paint);
    }

    if (bottomRightCornerSide != null) {
      paint = createPaintForBorder(bottomRightCornerSide!);
      if (borderRadius.bottomRight.x != 0.0) {
        canvas.drawArc(
          rectForCorner(bottomRightCornerSide!.width, rect.bottomRight,
              borderRadius.bottomRight, -1, -1),
          pi / 2 * 0,
          pi / 2,
          false,
          paint,
        );
      }
    }

    if (bottomSide != null) {
      paint = createPaintForBorder(bottomSide!);
      canvas.drawLine(
          rect.bottomRight +
              Offset(
                  -borderRadius.bottomRight.x -
                      (borderRadius.bottomRight.x == 0
                          ? (rightSide?.width ?? 0.0)
                          : 0.0),
                  -1 * (bottomSide?.width ?? 0.0) / 2),
          rect.bottomLeft +
              Offset(borderRadius.bottomLeft.x,
                  -1 * (bottomSide?.width ?? 0.0) / 2),
          paint);
    }

    if (bottomLeftCornerSide != null) {
      paint = createPaintForBorder(bottomLeftCornerSide!);
      if (borderRadius.bottomLeft.x != 0.0) {
        canvas.drawArc(
          rectForCorner(bottomLeftCornerSide!.width, rect.bottomLeft,
              borderRadius.bottomLeft, 1, -1),
          pi / 2 * 1,
          pi / 2,
          false,
          paint,
        );
      }
    }

    if (leftSide != null) {
      paint = createPaintForBorder(leftSide!);
      canvas.drawLine(
          rect.bottomLeft +
              Offset(
                  (leftSide?.width ?? 0.0) / 2,
                  -borderRadius.bottomLeft.y -
                      (borderRadius.bottomLeft.x == 0
                          ? (bottomSide?.width ?? 0.0)
                          : 0.0)),
          rect.topLeft +
              Offset((leftSide?.width ?? 0.0) / 2, borderRadius.topLeft.y),
          paint);
    }
  }
}
