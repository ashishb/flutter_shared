import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_shared/src/backgrounds/animation_timer.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class ParticleBackground extends StatelessWidget {
  const ParticleBackground({@required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Positioned.fill(child: AnimatedBackground()),
        const Positioned.fill(child: Particles(30)),
        Positioned.fill(child: child),
      ],
    );
  }
}

class Particles extends StatefulWidget {
  const Particles(this.numberOfParticles);

  final int numberOfParticles;

  @override
  _ParticlesState createState() => _ParticlesState();
}

class _ParticlesState extends State<Particles> {
  final Random random = Random();

  final List<ParticleModel> particles = [];

  @override
  void initState() {
    List.generate(widget.numberOfParticles, (index) {
      particles.add(ParticleModel(random));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoopAnimation<int>(
      tween: ConstantTween(1),
      builder: (context, child, value) {
        final time =
            DateTime.now().duration(); // Duration() passed since 01.01.1970

        _simulateParticles(time);

        return CustomPaint(
          painter: ParticlePainter(particles, time),
        );
      },
    );
  }

  void _simulateParticles(Duration time) {
    for (final particle in particles) {
      particle.updateParticle(time);
    }
  }
}

enum AniProps { x, y }

class ParticleModel {
  ParticleModel(this.random) {
    restart();
  }
  MultiTween<AniProps> tween;

  double size;
  // AnimationProgress animationProgress;
  Random random;
  double rando;
  AnimationTimer timer;

  void restart({Duration time = Duration.zero}) {
    final startPosition = Offset(-0.2 + 1.4 * random.nextDouble(), 1.2);
    final endPosition = Offset(-0.2 + 1.4 * random.nextDouble(), -0.2);
    final duration = Duration(milliseconds: 3000 + random.nextInt(6000));

    tween = MultiTween<AniProps>()
      ..add(
          AniProps.x,
          Tween<double>(begin: startPosition.dx, end: endPosition.dx),
          duration,
          Curves.easeInOutSine)
      ..add(
          AniProps.y,
          Tween<double>(begin: startPosition.dy, end: endPosition.dy),
          duration,
          Curves.easeIn);

    timer = AnimationTimer(duration);

    rando = random.nextDouble();
    size = 0.1 + rando * 0.5;
  }

  void updateParticle(Duration time) {
    if (timer.progress(time) == 1.0) {
      restart(time: time);
    }
  }
}

class ParticlePainter extends CustomPainter {
  ParticlePainter(this.particles, this.time);

  List<ParticleModel> particles;
  Duration time;

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final progress = particle.timer.progress(time);
      final animation = particle.tween.transform(progress);

      final position = Offset(
        animation.get<double>(AniProps.x) * size.width,
        animation.get<double>(AniProps.y) * size.height,
      );

      final int alpha = 30 + (50 * particle.rando).toInt();

      final paint = Paint()
        ..shader = RadialGradient(
          radius: 5,
          colors: [
            Colors.blue.withAlpha(alpha ~/ 5),
            Colors.blue.withAlpha(alpha)
          ],
          stops: const [0, .4],
        ).createShader(Rect.fromCenter(
            center: position,
            width: size.width * 0.2 * particle.size,
            height: size.width * 0.2 * particle.size));

      canvas.drawCircle(position, size.width * 0.2 * particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
