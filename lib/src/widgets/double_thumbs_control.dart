import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
    const Color outlinedColor = Color.fromRGBO(150, 150, 150, 1);
    int groupValue;

    if (widget.value != null) {
      groupValue = widget.value;
    } else {
      groupValue = null;
    }

    IconData icon;
    IconData outlinedIcon;

    Color iconColor;
    const double iconSize = 24;
    const double xOffset = 6;
    const double yOffset = 1;

    if (index < 2) {
      icon = FontAwesome.thumbs_down;
      outlinedIcon = FontAwesome.thumbs_down;

      iconColor = Colors.red[600];
    } else {
      icon = FontAwesome.thumbs_up;
      outlinedIcon = FontAwesome.thumbs_up;

      iconColor = Colors.green;
    }

    final isDouble = index == 0 || index == 3;

    Color firstIconColor = groupValue == index ? iconColor : outlinedColor;
    if (isDouble) {
      firstIconColor = Utils.darken(firstIconColor, .15);
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
                right: xOffset - 1,
                bottom: yOffset,
                child: Icon(
                  groupValue == index ? icon : outlinedIcon,
                  color: Colors.white54,
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
        const SizedBox(width: 12),
        _thumb(2),
        _thumb(3),
      ],
    );
  }
}
