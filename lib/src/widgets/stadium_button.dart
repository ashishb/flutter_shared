import 'package:flutter/material.dart';

class StadiumButton extends StatelessWidget {
  const StadiumButton({
    @required this.title,
    @required this.onPressed,
    this.raisedStyle = true,
    this.minWidth = 0,
  });

  final String title;
  final bool raisedStyle;
  final VoidCallback onPressed;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: Size(minWidth, 0),
        primary: raisedStyle ? Colors.white : Theme.of(context).primaryColor,
        onSurface: Colors.grey,
        backgroundColor:
            raisedStyle ? Theme.of(context).primaryColor : Colors.white,
        side: BorderSide(
          color: Colors.black.withOpacity(.06),
        ),
        shape: const StadiumBorder(),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 14.0,
        ),
        child: Text(
          (title ?? '').toUpperCase(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
