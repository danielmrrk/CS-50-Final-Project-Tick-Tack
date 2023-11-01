import 'package:flutter/material.dart';

class Triangle extends CustomPainter {
  const Triangle({required this.color, this.scale = 1});

  final Color color;
  final int scale;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    path.lineTo(scale * -11, 4);
    path.lineTo(0, scale * 10);
    path.lineTo(scale * 11, -4);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
