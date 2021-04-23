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
    } else {
      print('## debouncer running');

      _timer = Timer(
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
  }

  void runImmediate(VoidCallback action) {
    if (_timer != null) {
      if (debug) {
        print('## debouncer already running');
      }
    } else {
      action();

      print('## debouncer running');

      _timer = Timer(
        Duration(milliseconds: milliseconds),
        () {
          _timer.cancel();
          _timer = null;

          if (debug) {
            print('## debouncer done');
          }
        },
      );
    }
  }
}
