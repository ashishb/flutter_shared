import 'package:flutter/material.dart';
import 'package:flutter_shared/flutter_shared.dart';

class JsonViewerScreen extends StatelessWidget {
  const JsonViewerScreen({
    @required this.map,
    @required this.title,
    this.onDelete,
  });

  final Map<String, dynamic> map;
  final String title;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];
    if (onDelete != null) {
      actions = [
        IconButton(
          iconSize: 18,
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ];
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: JsonViewerWidget(map),
      ),
    );
  }
}
