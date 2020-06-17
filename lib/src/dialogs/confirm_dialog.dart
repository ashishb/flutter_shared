import 'package:flutter/material.dart';
import 'package:flutter_shared/flutter_shared.dart';

Future<bool> showConfirmDialog({
  @required BuildContext context,
  @required String title,
  String message,
  List<Widget> children = const <Widget>[],
  String okButtonName = 'OK',
  String cancelButtonName = 'Cancel',
}) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true, // can return null
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              if (Utils.isNotEmpty(message)) Text(message),
              ...children,
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(cancelButtonName,
                style: TextStyle(color: Theme.of(context).accentColor)),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(okButtonName,
                style: TextStyle(color: Theme.of(context).primaryColor)),
          ),
        ],
      );
    },
  );
}
