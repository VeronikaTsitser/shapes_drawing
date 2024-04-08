import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shapes_drawing/features/shapes_drawing/logic/history_notifier/history_state.dart';
import 'package:shapes_drawing/features/shapes_drawing/logic/shape_notifier/shape_state.dart';

class HistoryNotifier extends StateNotifier<HistoryState> {
  HistoryNotifier() : super(const HistoryState());

  void addToHistory(ShapeState shapeState) {
    state = state.copyWith(
      history: [...state.history, shapeState],
      redoHistory: [],
    );
  }

  void undo() {
    if (state.history.isNotEmpty) {
      final lastState = state.history.last;
      state = state.copyWith(
        history: List.from(state.history)..removeLast(),
        redoHistory: List.from(state.redoHistory)..add(lastState),
      );
    }
  }

  void redo() {
    if (state.redoHistory.isNotEmpty) {
      final nextState = state.redoHistory.last;
      state = state.copyWith(
        history: List.from(state.history)..add(nextState),
        redoHistory: List.from(state.redoHistory)..removeLast(),
      );
    }
  }
}
