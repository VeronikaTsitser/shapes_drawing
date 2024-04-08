import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shapes_drawing/features/shapes_drawing/providers/providers.dart';

class DottedBackground extends ConsumerWidget {
  const DottedBackground({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomPaint(
      painter: DotBackgroundPainter(step: ref.watch(gridStepProvider)),
      child: Container(),
    );
  }
}

class DotBackgroundPainter extends CustomPainter {
  final double step;
  const DotBackgroundPainter({required this.step});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round;

    double dotSize = 1;

    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), dotSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant DotBackgroundPainter oldDelegate) => step != oldDelegate.step;
}
