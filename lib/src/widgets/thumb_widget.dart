import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_shared/flutter_shared.dart';

class ThumbWidget extends StatelessWidget {
  const ThumbWidget({
    @required this.index,
    @required this.selectedIndex,
    this.iconSize = 24,
    this.opacity = 1,
  });

  final int index; // 0-3
  final int selectedIndex; // 0-3
  final double iconSize;
  final double opacity;

  Widget _thumb(int index) {
    final Color outlinedColor = Color.fromRGBO(150, 150, 150, opacity);

    IconData icon;
    IconData outlinedIcon;

    final bool isSelected = selectedIndex == index;

    Color iconColor;
    const double xOffset = 5;
    double yOffset = 1;

    if (index < 2) {
      icon = FontAwesome.thumbs_down;
      outlinedIcon = FontAwesome.thumbs_down;

      iconColor = Colors.red[800].withOpacity(opacity);
    } else {
      icon = FontAwesome.thumbs_up;
      outlinedIcon = FontAwesome.thumbs_up;
      yOffset *= -1;

      iconColor = Colors.green[800].withOpacity(opacity);
    }

    final isDouble = index == 0 || index == 3;

    Color firstIconColor = isSelected ? iconColor : outlinedColor;
    if (isDouble) {
      firstIconColor = Utils.darken(firstIconColor, .05);
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
              child: ClipRect(
                clipper: const RectClipper(),
                child: Icon(
                  isSelected ? icon : outlinedIcon,
                  color: Colors.black54,
                  size: iconSize,
                ),
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
