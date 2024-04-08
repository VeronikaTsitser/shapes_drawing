import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'shape_state.freezed.dart';

@freezed
class ShapeState with _$ShapeState {
  const factory ShapeState({
    @Default([]) List<Offset> startPoints,
    @Default([]) List<Offset> endPoints,
    @Default(false) bool isFilled,
    Offset? selectedPoint,
    int? selectedPointIndex,
  }) = _ShapeState;
}
