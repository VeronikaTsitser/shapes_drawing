import 'package:flutter/material.dart';
import 'package:shapes_drawing/features/shapes_drawing/presentation/shapes_painter.dart';

class ShapesDrawingScreen extends StatefulWidget {
  const ShapesDrawingScreen({super.key});

  @override
  State<ShapesDrawingScreen> createState() => _ShapesDrawingScreenState();
}

class _ShapesDrawingScreenState extends State<ShapesDrawingScreen> {
  List<Offset> startPoints = [];
  List<Offset> endPoints = [];
  bool isFilled = false;
  Offset? selectedPoint;
  int? selectedPointIndex;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/background.png',
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            toolbarHeight: 20,
            backgroundColor: const Color.fromRGBO(246, 246, 246, 1),
            shadowColor: Colors.black.withOpacity(0.3),
            elevation: 1,
          ),
          backgroundColor: Colors.transparent,
          body: GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: ShapesPainterWidget(
              startPoints: startPoints,
              endPoints: endPoints,
              isFilled: isFilled,
            ),
          ),
        ),
      ],
    );
  }

  void _updateSelectedPoint(Offset point) {
    const double touchRadius = 20.0;
    for (int i = 0; i < startPoints.length; i++) {
      if ((startPoints[i] - point).distance < touchRadius) {
        selectedPointIndex = i;
        return; // Выходим из цикла после нахождения ближайшей точки
      }
    }
  }

  bool doLinesIntersect(Offset p1, Offset p2, Offset p3, Offset p4) {
    double ccw(Offset A, Offset B, Offset C) {
      return (C.dy - A.dy) * (B.dx - A.dx) - (B.dy - A.dy) * (C.dx - A.dx);
    }

    double d1 = ccw(p4, p3, p1);
    double d2 = ccw(p4, p3, p2);
    double d3 = ccw(p2, p1, p3);
    double d4 = ccw(p2, p1, p4);

    // Проверяем, есть ли пересечение
    if (d1 * d2 < 0 && d3 * d4 < 0) return true;

    return false;
  }

  void _onPanStart(DragStartDetails details) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset localPosition = renderBox.globalToLocal(details.globalPosition);

    if (!isFilled) {
      // Рисуем новые линии, если фигура не замкнута
      if (endPoints.isNotEmpty) {
        // Начинаем новую линию с конца предыдущей
        startPoints.add(endPoints.last);
      } else {
        // Если это первая точка фигуры
        startPoints.add(localPosition);
      }
      endPoints.add(localPosition);
    } else {
      // Перемещаем точку, если фигура замкнута
      _updateSelectedPoint(localPosition);
    }
  }

  void _onPanUpdate(details) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset localPosition = renderBox.globalToLocal(details.globalPosition);

    if (isFilled && selectedPointIndex != null) {
      setState(() {
        if (selectedPointIndex == 0) {
          startPoints[0] = localPosition;
          endPoints[endPoints.length - 1] = localPosition;
        } else {
          startPoints[selectedPointIndex!] = localPosition;
          endPoints[selectedPointIndex! - 1] = localPosition;
        }
      });
    } else if (!isFilled) {
      setState(() => endPoints[endPoints.length - 1] = localPosition);
    }
  }

  void _onPanEnd(details) {
    bool intersectionFound = false;
    for (int i = 0; i < startPoints.length - 1; i++) {
      if (doLinesIntersect(startPoints[i], endPoints[i], startPoints.last, endPoints.last)) {
        intersectionFound = true;
        break;
      }
    }
    setState(() {
      if (!isFilled) {
        if (intersectionFound) {
          // Удаляем последнюю линию при обнаружении пересечения
          startPoints.removeLast();
          endPoints.removeLast();
        } else if (((startPoints.first - endPoints.last).distance < 20.0) && endPoints.length > 2) {
          // Замыкаем фигуру и обновляем флаг
          endPoints[endPoints.length - 1] = startPoints.first;
          isFilled = true;
        }
      } else {
        if (intersectionFound) {
          // Перемещаем точку обратно, если обнаружено пересечение
          //TODO
        }
      }

      selectedPointIndex = null;
    });
  }
}
