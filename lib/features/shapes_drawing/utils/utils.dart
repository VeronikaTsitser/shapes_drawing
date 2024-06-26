import 'dart:ui';

bool doLinesIntersect(Offset p1, Offset p2, Offset p3, Offset p4) {
  double ccw(Offset a, Offset b, Offset c) {
    return (c.dy - a.dy) * (b.dx - a.dx) - (b.dy - a.dy) * (c.dx - a.dx);
  }

  double d1 = ccw(p4, p3, p1);
  double d2 = ccw(p4, p3, p2);
  double d3 = ccw(p2, p1, p3);
  double d4 = ccw(p2, p1, p4);

  if (d1 * d2 < 0 && d3 * d4 < 0) return true;

  return false;
}

Offset getPerpendicularVector(Offset lineVector) {
  double length = lineVector.distance;
  if (length == 0) return Offset.zero;
  Offset unitVector = Offset(-lineVector.dy / length, lineVector.dx / length);
  return unitVector;
}

Offset calculateCenterOfFigure(List<Offset> points) {
  double sumX = 0.0;
  double sumY = 0.0;

  for (Offset point in points) {
    sumX += point.dx;
    sumY += point.dy;
  }

  int numberOfPoints = points.length;
  return Offset(sumX / numberOfPoints, sumY / numberOfPoints);
}
