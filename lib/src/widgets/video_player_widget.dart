import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_shared/flutter_shared.dart';
import 'package:flutter_shared/src/widgets/preview_dialog.dart';
import 'package:open_file/open_file.dart';
import 'package:video_player/video_player.dart';

Future<void> showVideoDialog(BuildContext context,
    {ServerFile serverFile, String hostUrl}) {
  return showPreviewDialog(
    backgroundColor: Theme.of(context).primaryColor,
    context: context,
    children: [
      Flexible(
        child: VideoPlayerWidget(serverFile: serverFile, hostUrl: hostUrl),
      ),
    ],
  );
}

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    @required this.serverFile,
    @required this.hostUrl,
  });

  final ServerFile serverFile;
  final String hostUrl;

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    if (widget.serverFile != null) {
      _controller = VideoPlayerController.file(File(widget.serverFile.path));
    } else if (widget.hostUrl != null) {
      _controller = VideoPlayerController.network(widget.hostUrl);
    } else {
      print('you have to set a serverFile or hostUrl in video player.');
    }

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));

    // only autoplay on files, not network
    if (widget.serverFile != null) {
      _controller.play();
    }
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.initialized) {
      return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(_controller),
            _PlayPauseOverlay(controller: _controller),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: VideoProgressIndicator(_controller, allowScrubbing: true),
            ),
          ],
        ),
      );
    }

    return NothingWidget();
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({Key key, this.controller}) : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    final bool hasVideoFile = controller.dataSourceType == DataSourceType.file;

    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_circle_outline,
                      color: Colors.white54,
                      size: 80.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Positioned(
          bottom: 0,
          top: 0,
          right: 10,
          child: controller.value.isPlaying && hasVideoFile
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      OpenFile.open(Uri.parse(controller.dataSource).path);
                    },
                    child: Icon(
                      Utils.isIOS ? Ionicons.ios_open : Ionicons.md_open,
                      color: Colors.white54,
                      size: 32,
                    ),
                  ),
                ),
        ),
        Positioned(
          bottom: 0,
          top: 0,
          left: 10,
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.clear,
                      color: Colors.white54,
                      size: 32,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
