import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shapes_drawing/features/shapes_drawing/logic/shape_state.dart';

part 'history_state.freezed.dart';

@freezed
class HistoryState with _$HistoryState {
  const factory HistoryState({
    @Default([ShapeState()]) List<ShapeState> history,
    @Default([]) List<ShapeState> redoHistory,
  }) = _HistoryState;
}
