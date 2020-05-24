import 'dart:math' as math;

extension ExtendedInt on int {
  String get twoDigitTime => '$this'.padLeft(2, '0');

  // degress to radians
  double get inRadians {
    return this * (math.pi / 180);
  }

  String formatBytes(int decimals) {
    if (this == 0) {
      return '0 Bytes';
    }
    const k = 1024;
    final dm = decimals <= 0 ? 0 : decimals;
    final sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    final i = (math.log(this) / math.log(k)).floor();

    return '${(this / math.pow(k, i)).toStringAsFixed(dm)} ${sizes[i]}';
  }
}

extension ExtendedNum on num {
  num difference(num other) => (this - other).abs();
}

extension ExtendedDouble on double {
  double get getRadians {
    return this * math.pi / 180;
  }
}
