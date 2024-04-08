// ignore_for_file: public_member_api_docs, sort_constructors_first
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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
        backgroundColor: const Color.fromRGBO(246, 246, 246, 1),
        shadowColor: Colors.black.withOpacity(0.3),
        elevation: 1,
      ),
      backgroundColor: const Color.fromRGBO(227, 227, 227, 1),
      body: Stack(
        children: [
          const DotBackground(),
          GestureDetector(
            onPanStart: ref.read(shapeNotifierProvider.notifier).onPanStart,
            onPanUpdate: ref.read(shapeNotifierProvider.notifier).onPanUpdate,
            onPanEnd: (details) => ref.read(shapeNotifierProvider.notifier).onPanEnd(
                  details: details,
                  onPointAdded: (state) {
                    ref.read(historyNotifierProvider.notifier).addToHistory(state);
                    if (ref.read(alignToGridEnabledProvider)) {
                      ref.read(shapeNotifierProvider.notifier).alignToGrid(ref.read(gridStepProvider));
                    }
                  },
                  onIntersectionFound: () =>
                      ref.read(shapeNotifierProvider.notifier).setState(ref.read(historyNotifierProvider).history.last),
                ),
            child: ShapesPainterWidget(
              startPoints: startPoints,
              endPoints: endPoints,
              isFilled: isFilled,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const _UndoRedoWidget(),
                IconButton(
                  onPressed: () {
                    ref.read(alignToGridEnabledProvider.notifier).state = !ref.read(alignToGridEnabledProvider);
                    if (ref.read(alignToGridEnabledProvider)) {
                      ref.read(shapeNotifierProvider.notifier).alignToGrid(ref.read(gridStepProvider));
                    }
                  },
                  icon: (ref.watch(alignToGridEnabledProvider))
                      ? Image.asset('assets/icons/hashtag_active.png')
                      : Image.asset('assets/icons/hashtag_icon.png'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UndoRedoWidget extends ConsumerWidget {
  const _UndoRedoWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(historyNotifierProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
              onTap: () {
                if (ref.read(historyNotifierProvider).history.length > 1) {
                  ref.read(historyNotifierProvider.notifier).undo();
                  ref.read(shapeNotifierProvider.notifier).setState(
                        ref.read(historyNotifierProvider).history.last,
                      );
                }
              },
              child: historyState.history.length > 1
                  ? Image.asset('assets/icons/undo_active.png')
                  : Image.asset('assets/icons/undo.png')),
          const SizedBox(
            height: 12,
            width: 20,
            child: VerticalDivider(color: Color.fromRGBO(198, 198, 200, 1), thickness: 1),
          ),
          GestureDetector(
              onTap: () {
                if (ref.read(historyNotifierProvider).redoHistory.isNotEmpty) {
                  ref.read(historyNotifierProvider.notifier).redo();
                  ref.read(shapeNotifierProvider.notifier).setState(
                        ref.read(historyNotifierProvider).history.last,
                      );
                }
              },
              child: historyState.redoHistory.isNotEmpty
                  ? Image.asset('assets/icons/redo_active.png')
                  : Image.asset('assets/icons/redo.png')),
        ],
      ),
    );
  }
}

class DotBackground extends ConsumerWidget {
  const DotBackground({super.key});

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
  DotBackgroundPainter({required this.step});
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
