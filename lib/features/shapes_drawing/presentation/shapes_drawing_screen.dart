import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shapes_drawing/features/shapes_drawing/presentation/widgets/align_to_grid_button.dart';
import 'package:shapes_drawing/features/shapes_drawing/presentation/widgets/dotted_background.dart';
import 'package:shapes_drawing/features/shapes_drawing/presentation/widgets/shapes_painter_widget.dart';
import 'package:shapes_drawing/features/shapes_drawing/presentation/widgets/undo_redo_button.dart';
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
          const DottedBackground(),
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
          const Padding(
            padding: EdgeInsets.only(top: 16, left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                UndoRedoButton(),
                AlignToGridButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
