import 'dart:async';
import 'package:flutter/material.dart';

Future<bool> showCustomDialog({
  @required BuildContext context,
  @required String title,
  @required List<Widget> children,
  bool showCancel = false,
  String okButtonName = 'OK',
  String cancelButtonName = 'Cancel',
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) => Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: children,
        ),
      ),
    ),
  );
}
