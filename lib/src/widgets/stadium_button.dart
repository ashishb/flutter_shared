import 'package:flutter/material.dart';

class StadiumButton extends StatelessWidget {
  const StadiumButton({
    @required this.title,
    @required this.onPressed,
    this.raisedStyle = true,
    this.minWidth = 0,
    this.large = false,
  });

  final String title;
  final bool raisedStyle;
  final VoidCallback onPressed;
  final double minWidth;
  final bool large;

  @override
  Widget build(BuildContext context) {
    double vertical = 2;
    double horizontal = 14.0;

    if (large) {
      vertical = 6;
      horizontal = 16.0;
    }

    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: Size(minWidth, 0),
        primary: raisedStyle ? Colors.white : Colors.black87,
        onSurface: Colors.grey,
        backgroundColor:
            raisedStyle ? Theme.of(context).primaryColor : Colors.white70,
        side: BorderSide(
          color: Colors.black.withOpacity(.06),
        ),
        shape: const StadiumBorder(),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: vertical,
          horizontal: horizontal,
        ),
        child: Text(
          title ?? '',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
