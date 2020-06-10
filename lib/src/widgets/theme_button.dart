import 'package:flutter/material.dart';
import 'package:flutter_shared/flutter_shared.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({
    this.title,
    @required this.onPressed,
    this.icon,
    this.disabled = false,
    this.padding,
    this.fontSize,
  });

  final String title;
  final void Function() onPressed;
  final Icon icon;
  final bool disabled;
  final double fontSize;
  final EdgeInsets padding;

  Widget buttonLabel() {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: fontSize),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color disabledColor = Theme.of(context).primaryColor;

    final ThemeSet themeSet = ThemeSetManager().currentTheme;

    Color textColor;
    if (themeSet != null) {
      textColor = themeSet.buttonContentColor;
    }

    disabledColor = Utils.lighten(disabledColor);

    if (icon != null) {
      return FlatButton.icon(
        label: buttonLabel(),
        icon: icon,
        color: Theme.of(context).primaryColor,
        disabledColor: disabledColor,
        textColor: textColor ?? Colors.white,
        onPressed: disabled ? null : onPressed,
        padding: padding,
      );
    }
    return FlatButton(
      color: Theme.of(context).primaryColor,
      disabledColor: disabledColor,
      textColor: textColor ?? Colors.white,
      padding: padding,
      onPressed: disabled ? null : onPressed,
      child: buttonLabel(),
    );
  }
}
