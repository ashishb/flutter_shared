import 'package:flutter/material.dart';

class StadiumButton extends StatelessWidget {
  const StadiumButton({
    @required this.title,
    @required this.onPressed,
    this.raisedStyle = true,
  });

  final String title;
  final bool raisedStyle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
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
          vertical: 12,
          horizontal: 18.0,
        ),
        child: Text(
          title.toUpperCase(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
