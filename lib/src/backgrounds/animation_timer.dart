import 'package:supercharged/supercharged.dart';

class AnimationTimer {
  AnimationTimer(this.duration) {
    startTime = DateTime.now().duration();
  }
  Duration duration;
  Duration startTime;

  double progress(Duration now) {
    return ((now - startTime) / duration).clamp(0.0, 1.0).toDouble();
  }
}
