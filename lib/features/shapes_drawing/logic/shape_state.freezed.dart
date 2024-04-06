// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shape_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ShapeState {
  List<Offset> get startPoints => throw _privateConstructorUsedError;
  List<Offset> get endPoints => throw _privateConstructorUsedError;
  bool get isFilled => throw _privateConstructorUsedError;
  Offset? get selectedPoint => throw _privateConstructorUsedError;
  int? get selectedPointIndex => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ShapeStateCopyWith<ShapeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShapeStateCopyWith<$Res> {
  factory $ShapeStateCopyWith(
          ShapeState value, $Res Function(ShapeState) then) =
      _$ShapeStateCopyWithImpl<$Res, ShapeState>;
  @useResult
  $Res call(
      {List<Offset> startPoints,
      List<Offset> endPoints,
      bool isFilled,
      Offset? selectedPoint,
      int? selectedPointIndex});
}

/// @nodoc
class _$ShapeStateCopyWithImpl<$Res, $Val extends ShapeState>
    implements $ShapeStateCopyWith<$Res> {
  _$ShapeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startPoints = null,
    Object? endPoints = null,
    Object? isFilled = null,
    Object? selectedPoint = freezed,
    Object? selectedPointIndex = freezed,
  }) {
    return _then(_value.copyWith(
      startPoints: null == startPoints
          ? _value.startPoints
          : startPoints // ignore: cast_nullable_to_non_nullable
              as List<Offset>,
      endPoints: null == endPoints
          ? _value.endPoints
          : endPoints // ignore: cast_nullable_to_non_nullable
              as List<Offset>,
      isFilled: null == isFilled
          ? _value.isFilled
          : isFilled // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedPoint: freezed == selectedPoint
          ? _value.selectedPoint
          : selectedPoint // ignore: cast_nullable_to_non_nullable
              as Offset?,
      selectedPointIndex: freezed == selectedPointIndex
          ? _value.selectedPointIndex
          : selectedPointIndex // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShapeStateImplCopyWith<$Res>
    implements $ShapeStateCopyWith<$Res> {
  factory _$$ShapeStateImplCopyWith(
          _$ShapeStateImpl value, $Res Function(_$ShapeStateImpl) then) =
      __$$ShapeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Offset> startPoints,
      List<Offset> endPoints,
      bool isFilled,
      Offset? selectedPoint,
      int? selectedPointIndex});
}

/// @nodoc
class __$$ShapeStateImplCopyWithImpl<$Res>
    extends _$ShapeStateCopyWithImpl<$Res, _$ShapeStateImpl>
    implements _$$ShapeStateImplCopyWith<$Res> {
  __$$ShapeStateImplCopyWithImpl(
      _$ShapeStateImpl _value, $Res Function(_$ShapeStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startPoints = null,
    Object? endPoints = null,
    Object? isFilled = null,
    Object? selectedPoint = freezed,
    Object? selectedPointIndex = freezed,
  }) {
    return _then(_$ShapeStateImpl(
      startPoints: null == startPoints
          ? _value._startPoints
          : startPoints // ignore: cast_nullable_to_non_nullable
              as List<Offset>,
      endPoints: null == endPoints
          ? _value._endPoints
          : endPoints // ignore: cast_nullable_to_non_nullable
              as List<Offset>,
      isFilled: null == isFilled
          ? _value.isFilled
          : isFilled // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedPoint: freezed == selectedPoint
          ? _value.selectedPoint
          : selectedPoint // ignore: cast_nullable_to_non_nullable
              as Offset?,
      selectedPointIndex: freezed == selectedPointIndex
          ? _value.selectedPointIndex
          : selectedPointIndex // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$ShapeStateImpl implements _ShapeState {
  const _$ShapeStateImpl(
      {final List<Offset> startPoints = const [],
      final List<Offset> endPoints = const [],
      this.isFilled = false,
      this.selectedPoint,
      this.selectedPointIndex})
      : _startPoints = startPoints,
        _endPoints = endPoints;

  final List<Offset> _startPoints;
  @override
  @JsonKey()
  List<Offset> get startPoints {
    if (_startPoints is EqualUnmodifiableListView) return _startPoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_startPoints);
  }

  final List<Offset> _endPoints;
  @override
  @JsonKey()
  List<Offset> get endPoints {
    if (_endPoints is EqualUnmodifiableListView) return _endPoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_endPoints);
  }

  @override
  @JsonKey()
  final bool isFilled;
  @override
  final Offset? selectedPoint;
  @override
  final int? selectedPointIndex;

  @override
  String toString() {
    return 'ShapeState(startPoints: $startPoints, endPoints: $endPoints, isFilled: $isFilled, selectedPoint: $selectedPoint, selectedPointIndex: $selectedPointIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShapeStateImpl &&
            const DeepCollectionEquality()
                .equals(other._startPoints, _startPoints) &&
            const DeepCollectionEquality()
                .equals(other._endPoints, _endPoints) &&
            (identical(other.isFilled, isFilled) ||
                other.isFilled == isFilled) &&
            (identical(other.selectedPoint, selectedPoint) ||
                other.selectedPoint == selectedPoint) &&
            (identical(other.selectedPointIndex, selectedPointIndex) ||
                other.selectedPointIndex == selectedPointIndex));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_startPoints),
      const DeepCollectionEquality().hash(_endPoints),
      isFilled,
      selectedPoint,
      selectedPointIndex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ShapeStateImplCopyWith<_$ShapeStateImpl> get copyWith =>
      __$$ShapeStateImplCopyWithImpl<_$ShapeStateImpl>(this, _$identity);
}

abstract class _ShapeState implements ShapeState {
  const factory _ShapeState(
      {final List<Offset> startPoints,
      final List<Offset> endPoints,
      final bool isFilled,
      final Offset? selectedPoint,
      final int? selectedPointIndex}) = _$ShapeStateImpl;

  @override
  List<Offset> get startPoints;
  @override
  List<Offset> get endPoints;
  @override
  bool get isFilled;
  @override
  Offset? get selectedPoint;
  @override
  int? get selectedPointIndex;
  @override
  @JsonKey(ignore: true)
  _$$ShapeStateImplCopyWith<_$ShapeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
