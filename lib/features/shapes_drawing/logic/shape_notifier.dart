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

  void onPanEnd(DragEndDetails details, ValueChanged<ShapeState> onPointAdded) {
    final startPoints = [...state.startPoints];
    final endPoints = [...state.endPoints];
    bool intersectionFound = false;
    for (int i = 0; i < state.startPoints.length - 1; i++) {
      if (doLinesIntersect(
        state.startPoints[i],
        state.endPoints[i],
        state.startPoints.last,
        state.endPoints.last,
      )) {
        intersectionFound = true;
        break;
      }
    }

    if (!state.isFilled) {
      if (intersectionFound && ((state.startPoints.first - state.endPoints.last).distance > 20.0)) {
        startPoints.removeLast();
        endPoints.removeLast();
        state = state.copyWith(startPoints: startPoints, endPoints: endPoints);
      } else if (((state.startPoints.first - state.endPoints.last).distance < 20.0) && state.endPoints.length > 2) {
        endPoints[endPoints.length - 1] = state.startPoints.first;
        state = state.copyWith(
          endPoints: endPoints,
          isFilled: true,
        );
      }
    } else {
      if (intersectionFound) {
        // Перемещаем точку обратно, если обнаружено пересечение
        //TODO
      }
    }
    if (!intersectionFound) {
      onPointAdded.call(state);
    }
    state = state.copyWith(selectedPointIndex: null);
    state = state.copyWith(selectedPoint: null);
  }
}
