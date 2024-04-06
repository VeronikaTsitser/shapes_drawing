import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shapes_drawing/features/shapes_drawing/presentation/shapes_painter.dart';
import 'package:shapes_drawing/features/shapes_drawing/providers/providers.dart';

class ShapesDrawingScreen extends ConsumerWidget {
  const ShapesDrawingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startPoints = ref.watch(shapeNotifierProvider.select((state) => state.startPoints));
    final endPoints = ref.watch(shapeNotifierProvider.select((state) => state.endPoints));
    final isFilled = ref.watch(shapeNotifierProvider.select((state) => state.isFilled));
    return Stack(
      children: [
        Image.asset(
          'assets/images/background.png',
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            toolbarHeight: 20,
            backgroundColor: const Color.fromRGBO(246, 246, 246, 1),
            shadowColor: Colors.black.withOpacity(0.3),
            elevation: 1,
          ),
          backgroundColor: Colors.transparent,
          body: GestureDetector(
            onPanStart: ref.read(shapeNotifierProvider.notifier).onPanStart,
            onPanUpdate: ref.read(shapeNotifierProvider.notifier).onPanUpdate,
            onPanEnd: ref.read(shapeNotifierProvider.notifier).onPanEnd,
            child: ShapesPainterWidget(
              startPoints: startPoints,
              endPoints: endPoints,
              isFilled: isFilled,
            ),
          ),
        ),
      ],
    );
  }
}
