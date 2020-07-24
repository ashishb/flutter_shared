import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_shared/flutter_shared.dart';
import 'package:flutter_shared/src/publishing_tools/phone_menu.dart';
import 'package:flutter_shared/src/publishing_tools/screenshot_maker.dart';
import 'package:flutter_shared/src/publishing_tools/screenshot_menu.dart';

class ScreenshotsScreen extends StatefulWidget {
  const ScreenshotsScreen({
    @required this.imageUrl,
  });

  final String imageUrl;

  @override
  _ScreenshotsScreenState createState() => _ScreenshotsScreenState();
}

class _ScreenshotsScreenState extends State<ScreenshotsScreen> {
  ScreenshotMaker maker = ScreenshotMaker();
  Future<CaptureResult> _image;
  PhoneMenuItem selectedItem = PhoneMenuItem.items[0];
  bool _showBackground = false;
  ScreenshotMenuItem selectedScreenshotItem =
      ScreenshotMenuItem(filename: 'default', title: 'Select Title');

  ui.Image assetImage;

  @override
  void initState() {
    super.initState();

    Utils.loadUiImage(widget.imageUrl).then((ui.Image image) {
      assetImage = image;
      setState(() {});
    });
  }

  void _onPreviewPressed() {
    setState(() {
      _image = maker.createImage(
          assetImage, selectedScreenshotItem.title, selectedItem.type,
          showBackground: _showBackground);
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
        final ui.Image assetImage = await Utils.loadUiImage(widget.imageUrl);

        final CaptureResult capture = await maker.createImage(
          assetImage,
          selectedScreenshotItem.title,
          selectedItem.type,
          showBackground: _showBackground,
        );

        await maker.saveToFile(fileName, capture);
      } catch (e) {
        print(e);
      }

      Utils.showToast(
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
                    },
                    selectedItem: selectedItem,
                  ),
                  const SizedBox(height: 10),
                  ScreenshotMenu(
                    onItemSelected: (ScreenshotMenuItem item) {
                      setState(() {
                        selectedScreenshotItem = item;
                      });
                    },
                    selectedItem: selectedScreenshotItem,
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _showBackground,
                    title: const Text('Show Background'),
                    onChanged: (x) {
                      setState(() {
                        _showBackground = x;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ColoredButton(
                        onPressed: _onPreviewPressed,
                        title: 'Preview',
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
