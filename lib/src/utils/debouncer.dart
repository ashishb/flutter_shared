import 'dart:async';

import 'package:flutter/foundation.dart';

class Debouncer {
  Debouncer({this.milliseconds = 500});

  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  void run(VoidCallback action) {
    _timer ??= Timer(
      Duration(milliseconds: milliseconds),
      () {
        _timer.cancel();
        _timer = null;

        action();
      },
    );
  }

  void runImmediate(VoidCallback action) {
    if (_timer == null) {
      action();

      _timer ??= Timer(
        Duration(milliseconds: milliseconds),
        () {
          _timer.cancel();
          _timer = null;
        },
      );
    }
  }
}
