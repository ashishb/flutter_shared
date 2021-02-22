import 'package:flutter/material.dart';
import 'package:flutter_shared/flutter_shared.dart';

class ActionHeader extends StatelessWidget {
  const ActionHeader({
    this.title,
    this.onTap,
    this.iconData,
    this.top = 0,
    this.bottom = 0,
    this.textStyle,
    this.iconSize = 20,
    this.upperCase = true,
    this.subtitle,
    this.subWidget,
    this.action,
  });

  final String title;
  final IconData iconData;
  final void Function() onTap;
  final double top;
  final double bottom;
  final TextStyle textStyle;
  final double iconSize;
  final bool upperCase;
  final String subtitle;
  final Widget action;
  final Widget subWidget;

  TextStyle _textStyle(BuildContext context) {
    if (textStyle != null) {
      return textStyle;
    }

    return ActionHeader.defaultTextStyle(context);
  }

  static TextStyle defaultTextStyle(BuildContext context) {
    return ThemeSetManager.header(context);
  }

  static TextStyle defaultSubtitleStyle(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.caption;

    textStyle = textStyle.copyWith(
      color: textStyle.color.withOpacity(.6),
    );

    return textStyle;
  }

  @override
  Widget build(BuildContext context) {
    Widget subtitleWidget = NothingWidget();

    if (subWidget != null) {
      subtitleWidget = subWidget;
    } else if (Utils.isNotEmpty(subtitle)) {
      subtitleWidget = Text(
        subtitle,
        style: defaultSubtitleStyle(context),
      );
    }
    return Padding(
      padding: EdgeInsets.only(bottom: bottom, top: top),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  // padding makes it align with icon
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    upperCase ? title.toUpperCase() : title,
                    style: _textStyle(context),
                  ),
                ),
                subtitleWidget,
              ],
            ),
          ),
          if (iconData != null)
            IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints.tight(const Size(32, 32)),
              iconSize: iconSize,
              // icon: Icon(iconData, color: _textStyle(context).color),
              icon: Icon(iconData, color: Theme.of(context).accentColor),
              onPressed: onTap,
            ),
          if (action != null) action,
        ],
      ),
    );
  }
}
