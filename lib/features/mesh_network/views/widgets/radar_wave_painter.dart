import 'package:flutter/material.dart';


class RadarWavePainter extends CustomPainter {
  final Animation<double> animation;
  final Color waveColor;

  RadarWavePainter({required this.animation, required this.waveColor})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final center = rect.center;
    final maxRadius = size.width / 2;

    // Draw multiple cascading ripple waves
    for (int i = 0; i < 3; i++) {
      // Offset each wave's progress using the animation value (0.0 to 1.0)
      double progress = (animation.value + (i * 0.33)) % 1.0;
      double radius = maxRadius * progress;

      // Fade out as the ring expands outward
      double opacity = (1.0 - progress).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = waveColor.withOpacity(opacity * 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant RadarWavePainter oldDelegate) => true;
}