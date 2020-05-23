import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shared/flutter_shared.dart';
import 'package:flutter_shared/src/widgets/image/image_viewer.dart';

class SuperImage extends StatelessWidget {
  const SuperImage(
    this.urlOrPath, {
    this.useImageFile,
    Key key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.enableViewer = false,
    this.swiperUrls,
  }) : super(key: key);

  final String urlOrPath;
  final double width;
  final double height;
  final BoxFit fit;
  final bool useImageFile;
  final bool enableViewer;
  final List<String> swiperUrls;

  Widget _loadStateChanged(BuildContext context, ExtendedImageState state) {
    Widget result;

    switch (state.extendedImageLoadState) {
      case LoadState.loading:
        if (!useImageFile) {
          result = const Center(
            child: CircularProgressIndicator(),
          );
        }
        break;
      case LoadState.failed:
        result = InkWell(
          onTap: () {
            state.reLoadImage();
          },
          child: const Icon(
            Icons.error,
            size: 30,
            color: Colors.red,
          ),
        );
        break;
      case LoadState.completed:
        if (enableViewer) {
          // not sure what this is for
          // final Widget child = ExtendedRawImage(
          //   image: state.extendedImageInfo?.image,
          // );
          final Widget child = state.completedWidget;

          ImageSwiperItem swiperItem;
          int index = 0;
          final List<ImageSwiperItem> swiperItems = [];

          if (swiperUrls != null) {
            for (int i = 0; i < swiperUrls.length; i++) {
              final String u = swiperUrls[i];

              final ImageSwiperItem item = ImageSwiperItem(u);

              if (u == urlOrPath) {
                swiperItem = item;
                index = i;
              }

              swiperItems.add(item);
            }
          } else {
            swiperItem = ImageSwiperItem(urlOrPath);
            swiperItems.add(swiperItem);
          }

          result = GestureDetector(
            onTap: () {
              Navigator.of(context).push(InvisibleMaterialPageRoute<void>(
                builder: (BuildContext context) => ImageViewer(
                  index: index,
                  swiperItems: swiperItems,
                  useImageFile: useImageFile,
                ),
              ));
            },
            child: Hero(
              tag: swiperItem.heroTag,
              // since we have box.fit cover, we had to customize this
              flightShuttleBuilder: (
                BuildContext flightContext,
                Animation<double> animation,
                HeroFlightDirection flightDirection,
                BuildContext fromHeroContext,
                BuildContext toHeroContext,
              ) {
                final Hero hero = flightDirection != HeroFlightDirection.push
                    ? fromHeroContext.widget as Hero
                    : toHeroContext.widget as Hero;
                return hero.child;
              },
              child: child,
            ),
          );
        }

        break;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (Utils.isNotEmpty(urlOrPath)) {
      if (useImageFile) {
        return ExtendedImage.file(
          File(urlOrPath),
          width: width,
          height: height,
          fit: fit,
          loadStateChanged: (state) => _loadStateChanged(context, state),
        );
      } else {
        if (urlOrPath.isAssetUrl) {
          return ExtendedImage.asset(
            urlOrPath,
            width: width,
            fit: fit,
            loadStateChanged: (state) => _loadStateChanged(context, state),
          );
        }

        return ExtendedImage.network(
          urlOrPath,
          width: width,
          fit: fit,
          cache: true,
          loadStateChanged: (state) => _loadStateChanged(context, state),
        );
      }
    }
    return NothingWidget();
  }
}

class InvisibleMaterialPageRoute<T> extends TransparentMaterialPageRoute<T> {
  InvisibleMaterialPageRoute({
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
