import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_shared/flutter_shared.dart';
import 'package:flutter_shared/src/publishing_tools/phone_menu.dart';
import 'package:path_provider/path_provider.dart';

class CaptureResult {
  const CaptureResult(this.data, this.width, this.height);

  final Uint8List data;
  final int width;
  final int height;
}

class ScreenshotMaker {
  final Color phoneColor = const Color.fromRGBO(65, 65, 65, 1);
  final Color phoneFrameColor = const Color.fromRGBO(35, 35, 35, 1);
  static const Color cameraColor = Color.fromRGBO(0, 0, 0, 1);
  final double speakerHeight = 20;
  final Paint dotPaint = Paint()..color = cameraColor;

  Future<CaptureResult> createImage(
      ui.Image assetImage, String title, PhoneType type) async {
    final Size imageSize = Size(
      assetImage.width.toDouble(),
      assetImage.height.toDouble(),
    );
    final double imageAspectRatio = imageSize.width / imageSize.height;

    const double titleBoxHeight = 300;
    const double footerBoxHeight = 150;

    double phoneFrameWidth;
    Radius frameRadius;
    Radius imageFrameRadius;
    double topBezelHeight = 0;
    double bottomBezelHeight = 0;

    switch (type) {
      case PhoneType.iPad:
      case PhoneType.iPhone5:
        frameRadius = const Radius.circular(122);
        imageFrameRadius = const Radius.circular(2);
        break;
      case PhoneType.iPadPro:
        frameRadius = const Radius.circular(122);
        imageFrameRadius = const Radius.circular(40);
        break;
      case PhoneType.iPhone11:
        frameRadius = const Radius.circular(122);
        imageFrameRadius = const Radius.circular(85);
        break;
      case PhoneType.onePlus7t:
      default:
        frameRadius = const Radius.circular(52);
        imageFrameRadius = const Radius.circular(52);
        break;
    }

    switch (type) {
      case PhoneType.iPadPro:
        phoneFrameWidth = 68;
        break;
      case PhoneType.iPad:
      case PhoneType.iPhone5:
        phoneFrameWidth = 48;
        topBezelHeight = 165;
        bottomBezelHeight = topBezelHeight;
        break;
      case PhoneType.iPhone11:
        phoneFrameWidth = 48;
        break;
      case PhoneType.onePlus7t:
      default:
        phoneFrameWidth = 14;
        break;
    }

    final finalHeight = imageSize.height +
        titleBoxHeight +
        footerBoxHeight +
        (phoneFrameWidth * 2) +
        topBezelHeight +
        bottomBezelHeight;
    final Rect resultRect =
        Offset.zero & Size(finalHeight * imageAspectRatio, finalHeight);

    // rect below top border
    Rect phoneRect = Rect.fromLTWH(
      resultRect.left,
      resultRect.top + titleBoxHeight,
      resultRect.width,
      resultRect.height - (titleBoxHeight + footerBoxHeight),
    );

    phoneRect = Rect.fromCenter(
      center: phoneRect.center,
      width: imageSize.width + (phoneFrameWidth * 2),
      height: imageSize.height +
          (phoneFrameWidth * 2) +
          topBezelHeight +
          bottomBezelHeight,
    );

    // rect for the screenshot
    Rect screenshotRect = phoneRect.deflate(phoneFrameWidth);
    screenshotRect = Rect.fromLTWH(
        screenshotRect.left,
        screenshotRect.top + topBezelHeight,
        screenshotRect.width,
        screenshotRect.height - (topBezelHeight + bottomBezelHeight));

    // create canvas to draw on
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    _drawTitle(
      title: title,
      canvas: canvas,
      centerX: resultRect.topCenter.dx,
      startY: resultRect.top,
      titleBoxHeight: titleBoxHeight,
    );

    // draw frame
    final Path path = Path();
    final RRect rrect = RRect.fromRectAndRadius(phoneRect, frameRadius);
    path.addRRect(rrect);

    final fillPaint = Paint();
    fillPaint.color = phoneColor;
    canvas.drawPath(path, fillPaint);

    _drawPhoneButtons(canvas, phoneRect, type);

    // phone frame on top of phone buttons
    final framePaint = Paint();
    framePaint.style = PaintingStyle.stroke;
    framePaint.strokeWidth = 3;
    framePaint.color = phoneFrameColor;
    canvas.drawPath(path, framePaint);

    // draw image
    if (assetImage != null) {
      final Path clipPath = Path();
      final RRect clipRrect =
          RRect.fromRectAndRadius(screenshotRect, imageFrameRadius);
      clipPath.addRRect(clipRrect);

      canvas.save();
      canvas.clipPath(clipPath);

      paintImage(
        canvas: canvas,
        rect: screenshotRect,
        image: assetImage,
        fit: BoxFit.contain,
      );

      canvas.restore();
    }

    switch (type) {
      case PhoneType.iPhone11:
        _drawNotch(
          canvas: canvas,
          appleNotch: true,
          centerX: resultRect.width / 2,
          startY: screenshotRect.top,
        );
        break;
      case PhoneType.onePlus7t:
        _drawNotch(
          canvas: canvas,
          appleNotch: false,
          centerX: resultRect.width / 2,
          startY: screenshotRect.top,
        );
        break;
      case PhoneType.iPadPro:
        _drawFramedCircle(
          radius: 12,
          canvas: canvas,
          centerX: resultRect.width / 2,
          centerY: screenshotRect.top - (phoneFrameWidth / 2),
        );
        break;
      case PhoneType.iPad:
        _drawTopBezelAppleTablet(
          canvas: canvas,
          centerX: resultRect.width / 2,
          centerY:
              screenshotRect.top - ((topBezelHeight + phoneFrameWidth) / 2),
          startY: screenshotRect.top - topBezelHeight,
        );

        // home button
        _drawFramedCircle(
          radius: 62,
          canvas: canvas,
          centerX: resultRect.width / 2,
          centerY: screenshotRect.bottom +
              ((bottomBezelHeight + phoneFrameWidth) / 2),
        );
        break;
      case PhoneType.iPhone5:
        _drawTopBezelApplePhone(
          canvas: canvas,
          centerX: resultRect.width / 2,
          centerY:
              screenshotRect.top - ((topBezelHeight + phoneFrameWidth) / 2),
          startY: screenshotRect.top - topBezelHeight,
        );

        // home button
        _drawFramedCircle(
          radius: 68,
          canvas: canvas,
          centerX: resultRect.width / 2,
          centerY: screenshotRect.bottom +
              ((bottomBezelHeight + phoneFrameWidth) / 2),
        );
        break;
      default:
        break;
    }

    return _pictureToResults(
      pictureRecorder: pictureRecorder,
      imageSize: imageSize,
      rect: resultRect,
    );
  }

  Future<CaptureResult> _pictureToResults({
    ui.PictureRecorder pictureRecorder,
    Size imageSize,
    Rect rect,
  }) async {
    final pic = pictureRecorder.endRecording();
    final ui.Image image =
        await pic.toImage(rect.width.toInt(), rect.height.toInt());

    final ui.Image resizedImage = await resizeImage(image, imageSize);

    final data = await resizedImage.toByteData(format: ui.ImageByteFormat.png);
    final buffer = data.buffer.asUint8List();

    return CaptureResult(buffer, resizedImage.width, resizedImage.height);
  }

  void _drawBackground({
    @required Canvas canvas,
    @required Rect rect,
    @required Color startColor,
    @required Color endColor,
  }) {
    final backPaint = Paint();
    backPaint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight, // 10% of the width, so there are ten blinds.
      colors: <Color>[
        startColor,
        endColor,
      ],
    ).createShader(rect);

    canvas.drawRect(rect, backPaint);
  }

  void _drawTitle({
    @required Canvas canvas,
    @required String title,
    @required double centerX,
    @required double startY,
    @required double titleBoxHeight,
  }) {
    final TextSpan span = TextSpan(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 84,
        fontWeight: FontWeight.bold,
      ),
      text: title,
    );
    final TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    final double w = tp.size.width / 2;
    double h = tp.size.height;
    h = (titleBoxHeight - h) / 2;

    tp.paint(canvas, Offset(centerX - w, startY + h));
  }

  Future<ui.Image> resizeImage(ui.Image image, Size size) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    // enforce 2:1 Google play max aspect ratio
    Size newSize = size;
    final double aspectRatio = size.width / size.height;
    if (aspectRatio < .5) {
      newSize = Size(size.height / 2, size.height);
    }

    final Rect rect = Offset.zero & newSize;

    _drawBackground(
        canvas: canvas,
        rect: rect,
        startColor: Colors.pink,
        endColor: Colors.cyan);

    paintImage(
      canvas: canvas,
      rect: rect,
      image: image,
      fit: BoxFit.contain,
    );

    final pic = pictureRecorder.endRecording();
    final ui.Image result =
        await pic.toImage(newSize.width.toInt(), newSize.height.toInt());

    return result;
  }

  void _drawTopBezelApplePhone({
    @required Canvas canvas,
    @required double centerX,
    @required double centerY,
    @required double startY,
  }) {
    // speaker
    final RRect speakerRRect =
        _drawSpeaker(canvas: canvas, centerX: centerX, startY: centerY);

    // camera dot
    _drawFramedCircle(
      canvas: canvas,
      radius: 16,
      centerX: speakerRRect.left - 58,
      centerY: speakerRRect.top + (speakerHeight / 2),
    );

    // face detect dot
    _drawFramedCircle(
      canvas: canvas,
      radius: 12,
      centerX: centerX,
      centerY: startY + 4,
    );
  }

  void _drawTopBezelAppleTablet({
    @required Canvas canvas,
    @required double centerX,
    @required double centerY,
    @required double startY,
  }) {
    // camera dot
    _drawFramedCircle(
      canvas: canvas,
      radius: 18,
      centerX: centerX,
      centerY: centerY,
    );
  }

  void _drawFramedCircle({
    @required Canvas canvas,
    @required double centerX,
    @required double centerY,
    @required double radius,
  }) {
    // camera dot
    final Paint camPaint = Paint();
    camPaint.color = cameraColor;
    camPaint.style = PaintingStyle.stroke;
    camPaint.strokeWidth = 5;

    final Paint camFillPaint = Paint();
    camFillPaint.color = Colors.white12;

    canvas.drawCircle(
      Offset(centerX, centerY),
      radius,
      camFillPaint,
    );
    canvas.drawCircle(
      Offset(centerX, centerY),
      radius,
      camPaint,
    );
  }

  RRect _drawSpeaker({
    Canvas canvas,
    double centerX,
    double startY,
  }) {
    const speakerHalfW = 78;
    final RRect speakerRRect = RRect.fromLTRBR(
      centerX - speakerHalfW,
      startY - speakerHeight / 2,
      centerX + speakerHalfW,
      startY + speakerHeight / 2,
      const Radius.circular(10),
    );

    final Paint camPaint = Paint();
    camPaint.color = cameraColor;
    camPaint.style = PaintingStyle.stroke;
    camPaint.strokeWidth = 5;

    final Paint camFillPaint = Paint();
    camFillPaint.color = const Color.fromRGBO(0, 0, 0, .35);

    canvas.drawRRect(speakerRRect, camPaint);

    canvas.drawRRect(speakerRRect, camFillPaint);

    return speakerRRect;
  }

  void _drawNotch({
    @required Canvas canvas,
    @required bool appleNotch,
    @required double centerX,
    @required double startY,
  }) {
    final Paint notchPaint = Paint();
    notchPaint.color = phoneColor;

    if (appleNotch) {
      canvas.drawPath(_iPhoneNotchPath(centerX, startY), notchPaint);
    } else {
      canvas.drawPath(_onePlusNotchPath(centerX, startY), notchPaint);
    }

    // draw camera dot
    if (appleNotch) {
      // speaker
      final RRect speakerRRect =
          _drawSpeaker(canvas: canvas, centerX: centerX, startY: startY + 24);

      _drawFramedCircle(
        canvas: canvas,
        radius: 16,
        centerX: speakerRRect.right + 58,
        centerY: speakerRRect.top + (speakerHeight / 2),
      );
    } else {
      const double cameraRadius = 12;

      canvas.drawCircle(Offset(centerX, startY + 23), cameraRadius, dotPaint);
    }
  }

  void _drawPhoneButtons(Canvas canvas, Rect phoneRect, PhoneType type) {
    final Paint paint = Paint();
    paint.color = phoneColor;
    const double volButtonW = 100;
    const double volButtonH = 184;
    const double muteButtonH = 100;
    double volButtonY = phoneRect.top + 300;
    const double stickout = 16;
    const r = Radius.circular(10);
    Rect rect;

    bool drawMuteSwitch = false;
    bool drawButtons = false;
    switch (type) {
      case PhoneType.iPhone11:
      case PhoneType.iPhone5:
        drawMuteSwitch = true;
        drawButtons = true;
        break;
      case PhoneType.onePlus7t:
        drawButtons = true;
        break;
      case PhoneType.iPad:
      case PhoneType.iPadPro:
        break;
      default:
        break;
    }

    // mute switch
    if (drawMuteSwitch) {
      rect = Rect.fromLTWH(
          phoneRect.left - stickout, volButtonY, volButtonW, muteButtonH);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, r), paint);
    }

    if (drawButtons) {
      volButtonY += muteButtonH;
      volButtonY += 82;

      // volume top
      rect = Rect.fromLTWH(
          phoneRect.left - stickout, volButtonY, volButtonW, volButtonH);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, r), paint);

      volButtonY += volButtonH;
      volButtonY += 52;

      // volume bottom
      rect = Rect.fromLTWH(
          phoneRect.left - stickout, volButtonY, volButtonW, volButtonH);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, r), paint);

      // power button
      volButtonY = phoneRect.top + 563;
      rect = Rect.fromLTWH(
        phoneRect.right - (volButtonW - stickout),
        volButtonY,
        volButtonW,
        volButtonH * 1.5,
      );
      canvas.drawRRect(RRect.fromRectAndRadius(rect, r), paint);
    }
  }

  Path _onePlusNotchPath(double centerX, double startY) {
    final Path notchPath = Path();
    final double notchY = startY + 50;
    const double notchWidth = 80;
    const double notchHalf = notchWidth / 2;

    notchPath.moveTo(centerX - notchWidth, startY);

    notchPath.cubicTo(
      centerX - notchHalf,
      startY,
      centerX - notchHalf,
      notchY,
      centerX,
      notchY,
    );

    notchPath.cubicTo(
      centerX + notchHalf,
      notchY,
      centerX + notchHalf,
      startY,
      centerX + notchWidth,
      startY,
    );

    notchPath.close();

    return notchPath;
  }

  Path _iPhoneNotchPath(double centerX, double startY) {
    const double curveLen = 70;
    const double smallCurveLen = 26;
    const double notchWidth = 680;
    const double notchHeight = 86;

    final Path notchPath = Path();
    final double notchY = startY + notchHeight;
    const double notchHalf = notchWidth / 2;
    final double leftX = centerX - notchHalf;
    final double rightX = centerX + notchHalf;

    notchPath.moveTo(leftX - smallCurveLen, startY);

    notchPath.quadraticBezierTo(
      leftX,
      startY,
      leftX,
      startY + smallCurveLen,
    );

    notchPath.lineTo(leftX, notchY - curveLen);

    notchPath.quadraticBezierTo(
      leftX,
      notchY,
      leftX + curveLen,
      notchY,
    );

    notchPath.lineTo(rightX - curveLen, notchY);

    notchPath.quadraticBezierTo(
      rightX,
      notchY,
      rightX,
      notchY - curveLen,
    );

    notchPath.lineTo(rightX, startY + smallCurveLen);

    notchPath.quadraticBezierTo(
      rightX,
      startY,
      rightX + smallCurveLen,
      startY,
    );

    notchPath.close();

    return notchPath;
  }

  Future<String> get documentsPath async {
    String result;

    if (Utils.isIOS) {
      // on Android this give us a data directory for some odd reason
      final Directory dir = await getApplicationDocumentsDirectory();

      result = dir.path;
    } else {
      final Directory dir = await getExternalStorageDirectory();
      result = dir.path;
    }

    return result;
  }

  Future<void> saveToFile(String filename, CaptureResult capture) async {
    String path = await documentsPath;
    path = '$path/${filename}_screenshot.png';

    final File file = File(path);
    file.createSync(recursive: true);

    file.writeAsBytesSync(capture.data);
  }
}
