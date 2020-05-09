import 'dart:async';
import 'package:flutter/material.dart';

Future<void> showWidgetDialog({
  @required BuildContext context,
  @required String title,
  @required List<Widget> children,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          children: children,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
