import 'package:flutter/material.dart';
import 'package:flutter_shared/flutter_shared.dart';

class ColoredButton extends StatelessWidget {
  const ColoredButton({
    this.title,
    this.label,
    required this.onPressed,
    this.padding,
    this.color,
    this.textColor,
    this.icon,
    this.disabled = false,
  });

  final String? title;
  final Widget? label;
  final void Function() onPressed;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? textColor;
  final Icon? icon;
  final bool disabled;

  Widget? buttonLabel() {
    if (label != null) {
      return label;
    }
    return Text(
      title!,
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color disabledColor = color ?? Theme.of(context).primaryColor;

    disabledColor = Utils.lighten(disabledColor);

    if (icon != null) {
      return TextButton.icon(
        style: TextButton.styleFrom(
          backgroundColor: color ?? Theme.of(context).primaryColor,
          primary: textColor ?? Colors.white,
          padding: padding,
        ),
        onPressed: disabled ? null : onPressed,
        label: buttonLabel()!,
        icon: icon!,
      );
    }
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: color ?? Theme.of(context).primaryColor,
        primary: textColor ?? Colors.white,
        padding: padding,
      ),
      onPressed: disabled ? null : onPressed,
      child: buttonLabel()!,
    );
  }
}

class CircularIconButton extends StatelessWidget {
  const CircularIconButton({
    this.icon,
    this.onPressed,
    this.iconSize = 32,
    this.tooltip,
  });

  final VoidCallback? onPressed;
  final Icon? icon;
  final double iconSize;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Ink(
      padding: const EdgeInsets.all(4),
      decoration: ShapeDecoration(
        color: Theme.of(context).primaryColor,
        shape: const CircleBorder(),
      ),
      child: IconButton(
        tooltip: tooltip,
        iconSize: iconSize,
        color: Colors.white,
        onPressed: onPressed,
        disabledColor: Colors.grey[400],
        icon: icon!,
      ),
    );
  }
}
