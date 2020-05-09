import 'package:flutter/material.dart';

Future<String> showStringDialog({
  @required BuildContext context,
  @required String title,
  @required String message,
  String okButtonName = 'OK',
  String cancelButtonName = 'Cancel',
  String defaultName = '',
}) async {
  return showDialog<String>(
    context: context,
    barrierDismissible: true, // if true, null can be returned
    builder: (BuildContext context) {
      return _DialogContents(
        title: title,
        message: message,
        okButtonName: okButtonName,
        defaultName: defaultName,
        cancelButtonName: cancelButtonName,
      );
    },
  );
}

class _DialogContents extends StatefulWidget {
  const _DialogContents({
    Key key,
    @required this.title,
    @required this.message,
    this.okButtonName = 'OK',
    this.cancelButtonName = 'Cancel',
    this.defaultName = '',
  }) : super(key: key);

  final String title;
  final String message;
  final String defaultName;
  final String okButtonName;
  final String cancelButtonName;

  @override
  __DialogContentsState createState() => __DialogContentsState();
}

class __DialogContentsState extends State<_DialogContents> {
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController(text: widget.defaultName);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(widget.message),
            const SizedBox(height: 10),
            TextField(
              controller: _textController,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(widget.cancelButtonName),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(_textController.text);
          },
          child: Text(widget.okButtonName),
        ),
      ],
    );
  }
}
