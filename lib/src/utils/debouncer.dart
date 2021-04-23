import 'dart:async';

import 'package:flutter/foundation.dart';

class Debouncer {
  Debouncer({this.milliseconds = 500});

  final int milliseconds;
  VoidCallback action;
  Timer _timer;
  static const debug = true;

  void run(VoidCallback action) {
    if (_timer != null) {
      if (debug) {
        print('## debouncer already running');
      }
    }

    _timer ??= Timer(
      Duration(milliseconds: milliseconds),
      () {
        _timer.cancel();
        _timer = null;

        action();

        if (debug) {
          print('## debouncer done');
        }
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

          if (debug) {
            print('## debouncer done');
          }
        },
      );
    } else {
      if (debug) {
        print('## debouncer already running');
      }
    }
  }
}
