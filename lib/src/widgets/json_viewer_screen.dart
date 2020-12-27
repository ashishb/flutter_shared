import 'package:flutter/material.dart';
import 'package:flutter_shared/flutter_shared.dart';

class JsonViewerScreen extends StatelessWidget {
  const JsonViewerScreen({
    @required this.map,
    @required this.title,
  });

  final Map<String, dynamic> map;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: JsonViewerWidget(map),
      ),
    );
  }
}
