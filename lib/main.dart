// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

void main() {
  runApp(const ShapesDrawingApp());
}

class ShapesDrawingApp extends StatelessWidget {
  const ShapesDrawingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shapes Drawing',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Offset?> startPoints = [];
  List<Offset?> endPoints = [];
  bool shouldFill = false;
  Offset? selectedPoint;
  int? selectedPointIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: CustomPaint(
          painter: ShapesPainter(
            startPoints: startPoints,
            endPoints: endPoints,
            shouldFill: shouldFill,
          ),
          child: Container(),
        ),
      ),
    );
  }

  void _updateSelectedPoint(Offset point) {
    const double touchRadius = 20.0;
    for (int i = 0; i < startPoints.length; i++) {
      if ((startPoints[i]! - point).distance < touchRadius) {
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

    if (!shouldFill) {
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
      // Проверяем, выбрана ли точка
      _updateSelectedPoint(localPosition);
    }
  }

  void _onPanUpdate(details) {
    if (shouldFill && selectedPointIndex != null) {
      RenderBox renderBox = context.findRenderObject() as RenderBox;
      Offset localPosition = renderBox.globalToLocal(details.globalPosition);

      setState(() {
        // Для первой точки
        if (selectedPointIndex == 0) {
          startPoints[0] = localPosition;
          endPoints[endPoints.length - 1] = localPosition;
        }
        // Для предпоследней точки
        else if (selectedPointIndex == startPoints.length - 1) {
          startPoints[selectedPointIndex!] = localPosition;
          endPoints[selectedPointIndex! - 1] = localPosition;
        }
        // Для промежуточных точек
        else {
          startPoints[selectedPointIndex!] = localPosition;
          endPoints[selectedPointIndex! - 1] = localPosition;
        }
      });
    } else if (!shouldFill && endPoints.isNotEmpty) {
      // Обновляем последнюю точку для рисования новой линии
      RenderBox renderBox = context.findRenderObject() as RenderBox;
      Offset localPosition = renderBox.globalToLocal(details.globalPosition);
      setState(() {
        endPoints[endPoints.length - 1] = localPosition;
      });
    }
  }

  void _onPanEnd(details) {
    bool intersectionFound = false;
    for (int i = 0; i < startPoints.length - 1; i++) {
      if (doLinesIntersect(startPoints[i]!, endPoints[i]!, startPoints.last!, endPoints.last!)) {
        intersectionFound = true;
        break;
      }
    }
    setState(() {
      if (!shouldFill && startPoints.isNotEmpty && endPoints.isNotEmpty) {
        if (intersectionFound) {
          // Удаляем последнюю линию при обнаружении пересечения
          startPoints.removeLast();
          endPoints.removeLast();
        } else if ((startPoints.first! - endPoints.last!).distance < 20.0) {
          // Замыкаем фигуру и обновляем флаг
          endPoints[endPoints.length - 1] = startPoints.first;
          shouldFill = true;
        }
      }
      selectedPointIndex = null;
    });
  }
}

class ShapesPainter extends CustomPainter {
  ShapesPainter({
    required this.startPoints,
    required this.endPoints,
    required this.shouldFill,
  });
  final List<Offset?> startPoints;
  final List<Offset?> endPoints;
  final bool shouldFill;

  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    Paint pointPaint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0;

    Paint bigPointPaint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 15.0;

    if (startPoints.isNotEmpty && endPoints.isNotEmpty) {
      if (shouldFill && startPoints.length > 1) {
        Paint fillPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

        Path path = Path();
        path.moveTo(startPoints.first!.dx, startPoints.first!.dy);
        for (int i = 1; i < startPoints.length; i++) {
          path.lineTo(startPoints[i]!.dx, startPoints[i]!.dy);
        }
        path.close();

        canvas.drawPath(path, fillPaint);
      }
    }

    for (int i = 0; i < startPoints.length; i++) {
      if (startPoints[i] != null && endPoints[i] != null) {
        // Рисуем линию
        canvas.drawLine(startPoints[i]!, endPoints[i]!, linePaint);

        // Рисуем начальную и конечную точку
        canvas.drawCircle(startPoints[i]!, 7.0, bigPointPaint);
        canvas.drawCircle(startPoints[i]!, 5.0, pointPaint);
        canvas.drawCircle(endPoints[i]!, 7.0, bigPointPaint);
        canvas.drawCircle(endPoints[i]!, 5.0, pointPaint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
