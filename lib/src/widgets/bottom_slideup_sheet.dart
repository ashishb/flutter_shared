import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shared/flutter_shared.dart';

abstract class SliderContent {
  int itemCount();
  void dispose();
  String stringForCopy();
  Widget itemBuilder(BuildContext context, int index);
  Widget buttonBarBuilder(BuildContext context);
  bool enableCopyButton();
  double get initialChildSize;
  Color backgroundColor(BuildContext context);
}

const BorderRadius _borderRadius = BorderRadius.only(
  topLeft: Radius.circular(30.0),
  topRight: Radius.circular(30.0),
);

class BottomSlideupSheet {
  static Future<void> show({
    BuildContext context,
    SliderContent sliderContent,
  }) {
    return showModalBottomSheet<void>(
      backgroundColor: sliderContent.backgroundColor(context),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: _borderRadius,
      ),
      context: context,
      builder: (context) {
        return _SheetList(sliderContent: sliderContent);
      },
    );
  }
}

class _SheetList extends StatelessWidget {
  const _SheetList({
    Key key,
    this.sliderContent,
  }) : super(key: key);

  final SliderContent sliderContent;

  Widget _tabDecoration(BuildContext context) {
    return Container(
      width: 30,
      height: 5,
      decoration: BoxDecoration(
        color: Utils.isDarkMode(context) ? Colors.grey[600] : Colors.grey[400],
        borderRadius: const BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
    );
  }

  Widget _buttonBar(BuildContext context) {
    Widget copyButton = NothingWidget();

    if (sliderContent.enableCopyButton()) {
      copyButton = InkWell(
        onTap: () {
          final String jsonStr = sliderContent.stringForCopy();
          Clipboard.setData(ClipboardData(text: jsonStr));

          Utils.showCopiedToast(context);
        },
        child: const Icon(Icons.content_copy, size: 26),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        sliderContent.buttonBarBuilder(context),
        copyButton,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(bottom: 20, top: 12.0, right: 20, left: 20),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: sliderContent.initialChildSize,
        maxChildSize: .9,
        minChildSize: .2,
        builder: (BuildContext context, ScrollController controller) {
          // Material is needed for Ink splashes
          return Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _tabDecoration(context),
                const SizedBox(height: 12),
                _buttonBar(context),
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    itemBuilder: sliderContent.itemBuilder,
                    itemCount: sliderContent.itemCount(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
