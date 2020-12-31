import 'package:flutter/material.dart';
import 'package:flutter_shared/src/backgrounds/gradient_painter.dart';
import 'package:simple_animations/simple_animations.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    @required this.child,
    @required this.startColor,
    @required this.endColor,
  });

  final Widget child;
  final Color startColor;
  final Color endColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: _buildPainter(context)),
        Positioned.fill(child: child),
      ],
    );
  }

  Widget _buildPainter(BuildContext context) {
    final tween = Tween<double>(
      begin: 0,
      end: 1,
    );

    return MirrorAnimation<double>(
      tween: tween,
      duration: const Duration(seconds: 2),
      builder: (BuildContext context, _, double value) {
        return CustomPaint(
          painter: GradientPainter(
              value: value, startColor: startColor, endColor: endColor),
        );
      },
    );
  }
}
