import 'package:flutter/material.dart';
import 'package:flutter_shared/src/widgets/thumb_widget.dart';

class DoubleThumbsControl extends StatefulWidget {
  const DoubleThumbsControl({
    @required this.value,
    @required this.onChanged,
    this.showText = true,
  });

  // or null if not set
  final int value; // 0-3
  final ValueChanged<int> onChanged;
  final bool showText;

  @override
  _DoubleThumbsControlState createState() => _DoubleThumbsControlState();
}

class _DoubleThumbsControlState extends State<DoubleThumbsControl> {
  Widget _thumb(int index) {
    return InkWell(
      onTap: () {
        int newResult;

        if (widget.value != index) {
          newResult = index;
        }

        widget.onChanged(newResult);

        setState(() {});
      },
      child: ThumbWidget(
        index: index,
        selectedIndex: widget.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String textResult = '';

    switch (widget.value) {
      case 0:
        textResult = 'Strong No';
        break;
      case 1:
        textResult = 'No';
        break;
      case 2:
        textResult = 'Yes';
        break;
      case 3:
        textResult = 'Strong Yes';
        break;
    }

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _thumb(0),
            _thumb(1),
            _thumb(2),
            _thumb(3),
          ],
        ),
        Visibility(
          visible: widget.showText,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Decision: ',
                  style: Theme.of(context).textTheme.caption,
                ),
                Text(
                  textResult ?? '',
                  style: Theme.of(context).textTheme.caption.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
