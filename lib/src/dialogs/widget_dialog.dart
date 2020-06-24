import 'dart:async';
import 'package:flutter/material.dart';

Future<bool> showWidgetDialog({
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
    builder: (context) => ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600.0),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        title: title == null ? null : Text(title),
        content: SingleChildScrollView(
          child: Column(
            children: children,
          ),
        ),
        actions: <Widget>[
          Visibility(
            visible: showCancel,
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(cancelButtonName,
                  style: TextStyle(color: Theme.of(context).accentColor)),
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(okButtonName,
                style: TextStyle(color: Theme.of(context).primaryColor)),
          ),
        ],
      ),
    ),
  );
}
