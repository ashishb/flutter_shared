import 'package:flutter/material.dart';

class ThumbsUpControl extends StatefulWidget {
  const ThumbsUpControl({
    @required this.value,
    @required this.onChanged,
  });

  // or null if not set
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  _ThumbsUpControlState createState() => _ThumbsUpControlState();
}

class _ThumbsUpControlState extends State<ThumbsUpControl> {
  @override
  Widget build(BuildContext context) {
    int groupValue;
    if (widget.value != null) {
      groupValue = widget.value ? 1 : 0;
    } else {
      groupValue = null;
    }

    final Color iconColor = Theme.of(context).primaryColor;
    final Color upColor = Colors.green[300];
    final Color downColor = Colors.red[300];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            bool newResult;

            if (groupValue != 1) {
              newResult = true;
            }

            widget.onChanged(newResult);

            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              groupValue == 1 ? Icons.thumb_up : Icons.thumb_up_outlined,
              color: groupValue == 1 ? upColor : iconColor,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            bool newResult;

            if (groupValue != 0) {
              newResult = false;
            }

            widget.onChanged(newResult);

            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              groupValue == 0 ? Icons.thumb_down : Icons.thumb_down_outlined,
              color: groupValue == 0 ? downColor : iconColor,
            ),
          ),
        )
      ],
    );
  }
}
