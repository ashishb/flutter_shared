import 'dart:async';
import 'package:flutter/material.dart';

Future<bool> showWidgetDialog({
  @required BuildContext context,
  @required String title,
  @required List<Widget> children,
  bool showCancel = false,
  String okButtonName = 'OK',
  String cancelButtonName = 'Cancel',
  bool barrierDismissible = true,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: title == null ? null : Text(title),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600.0),
        child: SingleChildScrollView(
          child: Column(
            children: children,
          ),
        ),
      ),
      actions: <Widget>[
        Visibility(
          visible: showCancel,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(cancelButtonName,
                style: TextStyle(color: Theme.of(context).accentColor)),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(okButtonName,
              style: TextStyle(color: Theme.of(context).primaryColor)),
        ),
      ],
    ),
  );
}
