import 'package:flutter/material.dart';
import 'package:flutter_shared/flutter_shared.dart';

class ListRow extends StatelessWidget {
  const ListRow({
    this.leading,
    this.trailing,
    this.title,
    this.subtitle,
    this.subWidget,
    this.onTap,
    this.onLongPress,
    this.color,
    this.padding,
    this.titleStyle,
    this.subtitleStyle,
  });

  final Widget leading;
  final Widget trailing;
  final String title;
  final String subtitle;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final Widget subWidget;
  final void Function() onTap;
  final void Function() onLongPress;
  final Color color;
  final EdgeInsetsGeometry padding;

  static Color backgroundForIndex({
    @required int index,
    @required bool darkMode,
  }) {
    final Color c = darkMode
        ? Colors.white.withOpacity(.02)
        : Colors.black.withOpacity(.01);
    return index % 2 == 0 ? c : null;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> titleChildren = [];

    if (Utils.isNotEmpty(title)) {
      titleChildren.add(Text(
        title,
        overflow: TextOverflow.ellipsis,
        softWrap: false, // keeps title on one line
        style: titleStyle ?? Theme.of(context).textTheme.subtitle1,
        maxLines: 2,
      ));
    }

    if (Utils.isNotEmpty(subtitle)) {
      if (Utils.isNotEmpty(title)) {
        titleChildren.add(const SizedBox(height: 2));
      }

      titleChildren.add(
        Text(
          subtitle,
          overflow: TextOverflow.ellipsis,
          softWrap: false, // keeps title on one line
          style: subtitleStyle ?? Theme.of(context).textTheme.caption,
          maxLines: 2,
        ),
      );
    }

    if (subWidget != null) {
      titleChildren.add(subWidget);
    }

    final List<Widget> rowChildren = [];

    if (leading != null) {
      rowChildren.add(leading);
      rowChildren.add(const SizedBox(width: 14));
    }

    rowChildren.addAll([
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: titleChildren,
        ),
      ),
    ]);

    if (trailing != null) {
      rowChildren.add(trailing);
    }

    return Container(
      color: color,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: Row(
            children: rowChildren,
          ),
        ),
      ),
    );
  }
}
