import 'package:flutter/material.dart';
import 'package:flutter_shared/src/widgets/ttext.dart';

class PrimaryTitle extends StatelessWidget {
  const PrimaryTitle({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: TText(
        title,
        style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
