import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shapes_drawing/features/shapes_drawing/logic/shape_notifier.dart';
import 'package:shapes_drawing/features/shapes_drawing/logic/shape_state.dart';

final shapeNotifierProvider = StateNotifierProvider<ShapeNotifier, ShapeState>((ref) {
  return ShapeNotifier();
});