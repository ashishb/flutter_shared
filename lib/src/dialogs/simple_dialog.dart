import 'dart:async';
import 'package:flutter/material.dart';

Future<T?> showSimpleDialog<T>({
  required BuildContext context,
  required String title,
  required List<Widget> children,
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<T>(
    context: context,
    transitionBuilder: (context, a1, a2, widget) {
      final curvedValue = Curves.easeOut.transform(a1.value) - 1.0;
      return Transform(
        transform: Matrix4.translationValues(0.0, -curvedValue * 200, 0.0),
        child: Opacity(
          opacity: a1.value,
          child: SimpleDialog(
            // contentPadding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            children: children,
          ),
        ),
      );
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: '',
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation1, animation2) {
      return Container();
    },
  );
}
