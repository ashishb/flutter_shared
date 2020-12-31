import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class WaveBackground extends StatelessWidget {
  const WaveBackground({@required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double baseHeight = size.height * .2;

    return Stack(
      children: <Widget>[
        // Positioned.fill(child: AnimatedBackground()),
        onBottom(AnimatedWave(
          height: baseHeight + 160.0,
          speed: 1.0,
        )),
        onBottom(AnimatedWave(
          height: baseHeight + 100,
          speed: 0.9,
          offset: pi,
        )),
        onBottom(AnimatedWave(
          height: baseHeight + 200,
          speed: 1.2,
          offset: pi / 2,
        )),
        Positioned.fill(child: child),
      ],
    );
  }

  Widget onBottom(Widget child) => Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );
}

class AnimatedWave extends StatelessWidget {
  const AnimatedWave({this.height, this.speed, this.offset = 0.0});

  final double height;
  final double speed;
  final double offset;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: height,
        width: constraints.biggest.width,
        child: LoopAnimation<double>(
          duration: Duration(milliseconds: (10000 / speed).round()),
          tween: Tween(begin: 0.0, end: 2 * pi),
          builder: (context, _, value) {
            return CustomPaint(
              foregroundPainter: CurvePainter(value + offset),
            );
          },
        ),
      );
    });
  }
}

class CurvePainter extends CustomPainter {
  CurvePainter(this.value);

  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = Colors.blue.withAlpha(60);
    final path = Path();

    final y1 = sin(value);
    final y2 = sin(value + pi / 2);
    final y3 = sin(value + pi);

    final startPointY = size.height * (0.5 + 0.4 * y1);
    final controlPointY = size.height * (0.5 + 0.4 * y2);
    final endPointY = size.height * (0.5 + 0.4 * y3);

    path.moveTo(size.width * 0, startPointY);
    path.quadraticBezierTo(
        size.width * 0.5, controlPointY, size.width, endPointY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
