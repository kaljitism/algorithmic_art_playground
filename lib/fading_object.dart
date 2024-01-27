import 'dart:developer';

import 'package:flutter/material.dart';

class FadingShape extends StatelessWidget {
  const FadingShape({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomPaint(
        painter: FadedShapePainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class FadedShapePainter extends CustomPainter {
  double strokeWidth = 1;
  double i = 10.0;
  double gap = 10;

  @override
  void paint(Canvas canvas, Size size) {
    while (i < 200) {
      log('iteration $i');
      final Paint paint = Paint()
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..color = Colors.white;
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        i,
        paint,
      );
      strokeWidth += 0.01;
      i += 10 + gap;
      gap -= 0.1;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
