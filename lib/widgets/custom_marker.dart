import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomMarker {
  static Future<Uint8List?> createCustomMarkerBitmap(
      String title, String snippet) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.white;
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5);
    final Radius radius = Radius.circular(5.0);

    // Draw the title
    TextPainter textPainterTitle = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: title,
        style: GoogleFonts.roboto(
          fontSize: 14.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    textPainterTitle.layout();
    double textWidth = textPainterTitle.width;
    double textHeight = textPainterTitle.height;

    // Draw the snippet
    TextPainter textPainterSnippet = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: snippet,
        style: GoogleFonts.roboto(
          fontSize: 12.0,
          color: Colors.grey[700],
        ),
      ),
    );
    textPainterSnippet.layout();
    textWidth =
        textWidth > textPainterSnippet.width ? textWidth : textPainterSnippet.width;
    textHeight += textPainterSnippet.height;

    // Draw the background rectangle based on the title text size
    double padding = 8.0;
    // Additional vertical space between title and snippet
    double verticalSpacing = 4.0;
    double arrowHeight = 8.0; // Height of the arrow
    double shadowOffset = 1.0; // Offset for the shadow
    double rectWidth = textWidth + padding;
    double rectHeight = textHeight + padding + verticalSpacing + arrowHeight;

    // Draw the shadow rectangle
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
            shadowOffset, shadowOffset, rectWidth, rectHeight - arrowHeight),
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

    // Draw the title over the rectangle
    textPainterTitle.paint(canvas, Offset(padding / 2, padding / 2));

    // Draw the snippet over the rectangle with additional vertical space
    textPainterSnippet.paint(
        canvas,
        Offset(padding / 2,
            padding / 2 + textPainterTitle.height + verticalSpacing));

    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(rectWidth.toInt(), rectHeight.toInt());
    final ByteData? byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }
}
