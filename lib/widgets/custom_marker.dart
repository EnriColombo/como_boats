import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomMarker {
  static Future<Uint8List?> createCustomMarkerBitmap(
      String title, String snippet) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.white;
    final Paint shadowPaint = Paint()..color = Colors.black.withValues(alpha: 0.5);
    final Radius radius = Radius.circular(5.0);

    TextPainter textPainterName = TextPainter(
      textDirection: TextDirection.ltr,
    );
    TextPainter textPainterPrice = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Draw the title (name)
    textPainterName.text = TextSpan(
      text: title,
      style: TextStyle(
        fontSize: 15.0,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainterName.layout();
    double textWidth = textPainterName.width;
    double textHeight = textPainterName.height;

    // Draw the snippet (price)
    String price = "€$snippet/ora";
    textPainterPrice.text = TextSpan(
      text: price,
      style: TextStyle(
        fontSize: 12.0,
        color: Colors.grey[700],
      ),
    );
    textPainterPrice.layout();
    textWidth =
        textWidth > textPainterPrice.width ? textWidth : textPainterPrice.width;
    textHeight += textPainterPrice.height;

    // Draw the background rectangle based on the title text size
    double padding = 8.0;
    double verticalSpacing =
        6.0; // Additional vertical space between name and price
    double arrowHeight = 8.0; // Height of the arrow
    double shadowOffset = 1.0; // Offset for the shadow
    double rectWidth = textWidth + padding;
    double rectHeight = textHeight + padding + verticalSpacing + arrowHeight;

    // Draw the shadow rectangle
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(shadowOffset, shadowOffset, rectWidth, rectHeight - arrowHeight),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      shadowPaint,
    );

    // Draw the background rectangle
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0.0, 0.0, rectWidth, rectHeight - arrowHeight),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      paint,
    );

    // Draw the arrow (triangle) at the bottom center of the rectangle
    Path arrowPath = Path();
    arrowPath.moveTo(rectWidth / 2 - arrowHeight, rectHeight - arrowHeight);
    arrowPath.lineTo(rectWidth / 2 + arrowHeight, rectHeight - arrowHeight);
    arrowPath.lineTo(rectWidth / 2, rectHeight);
    arrowPath.close();
    canvas.drawPath(arrowPath, paint);

    // Draw the name over the rectangle
    textPainterName.paint(canvas, Offset(padding / 2, padding / 2));

    // Draw the price over the rectangle with additional vertical space
    textPainterPrice.paint(
        canvas,
        Offset(padding / 2,
            padding / 2 + textPainterName.height + verticalSpacing));

    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(rectWidth.toInt(), rectHeight.toInt());
    final ByteData? byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();

  }
}