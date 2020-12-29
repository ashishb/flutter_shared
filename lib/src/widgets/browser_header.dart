import 'package:flutter/material.dart';
import 'package:flutter_shared/flutter_shared.dart';

class BrowserHeader extends StatelessWidget {
  const BrowserHeader(this.header, {this.top, this.bottom});

  final String header;
  final double top;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom ?? 14, top: top ?? 24),
      child: Text(
        header.toUpperCase(),
        style: ThemeSetManager.header(context),
      ),
    );
  }
}

class CenteredHeader extends StatelessWidget {
  const CenteredHeader(this.header, {this.top, this.bottom});

  final String header;
  final double top;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom ?? 4, top: top ?? 10),
      child: Text(
        header,
        textAlign: TextAlign.center,
        style: ThemeSetManager.header(context),
      ),
    );
  }
}

class ActionHeader extends StatelessWidget {
  const ActionHeader({
    this.title,
    @required this.onTap,
    @required this.iconData,
    this.top = 0,
    this.bottom = 0,
  });

  final String title;
  final IconData iconData;
  final void Function() onTap;
  final double top;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom, top: top),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: ThemeSetManager.header(context),
            ),
          ),
          IconButton(
            icon: Icon(iconData, color: Theme.of(context).primaryColor),
            onPressed: onTap,
          )
        ],
      ),
    );
  }
}
