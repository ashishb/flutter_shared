import 'package:flutter/material.dart';
import 'package:flutter_shared/flutter_shared.dart';

class DoubleThumbsControl extends StatefulWidget {
  const DoubleThumbsControl({
    @required this.value,
    @required this.onChanged,
  });

  // or null if not set
  final int value; // 0-3
  final ValueChanged<int> onChanged;

  @override
  _DoubleThumbsControlState createState() => _DoubleThumbsControlState();
}

class _DoubleThumbsControlState extends State<DoubleThumbsControl> {
  Widget _thumb(int index) {
    const Color outlinedColor = Color.fromRGBO(222, 222, 222, 1);
    int groupValue;

    if (widget.value != null) {
      groupValue = widget.value;
    } else {
      groupValue = null;
    }

    IconData icon = index < 2 ? Icons.thumb_down : Icons.thumb_up;
    IconData outlinedIcon = index < 2 ? Icons.thumb_down : Icons.thumb_up;

    Color iconColor;
    double iconSize = 24;
    double xOffset = 4;
    double yOffset = 1;

    if (index < 2) {
      icon = Icons.thumb_down;
      outlinedIcon = Icons.thumb_down;
      xOffset *= -1;
      yOffset *= -1;

      iconColor = Colors.red[600];
    } else {
      icon = Icons.thumb_up;
      outlinedIcon = Icons.thumb_up;

      iconColor = Colors.green;
    }

    final isDouble = index == 0 || index == 3;

    Color firstIconColor = groupValue == index ? iconColor : outlinedColor;
    if (isDouble) {
      firstIconColor = Utils.darken(firstIconColor, .05);

      iconSize += 4;
    }

    return InkWell(
      onTap: () {
        int newResult;

        if (groupValue != index) {
          newResult = index;
        }

        widget.onChanged(newResult);

        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              groupValue == index ? icon : outlinedIcon,
              color: firstIconColor,
              size: iconSize,
            ),
            // white shadow
            Visibility(
              visible: isDouble,
              child: Positioned(
                right: index == 0 ? xOffset + 1 : xOffset - 1,
                bottom: yOffset,
                child: Icon(
                  groupValue == index ? icon : outlinedIcon,
                  color: Colors.white60,
                  size: iconSize,
                ),
              ),
            ),
            Visibility(
              visible: isDouble,
              child: Positioned(
                right: xOffset,
                bottom: yOffset,
                child: Icon(
                  groupValue == index ? icon : outlinedIcon,
                  color: groupValue == index ? iconColor : outlinedColor,
                  size: iconSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _thumb(0),
        _thumb(1),
        _thumb(2),
        _thumb(3),
      ],
    );
  }
}
