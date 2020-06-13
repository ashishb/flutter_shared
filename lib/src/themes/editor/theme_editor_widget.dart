import 'dart:convert';
import 'dart:io';

import 'package:barcode_image/barcode_image.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_shared/flutter_shared.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

class ThemeEditorWidget extends StatefulWidget {
  @override
  _ThemeEditorWidgetState createState() => _ThemeEditorWidgetState();
}

class _ThemeEditorWidgetState extends State<ThemeEditorWidget> {
  void _showQRCodeDialog(BuildContext context) {
    final String jsonStr = json.encode(ThemeSetManager().currentTheme.toMap());

    final List<Widget> children = [
      BarcodeWidget(
        height: 300,
        width: 300,
        backgroundColor: Colors.white,
        barcode: Barcode.qrCode(),
        padding: const EdgeInsets.all(10),
        data: jsonStr,
      ),
      IconButton(
        icon: const Icon(Icons.share),
        onPressed: () async {
          final image = img.Image(320, 320);
          img.fill(image, img.getColor(255, 255, 255));

          drawBarcode(image, Barcode.qrCode(), jsonStr,
              width: 300, height: 300, x: 10, y: 10);

          final Directory directory = await getTemporaryDirectory();

          final String path = p.join(directory.path, 'shareTheme.png');

          File(path).writeAsBytesSync(img.encodePng(image));

          await ShareExtend.share(path, 'image');
        },
      )
    ];

    showWidgetDialog(
        context: context,
        title: 'Scan the QRcode import the current theme.',
        children: children);
  }

  @override
  Widget build(BuildContext context) {
    final String fontName = ThemeSetManager()
        .googleFont
        .replaceFirst('TextTheme', '')
        .fromCamelCase();

    final ThemeSet theme = ThemeSetManager().currentTheme;

    const colorFields = ThemeSetColor.values;

    return Column(
      children: [
        ThemeSetButton(
          themeSets: ThemeSetManager.themeSets,
          onItemSelected: (newTheme) {
            ThemeSetManager().currentTheme = newTheme;
          },
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: colorFields.length,
            itemBuilder: (context, index) {
              return ListRow(
                title: theme.nameForField(colorFields[index]),
                leading: Container(
                  height: 40,
                  width: 40,
                  color: theme.colorForField(colorFields[index]),
                ),
                onTap: () {
                  Navigator.of(context).push<void>(
                    MaterialPageRoute(
                      builder: (context) => ThemeColorEditorScreen(
                          themeSet: theme, field: colorFields[index]),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (context, index) => const Divider(height: 4),
          ),
        ),
        const SizedBox(height: 6),
        SwitchListTile(
          value: ThemeSetManager().lightBackground,
          onChanged: (bool newValue) {
            ThemeSetManager().lightBackground = newValue;
          },
          title: const Text('Light Background'),
        ),
        SwitchListTile(
          value: ThemeSetManager().integratedAppBar,
          onChanged: (bool newValue) {
            ThemeSetManager().integratedAppBar = newValue;
          },
          title: const Text('Integrated app bar'),
        ),
        ListTile(
          trailing: ThemeButton(
            title: 'Change Font',
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/fonts',
              );
            },
          ),
          title: Text(
            fontName,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ThemeButton(
              onPressed: () async {
                final ScanResult result = await BarcodeScanner.scan();

                if (Utils.isNotEmpty(result.rawContent)) {
                  final ThemeSet newTheme = ThemeSet.fromMap(
                      json.decode(result.rawContent) as Map<String, dynamic>);

                  ThemeSetManager.saveTheme(newTheme, scanned: true);
                }
              },
              title: 'Scan Theme',
              icon: const Icon(FontAwesome.qrcode),
            ),
            ThemeButton(
              onPressed: () async {
                _showQRCodeDialog(context);
              },
              title: 'Share Theme',
              icon: const Icon(Icons.share),
            ),
          ],
        ),
      ],
    );
  }
}

class ThemeColorData {
  const ThemeColorData({
    this.name,
    this.color,
  });

  final String name;
  final Color color;
}