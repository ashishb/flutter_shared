import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

extension ExtendedCanvas on Canvas {
  static const petals = 14;
  static const xPetalWeightDivisor = 2.0;
  static const yPetalWeightDivisor = 2.0;
  static const radiusDivisor = 2.2;

  void drawPetals(Color color, Color highlightColor, double radius) {
    final petalShader = RadialGradient(
          colors: [
            highlightColor.withOpacity(.5),
            color.withOpacity(.5),
          ],
          stops: const [
            0,
            .3,
          ],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius)),
        paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius / 107
          ..shader = petalShader;

    for (var i = 0; i < petals; i++) {
      save();

      rotate(2 * pi / petals * i);
      _drawPetal(paint, radius / radiusDivisor);

      restore();
    }
  }

  void _drawPetal(Paint paint, double radius) {
    final path = Path();

    path.moveTo(0, 0);

    path.quadraticBezierTo(
      -radius / xPetalWeightDivisor,
      radius / yPetalWeightDivisor,
      0,
      radius,
    );

    path.quadraticBezierTo(
      radius / xPetalWeightDivisor,
      radius / yPetalWeightDivisor,
      0,
      0,
    );

    path.close();

    drawShadow(path, Colors.black, 1.0, false);
    drawPath(path, paint);
  }
}
