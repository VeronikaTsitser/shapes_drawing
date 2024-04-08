import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shapes_drawing/features/shapes_drawing/providers/providers.dart';

class UndoRedoButton extends ConsumerWidget {
  const UndoRedoButton({super.key});

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
