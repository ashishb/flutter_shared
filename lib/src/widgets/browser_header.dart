import 'package:flutter/material.dart';
import 'package:flutter_shared/flutter_shared.dart';

class BrowserHeader extends StatelessWidget {
  const BrowserHeader(this.header, {this.top, this.bottom});

  const BrowserHeader.noPadding(
    this.header,
  )   : top = 0,
        bottom = 0;

  const BrowserHeader.equalPadding(
    this.header,
    double padding,
  )   : top = padding,
        bottom = padding;

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
    this.textStyle,
    this.iconSize = 20,
    this.upperCase = true,
  });

  final String title;
  final IconData iconData;
  final void Function() onTap;
  final double top;
  final double bottom;
  final TextStyle textStyle;
  final double iconSize;
  final bool upperCase;

  TextStyle _textStyle(BuildContext context) {
    if (textStyle != null) {
      return textStyle;
    }

    return ActionHeader.defaultTextStyle(context);
  }

  static TextStyle defaultTextStyle(BuildContext context) {
    return ThemeSetManager.header(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom, top: top),
      child: Row(
        children: [
          Expanded(
            child: Text(
              upperCase ? title.toUpperCase() : title,
              style: _textStyle(context),
            ),
          ),
          IconButton(
            constraints: BoxConstraints.tight(const Size(32, 32)),
            iconSize: iconSize,
            // icon: Icon(iconData, color: _textStyle(context).color),
            icon: Icon(iconData, color: Theme.of(context).accentColor),
            onPressed: onTap,
          )
        ],
      ),
    );
  }
}
