import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_shared/flutter_shared.dart';
import 'package:flutter_shared/src/publishing_tools/phone_menu.dart';

class PhoneShapes {
  static Color phoneColor = const Color.fromRGBO(220, 0, 0, 1);
  static Color phoneFrameColor = const Color.fromRGBO(0, 220, 0, 1);
  static const Color cameraColor = Color.fromRGBO(70, 70, 70, 1);
  static double speakerHeight = 20;
  static Paint dotPaint = Paint()..color = cameraColor;

  static void drawTopBezelApplePhone({
    @required Canvas canvas,
    @required double centerX,
    @required double centerY,
    @required double startY,
  }) {
    // speaker
    final RRect speakerRRect =
        drawSpeaker(canvas: canvas, centerX: centerX, startY: centerY);

    // camera dot
    drawFramedCircle(
      canvas: canvas,
      radius: 16,
      centerX: speakerRRect.left - 58,
      centerY: speakerRRect.top + (speakerHeight / 2),
    );

    // face detect dot
    drawFramedCircle(
      canvas: canvas,
      radius: 12,
      centerX: centerX,
      centerY: startY + 4,
    );
  }

  static void drawTopBezelAppleTablet({
    @required Canvas canvas,
    @required double centerX,
    @required double centerY,
    @required double startY,
  }) {
    // camera dot
    drawFramedCircle(
      canvas: canvas,
      radius: 18,
      centerX: centerX,
      centerY: centerY,
    );
  }

  static void drawFramedCircle({
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

  static RRect drawSpeaker({
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

  static void drawNotch({
    @required Canvas canvas,
    @required bool appleNotch,
    @required double centerX,
    @required double startY,
  }) {
    final Paint notchPaint = Paint();
    notchPaint.color = phoneColor;

    if (appleNotch) {
      canvas.drawPath(iPhoneNotchPath(centerX, startY), notchPaint);
    } else {
      canvas.drawPath(onePlusNotchPath(centerX, startY), notchPaint);
    }

    // draw camera dot
    if (appleNotch) {
      // speaker
      final RRect speakerRRect =
          drawSpeaker(canvas: canvas, centerX: centerX, startY: startY + 24);

      drawFramedCircle(
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

  static void drawPhoneButtons(Canvas canvas, Rect phoneRect, PhoneType type) {
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

  static Path onePlusNotchPath(double centerX, double startY) {
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

  static Path iPhoneNotchPath(double centerX, double startY) {
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

  static void drawPhoneNotch({
    @required Canvas canvas,
    @required PhoneType type,
    @required double centerX,
    @required Rect screenshotRect,
    @required double topBezelHeight,
    @required double phoneFrameWidth,
    @required double bottomBezelHeight,
  }) {
    switch (type) {
      case PhoneType.iPhone11:
        drawNotch(
          canvas: canvas,
          appleNotch: true,
          centerX: centerX,
          startY: screenshotRect.top,
        );
        break;
      case PhoneType.onePlus7t:
        drawNotch(
          canvas: canvas,
          appleNotch: false,
          centerX: centerX,
          startY: screenshotRect.top,
        );
        break;
      case PhoneType.iPadPro:
        drawFramedCircle(
          radius: 12,
          canvas: canvas,
          centerX: centerX,
          centerY: screenshotRect.top - (phoneFrameWidth / 2),
        );
        break;
      case PhoneType.iPad:
        drawTopBezelAppleTablet(
          canvas: canvas,
          centerX: centerX,
          centerY:
              screenshotRect.top - ((topBezelHeight + phoneFrameWidth) / 2),
          startY: screenshotRect.top - topBezelHeight,
        );

        // home button
        drawFramedCircle(
          radius: 62,
          canvas: canvas,
          centerX: centerX,
          centerY: screenshotRect.bottom +
              ((bottomBezelHeight + phoneFrameWidth) / 2),
        );
        break;
      case PhoneType.iPhone5:
        drawTopBezelApplePhone(
          canvas: canvas,
          centerX: centerX,
          centerY:
              screenshotRect.top - ((topBezelHeight + phoneFrameWidth) / 2),
          startY: screenshotRect.top - topBezelHeight,
        );

        // home button
        drawFramedCircle(
          radius: 68,
          canvas: canvas,
          centerX: centerX,
          centerY: screenshotRect.bottom +
              ((bottomBezelHeight + phoneFrameWidth) / 2),
        );
        break;
      default:
        break;
    }
  }
}
