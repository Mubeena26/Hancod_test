import 'package:flutter/material.dart';

// Custom painter for dashed line
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom painter for dotted border
class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 3.0;
    const dashSpace = 3.0;

    // Top border
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(
          (startX + dashWidth < size.width) ? startX + dashWidth : size.width,
          0,
        ),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Right border
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width, startY),
        Offset(
          size.width,
          (startY + dashWidth < size.height) ? startY + dashWidth : size.height,
        ),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    // Bottom border
    startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(
          (startX + dashWidth < size.width) ? startX + dashWidth : size.width,
          size.height,
        ),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Left border
    startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(
          0,
          (startY + dashWidth < size.height) ? startY + dashWidth : size.height,
        ),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


