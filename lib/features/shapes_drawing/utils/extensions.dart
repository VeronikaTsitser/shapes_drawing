import 'package:flutter/material.dart';

extension OffsetExtensions on Offset {
  double dot(Offset other) {
    return dx * other.dx + dy * other.dy;
  }

  Offset normalize() {
    double len = distance;
    return len > 0 ? this / len : Offset.zero;
  }
}
