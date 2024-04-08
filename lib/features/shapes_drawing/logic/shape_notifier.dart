import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shapes_drawing/features/shapes_drawing/logic/shape_state.dart';
import 'package:shapes_drawing/features/shapes_drawing/utils/utils.dart';

class ShapeNotifier extends StateNotifier<ShapeState> {
  ShapeNotifier() : super(const ShapeState());

  void setState(ShapeState newState) {
    state = newState;
  }

  void onPanStart(DragStartDetails details) {
    final localPosition = details.localPosition;
    final startPoints = [...state.startPoints];
    final endPoints = [...state.endPoints];
    if (!state.isFilled) {
      if (state.endPoints.isNotEmpty) {
        startPoints.add(endPoints.last);
        state = state.copyWith(startPoints: startPoints);
      } else {
        startPoints.add(localPosition);
        state = state.copyWith(startPoints: startPoints);
      }
      endPoints.add(localPosition);
      state = state.copyWith(endPoints: endPoints);
    } else {
      _updateSelectedPoint(localPosition);
    }
  }

  void _updateSelectedPoint(Offset point) {
    const double touchRadius = 20.0;
    for (int i = 0; i < state.startPoints.length; i++) {
      if ((state.startPoints[i] - point).distance < touchRadius) {
        state = state.copyWith(selectedPointIndex: i);
        return;
      }
    }
  }

  void onPanUpdate(DragUpdateDetails details) {
    final localPosition = details.localPosition;
    final startPoints = [...state.startPoints];
    final endPoints = [...state.endPoints];

    if (localPosition.dy >= 0) {
      if (state.isFilled && state.selectedPointIndex != null) {
        if (state.selectedPointIndex == 0) {
          startPoints[0] = localPosition;
          endPoints[endPoints.length - 1] = localPosition;
          state = state.copyWith(startPoints: startPoints, endPoints: endPoints);
        } else {
          startPoints[state.selectedPointIndex!] = localPosition;
          endPoints[state.selectedPointIndex! - 1] = localPosition;
          state = state.copyWith(startPoints: startPoints, endPoints: endPoints);
        }
      } else if (!state.isFilled) {
        endPoints[endPoints.length - 1] = localPosition;
        state = state.copyWith(endPoints: endPoints);
      }
    }
  }

  void onPanEnd({
    required DragEndDetails details,
    required ValueChanged<ShapeState> onPointAdded,
    required VoidCallback onIntersectionFound,
  }) {
    final startPoints = [...state.startPoints];
    final endPoints = [...state.endPoints];
    bool intersectionFound = false;
    for (int i = 0; i < startPoints.length; i++) {
      for (int j = 0; j < startPoints.length; j++) {
        // Пропускаем проверку соседних линий и линии самой с собой
        if (state.isFilled) {
          if (i != j && (i + 1) % startPoints.length != j && (j + 1) % startPoints.length != i) {
            if (doLinesIntersect(startPoints[i], endPoints[i], startPoints[j], endPoints[j])) {
              intersectionFound = true;
              break;
            }
          }
        } else if (i != j) {
          if (doLinesIntersect(startPoints[i], endPoints[i], startPoints[j], endPoints[j])) {
            intersectionFound = true;
            break;
          }
        }
      }
      if (intersectionFound) break;
    }

    if (!state.isFilled &&
        (state.startPoints.first - state.endPoints.last).distance < 20.0 &&
        state.endPoints.length > 2) {
      endPoints[endPoints.length - 1] = state.startPoints.first;
      state = state.copyWith(endPoints: endPoints, isFilled: true);
    }

    if (intersectionFound) {
      onIntersectionFound.call();
    } else {
      onPointAdded.call(state);
    }

    state = state.copyWith(selectedPointIndex: null, selectedPoint: null);
  }
}
