import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_shared/flutter_shared.dart';

class ThumbWidget extends StatelessWidget {
  const ThumbWidget({
    @required this.index,
    @required this.selectedIndex,
  });

  final int index; // 0-3
  final int selectedIndex; // 0-3

  Widget _thumb(int index) {
    const Color outlinedColor = Color.fromRGBO(150, 150, 150, 1);

    IconData icon;
    IconData outlinedIcon;

    final bool isSelected = selectedIndex == index;

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

    Color firstIconColor = isSelected ? iconColor : outlinedColor;
    if (isDouble) {
      firstIconColor = Utils.darken(
        firstIconColor,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            isSelected ? icon : outlinedIcon,
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
                isSelected ? icon : outlinedIcon,
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
                isSelected ? icon : outlinedIcon,
                color: isSelected ? iconColor : outlinedColor,
                size: iconSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _thumb(index);
  }
}
