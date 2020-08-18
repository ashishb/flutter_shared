import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class TransparentPageRoute<T> extends TransparentMaterialPageRoute<T> {
  TransparentPageRoute({
    @required Widget Function(BuildContext) builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          maintainState: maintainState,
          settings: settings,
          fullscreenDialog: fullscreenDialog,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // animation disabled
    return child;
  }
}
