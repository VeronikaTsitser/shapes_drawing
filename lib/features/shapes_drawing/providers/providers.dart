import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shapes_drawing/features/shapes_drawing/logic/history_notifier/history_notifier.dart';
import 'package:shapes_drawing/features/shapes_drawing/logic/history_notifier/history_state.dart';
import 'package:shapes_drawing/features/shapes_drawing/logic/shape_notifier/shape_notifier.dart';
import 'package:shapes_drawing/features/shapes_drawing/logic/shape_notifier/shape_state.dart';

final shapeNotifierProvider = StateNotifierProvider<ShapeNotifier, ShapeState>((ref) {
  return ShapeNotifier();
});

final historyNotifierProvider = StateNotifierProvider<HistoryNotifier, HistoryState>((ref) {
  return HistoryNotifier();
});

final gridStepProvider = StateProvider<double>((ref) {
  return 24.0;
});

final alignToGridEnabledProvider = StateProvider<bool>((ref) {
  return false;
});
