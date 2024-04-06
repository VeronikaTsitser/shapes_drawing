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
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          GestureDetector(
            onPanStart: ref.read(shapeNotifierProvider.notifier).onPanStart,
            onPanUpdate: ref.read(shapeNotifierProvider.notifier).onPanUpdate,
            onPanEnd: (details) => ref.read(shapeNotifierProvider.notifier).onPanEnd(
              details,
              (state) {
                ref.read(historyNotifierProvider.notifier).addToHistory(state);
              },
            ),
            child: ShapesPainterWidget(
              startPoints: startPoints,
              endPoints: endPoints,
              isFilled: isFilled,
            ),
          ),
          const UndoRedoWidget(),
        ],
      ),
    );
  }
}

class UndoRedoWidget extends ConsumerWidget {
  const UndoRedoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(top: 16, left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              if (ref.read(historyNotifierProvider).history.length > 1) {
                ref.read(historyNotifierProvider.notifier).undo();
                ref.read(shapeNotifierProvider.notifier).setState(
                      ref.read(historyNotifierProvider).history.last,
                    );
              }
            },
            icon: Image.asset('assets/icons/undo.png'),
          ),
          const SizedBox(
            height: 12,
            child: VerticalDivider(color: Color.fromRGBO(198, 198, 200, 1), thickness: 1),
          ),
          IconButton(
            onPressed: () {
              ref.read(historyNotifierProvider.notifier).redo();
              ref.read(shapeNotifierProvider.notifier).setState(
                    ref.read(historyNotifierProvider).history.last,
                  );
            },
            icon: Image.asset('assets/icons/redo.png'),
          ),
        ],
      ),
    );
  }
}
