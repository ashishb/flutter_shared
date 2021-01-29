import 'package:flutter/material.dart';

Future<String> showStringDialog({
  @required BuildContext context,
  @required String title,
  @required String message,
  String okButtonName = 'OK',
  String cancelButtonName = 'Cancel',
  String defaultName = '',
  TextInputType keyboardType = TextInputType.text,
  bool barrierDismissible = true,
}) async {
  return showDialog<String>(
    context: context,
    barrierDismissible: barrierDismissible, // if true, null can be returned
    builder: (BuildContext context) {
      return _DialogContents(
        title: title,
        message: message,
        okButtonName: okButtonName,
        defaultName: defaultName,
        cancelButtonName: cancelButtonName,
        keyboardType: keyboardType,
      );
    },
  );
}

class _DialogContents extends StatefulWidget {
  const _DialogContents({
    @required this.title,
    @required this.message,
    this.okButtonName = 'OK',
    this.cancelButtonName = 'Cancel',
    this.defaultName = '',
    this.keyboardType = TextInputType.text,
  });

  final String title;
  final String message;
  final String defaultName;
  final String okButtonName;
  final String cancelButtonName;
  final TextInputType keyboardType;

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
  void dispose() {
    _textController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text(widget.title),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600.0),
        child: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(widget.message),
              const SizedBox(height: 10),
              TextField(
                keyboardType: widget.keyboardType ?? TextInputType.text,
                autofocus: true,
                controller: _textController,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(widget.cancelButtonName,
              style: TextStyle(color: Theme.of(context).accentColor)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_textController.text);
          },
          child: Text(widget.okButtonName,
              style: TextStyle(color: Theme.of(context).primaryColor)),
        ),
      ],
    );
  }
}
