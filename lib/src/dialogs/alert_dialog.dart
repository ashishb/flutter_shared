import 'dart:async';
import 'package:flutter/material.dart';

Future<void> showAlertDialog({
  @required BuildContext context,
  @required String title,
  @required String message,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) => ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600.0),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(message),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK',
                style: TextStyle(color: Theme.of(context).primaryColor)),
          ),
        ],
      ),
    ),
  );
}
