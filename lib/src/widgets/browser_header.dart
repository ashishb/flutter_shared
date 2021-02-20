import 'package:flutter/material.dart';
import 'package:flutter_shared/flutter_shared.dart';

class BrowserHeader extends StatelessWidget {
  const BrowserHeader(
    this.header, {
    this.top,
    this.bottom,
    this.subtitle,
  });

  const BrowserHeader.noPadding(
    this.header, {
    this.subtitle,
  })  : top = 0,
        bottom = 0;

  const BrowserHeader.equalPadding(
    this.header,
    double padding, {
    this.subtitle,
  })  : top = padding,
        bottom = padding;

  final String header;
  final double top;
  final double bottom;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    Widget subWidget = NothingWidget();
    final textStyle = Theme.of(context).textTheme.caption;

    if (Utils.isNotEmpty(subtitle)) {
      subWidget = Text(
        subtitle,
        style: textStyle.copyWith(
          color: textStyle.color.withOpacity(.5),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: bottom ?? 14, top: top ?? 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header.toUpperCase(),
            style: ThemeSetManager.header(context),
          ),
          subWidget,
        ],
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
