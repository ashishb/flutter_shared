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
        padding: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 14.0,
        ),
        child: Text(
          title ?? '',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
