import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter_shared/flutter_shared.dart';

double initScale({Size imageSize, Size size, double initialScale}) {
  // final n1 = imageSize.height / imageSize.width;
  // final n2 = size.height / size.width;

  // if (n1 > n2) {
  //   final FittedSizes fittedSizes =
  //       applyBoxFit(BoxFit.contain, imageSize, size);
  //   final Size destinationSize = fittedSizes.destination;

  //   return size.width / destinationSize.width;
  // } else if (n1 / n2 < 1 / 4) {
  //   final FittedSizes fittedSizes =
  //       applyBoxFit(BoxFit.contain, imageSize, size);
  //   final Size destinationSize = fittedSizes.destination;

  //   return size.height / destinationSize.height;
  // }

  return .9;
}

class ImageViewer extends StatefulWidget {
  const ImageViewer({this.index, this.swiperItems});

  final int index;
  final List<ImageSwiperItem> swiperItems;

  @override
  _ImageSwiperState createState() => _ImageSwiperState();
}

class _ImageSwiperState extends State<ImageViewer>
    with SingleTickerProviderStateMixin {
  StreamController<int> rebuildIndex = StreamController<int>.broadcast();
  StreamController<bool> rebuildSwiper = StreamController<bool>.broadcast();
  AnimationController _animationController;
  Animation<double> _animation;
  void Function() animationListener;
  List<double> doubleTapScales = <double>[1.0, 2.0];
  GlobalKey<ExtendedImageSlidePageState> slidePagekey =
      GlobalKey<ExtendedImageSlidePageState>();
  int currentIndex;
  bool _showSwiper = true;

  @override
  void initState() {
    currentIndex = widget.index;
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    rebuildIndex.close();
    rebuildSwiper.close();
    _animationController?.dispose();
    clearGestureDetailsCache();
    super.dispose();
  }

  Widget heroBuilderForSlidingPage(Widget result, int index, String heroTag) {
    if (index < min(9, widget.swiperItems.length)) {
      return Hero(
        tag: heroTag,
        child: result,
      );
    } else {
      return result;
    }
  }

  GestureConfig initGestureConfigHandler(
    ExtendedImageState state,
    Size size,
  ) {
    double initialScale = 1.0;

    if (state.extendedImageInfo != null &&
        state.extendedImageInfo.image != null) {
      initialScale = initScale(
          size: size,
          initialScale: initialScale,
          imageSize: Size(state.extendedImageInfo.image.width.toDouble(),
              state.extendedImageInfo.image.height.toDouble()));
    }
    return GestureConfig(
      inPageView: true,
      initialScale: initialScale,
      maxScale: max(initialScale, 10.0),
      animationMaxScale: max(initialScale, 10.0),
      cacheGesture: false,
    );
  }

  void onDoubleTap(ExtendedImageGestureState state) {
    final pointerDownPosition = state.pointerDownPosition;
    final double begin = state.gestureDetails.totalScale;
    double end;

    _animation?.removeListener(animationListener);

    _animationController.stop();

    _animationController.reset();

    if (begin == doubleTapScales[0]) {
      end = doubleTapScales[1];
    } else {
      end = doubleTapScales[0];
    }

    animationListener = () {
      state.handleDoubleTap(
          scale: _animation.value, doubleTapPosition: pointerDownPosition);
    };
    _animation =
        _animationController.drive(Tween<double>(begin: begin, end: end));

    _animation.addListener(animationListener);

    _animationController.forward();
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final size = MediaQuery.of(context).size;

    final url = widget.swiperItems[index].url;
    final String heroTag = widget.swiperItems[index].heroTag;

    Widget image;

    if (url.firstChar == '/') {
      image = ExtendedImage.file(
        File(url),
        fit: BoxFit.contain,
        enableSlideOutPage: true,
        mode: ExtendedImageMode.gesture,
        heroBuilderForSlidingPage: (Widget result) =>
            heroBuilderForSlidingPage(result, index, heroTag),
        initGestureConfigHandler: (state) =>
            initGestureConfigHandler(state, size),
        onDoubleTap: onDoubleTap,
      );
    } else {
      image = ExtendedImage.network(
        url,
        fit: BoxFit.contain,
        enableSlideOutPage: true,
        mode: ExtendedImageMode.gesture,
        heroBuilderForSlidingPage: (Widget result) =>
            heroBuilderForSlidingPage(result, index, heroTag),
        initGestureConfigHandler: (state) =>
            initGestureConfigHandler(state, size),
        onDoubleTap: onDoubleTap,
      );
    }

    return GestureDetector(
      onTap: () {
        slidePagekey.currentState.popPage();
        Navigator.pop(context);
      },
      child: image,
    );
  }

  Widget _toolsButton() {
    return Builder(builder: (BuildContext context) {
      return PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert),
        onSelected: (String result) {
          switch (result) {
            case 'copy':
              final String url = widget.swiperItems[currentIndex].url;
              Clipboard.setData(ClipboardData(text: url));

              Utils.showSnackbar(context, 'URL copied to clipboard');
              break;
          }
        },
        itemBuilder: (BuildContext context) {
          return [
            const PopupMenuItem<String>(
              value: 'copy',
              child: Text('Copy URL'),
            ),
          ];
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget imagePage = Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ExtendedImageGesturePageView.builder(
            itemBuilder: _itemBuilder,
            itemCount: widget.swiperItems.length,
            onPageChanged: (int index) {
              currentIndex = index;
              rebuildIndex.add(index);
            },
            controller: PageController(
              initialPage: currentIndex,
            ),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _toolsButton(),
          )
        ],
      ),
    );

    return ExtendedImageSlidePage(
      slidePageBackgroundHandler: (Offset offset, Size pageSize) {
        return Colors.black54;
      },
      key: slidePagekey,
      slideAxis: SlideAxis.both,
      slideType: SlideType.onlyImage,
      onSlidingPage: (state) {
        final showSwiper = !state.isSliding;
        if (showSwiper != _showSwiper) {
          _showSwiper = showSwiper;
          rebuildSwiper.add(_showSwiper);
        }
      },
      child: imagePage,
    );
  }
}

class ImageSwiperItem {
  ImageSwiperItem(this.url, {this.caption = ''}) : heroTag = randomString(10);

  final String url;
  final String caption;
  final String heroTag;
}
