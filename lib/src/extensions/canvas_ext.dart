import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

extension ExtendedCanvas on Canvas {
  static const petals = 14, petalWeightDivisor = 2.0;

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
      _drawPetal(paint, radius / 3.2);

      restore();
    }
  }

  void _drawPetal(Paint paint, double radius) {
    final path = Path()
      ..moveTo(0, 0)
      // Could use conicTo instead and pass a weight there, but
      // it works better for me doing it this way.
      ..quadraticBezierTo(
        -radius / petalWeightDivisor,
        radius / 2,
        0,
        radius,
      )
      ..quadraticBezierTo(
        radius / petalWeightDivisor,
        radius / 2,
        0,
        0,
      )
      ..close();

    drawShadow(path, Colors.black, 1.0, false);
    drawPath(path, paint);
  }
}
