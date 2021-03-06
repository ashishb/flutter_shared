import 'package:flutter/material.dart';

// this solve the issue of a textfield grabbing focus after the dismissal of a
// dialog. Flutter seems to look for something to focus on and finds
// the text field and puts up the keyboard.  This is annoying.

class MustTapFocusNode extends FocusNode {
  bool enable = false;

  @override
  bool get hasFocus {
    if (enable) {
      return super.hasFocus;
    }
    return false;
  }

  @override
  bool consumeKeyboardToken() {
    if (enable) {
      return super.consumeKeyboardToken();
    }

    return false;
  }
}
