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
  GlobalKey customPaintKey = GlobalKey();
  List<Offset?> startPoints = [];
  List<Offset?> endPoints = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: GestureDetector(
        onPanStart: (details) {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          Offset localPosition = renderBox.globalToLocal(details.globalPosition);
          setState(() {
            startPoints.add(localPosition);
            endPoints.add(localPosition); // Добавляем ту же точку в качестве начала
          });
        },
        onPanUpdate: (details) {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          Offset localPosition = renderBox.globalToLocal(details.globalPosition);
          setState(() {
            endPoints[endPoints.length - 1] = localPosition; // Обновляем последнюю точку
          });
        },
        onPanEnd: (details) {
          setState(() {
            // Не добавляем ничего, оставляем точки как есть
          });
        },
        child: CustomPaint(
          key: customPaintKey,
          painter: ShapesPainter(startPoints, endPoints),
          child: Container(),
        ),
      ),
    );
  }
}

class ShapesPainter extends CustomPainter {
  ShapesPainter(this.startPoints, this.endPoints);
  final List<Offset?> startPoints;
  final List<Offset?> endPoints;

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
