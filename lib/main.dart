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
      title: 'Flutter Demo',
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

  void _updateSelectedPoint(Offset point) {
    const double touchRadius = 20.0;
    for (int i = 0; i < startPoints.length; i++) {
      if ((startPoints[i]! - point).distance < touchRadius) {
        selectedPointIndex = i;
        return; // Выходим из цикла после нахождения ближайшей точки
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: GestureDetector(
        onPanStart: (details) {
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
        },
        onPanUpdate: (details) {
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
        },
        onPanEnd: (details) {
          setState(() {
            if (!shouldFill && startPoints.isNotEmpty && endPoints.isNotEmpty) {
              if ((startPoints.first! - endPoints.last!).distance < 20.0) {
                // Замыкаем фигуру и обновляем флаг
                endPoints[endPoints.length - 1] = startPoints.first;
                shouldFill = true;
              }
            }
            selectedPointIndex = null;
          });
        },
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
