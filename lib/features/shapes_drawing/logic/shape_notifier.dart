import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shapes_drawing/features/shapes_drawing/logic/shape_state.dart';

class ShapeNotifier extends StateNotifier<ShapeState> {
  ShapeNotifier() : super(const ShapeState());
}
