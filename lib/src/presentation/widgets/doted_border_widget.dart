import 'package:flutter/material.dart';

class DottedBorderPainter extends CustomPainter {
  final double radius;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final Color color;

  DottedBorderPainter({
    this.radius = 10,
    this.strokeWidth = 2,
    this.dashWidth = 8,
    this.dashSpace = 8,
    this.color = Colors.grey,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rect = Offset.zero & size;

    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    final path = Path()..addRRect(rrect);

    final dashedPath = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        dashedPath.addPath(metric.extractPath(distance, next), Offset.zero);
        distance = next + dashSpace;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
