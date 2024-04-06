// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  bool isFilled = false;
  Offset? selectedPoint;
  int? selectedPointIndex;
  ui.Image? customIcon;

  @override
  void initState() {
    _loadImage();
    super.initState();
  }

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
            child: CustomPaint(
              painter: ShapesPainter(
                startPoints: startPoints,
                endPoints: endPoints,
                shouldFill: isFilled,
                customIcon: customIcon,
              ),
              child: Container(),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _loadImage() async {
    final ByteData data = await rootBundle.load('assets/icons/cursor.png');
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo fi = await codec.getNextFrame();
    customIcon = fi.image;
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

    if (isFilled) {
      setState(() {
        if (selectedPointIndex == 0) {
          startPoints[0] = localPosition;
          endPoints[endPoints.length - 1] = localPosition;
        } else {
          startPoints[selectedPointIndex!] = localPosition;
          endPoints[selectedPointIndex! - 1] = localPosition;
        }
      });
    } else {
      setState(() => endPoints[endPoints.length - 1] = localPosition);
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
      if (!isFilled) {
        if (intersectionFound) {
          // Удаляем последнюю линию при обнаружении пересечения
          startPoints.removeLast();
          endPoints.removeLast();
        } else if (((startPoints.first! - endPoints.last!).distance < 20.0) && endPoints.length > 2) {
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

class ShapesPainter extends CustomPainter {
  ShapesPainter({
    required this.startPoints,
    required this.endPoints,
    required this.shouldFill,
    required this.customIcon,
  });
  final List<Offset?> startPoints;
  final List<Offset?> endPoints;
  final bool shouldFill;
  final ui.Image? customIcon;

  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = ui.TextStyle(
      color: Colors.black,
      fontSize: 14,
    );
    // Offset center = calculateCenter(startPoints);
    if (shouldFill) {
      for (int i = 0; i < startPoints.length; i++) {
        if (startPoints[i] != null && endPoints[i] != null) {
          double length = (startPoints[i]! - endPoints[i]!).distance;
          Offset midPoint = startPoints[i]! + (endPoints[i]! - startPoints[i]!) / 2;
          double angle = (endPoints[i]! - startPoints[i]!).direction;

          // Вычисляем вектор, перпендикулярный линии
          Offset perpVector = getPerpendicularVector(endPoints[i]! - startPoints[i]!, 30.0);

          // Поворачиваем канвас и рисуем текст
          canvas.save();
          canvas.translate(midPoint.dx, midPoint.dy);
          canvas.rotate(angle);
          final textParagraphBuilder = ui.ParagraphBuilder(ui.ParagraphStyle(
            textDirection: ui.TextDirection.ltr,
          ))
            ..pushStyle(textStyle)
            ..addText(length.toStringAsFixed(2));

          ui.Paragraph paragraph = textParagraphBuilder.build()..layout(const ui.ParagraphConstraints(width: 60));
          canvas.drawParagraph(paragraph, perpVector - const Offset(30, 50)); // Смещаем текст
          canvas.restore();
        }
      }
    }
    Paint linePaint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 7.0;

    final Paint pointPaint = Paint()..color = Colors.blue;

    final Paint pointBorder = Paint()..color = Colors.white;

    final Paint filledPointPaint = Paint()..color = Colors.white;

    final Paint filledPointBorder = Paint()..color = const Color.fromRGBO(125, 125, 125, 1);

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
    if (!shouldFill && customIcon != null && endPoints.isNotEmpty) {
      // Рисуем кастомную иконку в последней точке
      final Offset lastPoint = endPoints.last!;
      canvas.drawImage(customIcon!, lastPoint - Offset(customIcon!.width / 2, customIcon!.height / 2), Paint());
    }

    for (int i = 0; i < startPoints.length; i++) {
      if (startPoints[i] != null && endPoints[i] != null) {
        // Рисуем линию
        canvas.drawLine(startPoints[i]!, endPoints[i]!, linePaint);

        // Рисуем начальную и конечную точку
        if (!shouldFill) {
          canvas.drawCircle(startPoints[i]!, 8.0, pointBorder);
          canvas.drawCircle(startPoints[i]!, 6.0, pointPaint);
          canvas.drawCircle(endPoints[i]!, 4.0, pointBorder);
        } else {
          canvas.drawCircle(startPoints[i]!, 8.0, filledPointBorder);
          canvas.drawCircle(startPoints[i]!, 6.0, filledPointPaint);
          canvas.drawCircle(endPoints[i]!, 8.0, filledPointBorder);
          canvas.drawCircle(endPoints[i]!, 6.0, filledPointPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  Offset calculateCenter(List<Offset?> points) {
    double sumX = 0.0, sumY = 0.0;
    int count = 0;
    for (var point in points) {
      if (point != null) {
        sumX += point.dx;
        sumY += point.dy;
        count++;
      }
    }
    return Offset(sumX / count, sumY / count);
  }

  Offset getPerpendicularVector(Offset lineVector, double magnitude) {
    // Вычисление вектора, перпендикулярного заданному вектору (lineVector)
    // и его нормализация с заданным коэффициентом масштабирования (magnitude)
    double length = lineVector.distance;
    // Нормализация вектора
    Offset normVector = lineVector / (length == 0 ? 1 : length);
    // Получаем перпендикулярный вектор
    return Offset(-normVector.dy, normVector.dx) * magnitude;
  }
}
