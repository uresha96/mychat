import 'dart:math';

import 'package:flutter/material.dart';

class WaveBackground extends StatelessWidget {
  const WaveBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: WavePainter(),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final random = Random(42);

  @override
  void paint(Canvas canvas, Size size) {
    print(size);
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF8E2DE2),
          Color(0xFF4A00E0),
          Color(0xFF56CCF2),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path()
      ..lineTo(0, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.65,
        size.width * 0.5,
        size.height * 0.75,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.85,
        size.width,
        size.height * 0.8,
      )
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
    final dotPaint = Paint()..color = Colors.yellow.withOpacity(0.3);
    canvas.drawCircle(Offset(50, 100), 10, dotPaint);
    canvas.drawCircle(Offset(200, 300), 1.5, dotPaint);

    final starPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(colors: [Color(0xFFFFD166), Color(0xFFFFF1A8)])
          .createShader(const Rect.fromLTWH(0, 0, 20, 20));

    final heartPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Color(0xFFFF5F9E),
          Color(0xFFFF8ACD),
        ],
      ).createShader(const Rect.fromLTWH(0, 0, 20, 20));

    drawSparkles(canvas, size, heartPaint, starPaint, dotPaint);
  }

  void drawSparkles(Canvas canvas, Size size, Paint heartPaint, Paint starPaint,
      Paint dotPaint) {
    for (int i = 0; i < 12; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height * 0.6;

      if (random.nextBool()) {
        canvas.drawPath(
          createStar(Offset(x, y), random.nextDouble() * 4 + 3),
          starPaint,
        );
      } else {
        canvas.drawPath(
          createHeart(Offset(x, y), random.nextDouble() * 6 + 5),
          heartPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  Path createStar(Offset center, double size) {
    final path = Path();
    final half = size / 2;

    path.moveTo(center.dx, center.dy - size); // top
    path.lineTo(center.dx + half, center.dy); // right
    path.lineTo(center.dx, center.dy + size); // bottom
    path.lineTo(center.dx - half, center.dy); // left
    path.close();

    return path;
  }

  Path createHeart(Offset center, double size) {
    final path = Path();
    final width = size;
    final height = size;

    path.moveTo(center.dx, center.dy + height * 0.25);

    path.cubicTo(
      center.dx - width,
      center.dy - height * 0.5,
      center.dx - width,
      center.dy + height * 0.75,
      center.dx,
      center.dy + height,
    );

    path.cubicTo(
      center.dx + width,
      center.dy + height * 0.75,
      center.dx + width,
      center.dy - height * 0.5,
      center.dx,
      center.dy + height * 0.25,
    );

    return path;
  }
}
