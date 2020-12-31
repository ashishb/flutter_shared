import 'package:flutter/material.dart';

class TransparentAppBarTheme extends StatelessWidget {
  const TransparentAppBarTheme({this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final newAppBar =
        Theme.of(context).appBarTheme.copyWith(color: Colors.transparent);

    final newTheme = Theme.of(context).copyWith(
      appBarTheme: newAppBar,
    );

    return Theme(
      data: newTheme,
      child: child,
    );
  }
}
