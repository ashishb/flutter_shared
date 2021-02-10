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
    final Color outlinedColor = Theme.of(context).primaryColor;
    int groupValue;

    if (widget.value != null) {
      groupValue = widget.value;
    } else {
      groupValue = null;
    }

    IconData icon = index < 2 ? Icons.thumb_down : Icons.thumb_up;
    IconData outlinedIcon =
        index < 2 ? Icons.thumb_down_outlined : Icons.thumb_up_outlined;

    Color iconColor;

    if (index < 2) {
      icon = Icons.thumb_down;
      outlinedIcon = Icons.thumb_down_outlined;

      iconColor = Colors.red[300];
    } else {
      icon = Icons.thumb_up;
      outlinedIcon = Icons.thumb_up_outlined;

      iconColor = Colors.red[300];
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
              color:
                  Utils.darken(groupValue == index ? iconColor : outlinedColor),
            ),
            Positioned(
              right: 6,
              top: 2,
              child: Icon(
                groupValue == index ? icon : outlinedIcon,
                color: groupValue == index ? iconColor : outlinedColor,
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
