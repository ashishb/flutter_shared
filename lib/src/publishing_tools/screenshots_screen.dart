import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_shared/flutter_shared.dart';
import 'package:flutter_shared/src/publishing_tools/phone_menu.dart';
import 'package:flutter_shared/src/publishing_tools/screenshot_maker.dart';
import 'package:flutter_shared/src/publishing_tools/screenshot_menu.dart';
import 'package:flutter_shared/src/publishing_tools/size_menu.dart';

class ScreenshotsScreen extends StatefulWidget {
  const ScreenshotsScreen({
    @required this.imagePath,
  });

  final String imagePath;

  @override
  _ScreenshotsScreenState createState() => _ScreenshotsScreenState();
}

class _ScreenshotsScreenState extends State<ScreenshotsScreen> {
  ScreenshotMaker maker = ScreenshotMaker();
  Future<CaptureResult> _image;
  PhoneMenuItem selectedItem = PhoneMenuItem.items[0];
  bool _showBackground = false;
  SizeMenuItem sizeMenuItem =
      SizeMenuItem(title: 'Image Size', type: SizeType.imageSize);

  ScreenshotMenuItem selectedScreenshotItem =
      ScreenshotMenuItem(filename: 'default', title: 'Select Title');

  ui.Image uiImage;

  @override
  void initState() {
    super.initState();

    Utils.loadImageFromPath(widget.imagePath).then((ui.Image image) {
      uiImage = image;
      setState(() {});

      refreshPreview();
    });
  }

  Future<void> refreshPreview() async {
    // delay since we could modify a state var that won't be synced until next refresh
    await Future.delayed(Duration.zero, () {});

    setState(() {
      _image = maker.createImage(
        uiImage,
        selectedScreenshotItem.title,
        selectedItem.type,
        showBackground: _showBackground,
        resultImageSize: sizeMenuItem.type,
      );
    });
  }

  Future<void> _saveClicked() async {
    // ask user for file name
    final String fileName = await showStringDialog(
      context: context,
      title: 'Filename',
      message: 'Choose a file name',
      defaultName: selectedScreenshotItem.filename,
    );

    if (Utils.isNotEmpty(fileName)) {
      try {
        final ui.Image assetImage = await Utils.loadUiImage(widget.imagePath);

        final CaptureResult capture = await maker.createImage(
          assetImage,
          selectedScreenshotItem.title,
          selectedItem.type,
          showBackground: _showBackground,
          resultImageSize: sizeMenuItem.type,
        );

        await maker.saveToFile(fileName, capture);
      } catch (e) {
        print(e);
      }

      Utils.showSnackbar(
        context,
        'Generate Complete',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screenshot capture'),
      ),
      body: FutureBuilder<CaptureResult>(
        future: _image,
        builder: (BuildContext context, AsyncSnapshot<CaptureResult> snapshot) {
          return SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  PhoneMenu(
                    onItemSelected: (PhoneMenuItem item) {
                      setState(() {
                        selectedItem = item;
                      });

                      refreshPreview();
                    },
                    selectedItem: selectedItem,
                  ),
                  const SizedBox(height: 10),
                  ScreenshotMenu(
                    onItemSelected: (ScreenshotMenuItem item) {
                      setState(() {
                        selectedScreenshotItem = item;
                      });

                      refreshPreview();
                    },
                    selectedItem: selectedScreenshotItem,
                  ),
                  CheckboxListTile(
                    value: _showBackground,
                    title: const Text('Show Background'),
                    onChanged: (x) {
                      setState(() {
                        _showBackground = x;
                      });

                      refreshPreview();
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizeMenu(
                        onItemSelected: (SizeMenuItem item) {
                          setState(() {
                            sizeMenuItem = item;
                          });

                          refreshPreview();
                        },
                        selectedItem: sizeMenuItem,
                      ),
                      const SizedBox(width: 12),
                      ColoredButton(
                        onPressed: _saveClicked,
                        title: 'Save',
                      ),
                    ],
                  ),
                  if (snapshot.connectionState == ConnectionState.waiting)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else if (snapshot.hasData) ...[
                    Text(
                      '${snapshot.data.width} x ${snapshot.data.height}',
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      margin: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade300, width: 2.0),
                      ),
                      child: Image.memory(
                        snapshot.data.data,
                        // scale: MediaQuery.of(context).devicePixelRatio,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
