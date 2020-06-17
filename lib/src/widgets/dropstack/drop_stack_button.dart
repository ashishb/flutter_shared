import 'package:flutter/material.dart';
import 'package:flutter_shared/flutter_shared.dart';
import 'package:flutter_shared/src/widgets/dropstack/drop_stack.dart';
import 'package:flutter_shared/src/widgets/dropstack/floating_action_bubble.dart';
import 'package:provider/provider.dart';

class DropStackButton extends StatefulWidget {
  const DropStackButton({@required this.directory});
  final ServerFile directory;

  @override
  _DropStackButtonState createState() => _DropStackButtonState();
}

class _DropStackButtonState extends State<DropStackButton>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);

    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationController = null;

    super.dispose();
  }

  List<ActionBubble> _items(BuildContext context, DropStack dropStack) {
    const double fontSize = 14;
    const Color bubbleColor = Colors.cyan;
    const Color textColor = Colors.white;

    final List<ActionBubble> result = <ActionBubble>[];

    result.add(ActionBubble(
      title: 'Clear Stack',
      iconColor: textColor,
      bubbleColor: bubbleColor,
      icon: Icons.clear_all,
      titleStyle: const TextStyle(fontSize: fontSize, color: textColor),
      onPressed: () {
        dropStack.clear();
        _animationController?.reverse();
      },
    ));

    if (dropStack.count > 1) {
      result.add(ActionBubble(
        title: 'Drop Top Only',
        iconColor: textColor,
        bubbleColor: bubbleColor,
        icon: Icons.file_download,
        titleStyle: const TextStyle(fontSize: fontSize, color: textColor),
        onPressed: () async {
          await dropStack.drop(
              context: context, directory: widget.directory, topOnly: true);

          _animationController?.reverse();
        },
      ));
    }

    result.add(ActionBubble(
      title: 'Drop Here',
      iconColor: textColor,
      bubbleColor: bubbleColor,
      icon: Icons.file_download,
      titleStyle: const TextStyle(fontSize: fontSize, color: textColor),
      onPressed: () async {
        await dropStack.drop(
            context: context, directory: widget.directory, topOnly: false);

        _animationController?.reverse();
      },
    ));

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: DropStack(),
      builder: (context, child) {
        final DropStack dropStack = Provider.of<DropStack>(context);

        return FloatingActionBubble(
          title: dropStack.count.toString(),
          tooltip: 'Drop Stack',
          items: _items(context, dropStack),
          animation: _animation,
          onPressed: () {
            _animationController.isCompleted
                ? _animationController.reverse()
                : _animationController.forward();
          },
          icon: AnimatedIcons.menu_close,
        );
      },
    );
  }
}
