import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShapesPainterWidget extends StatefulWidget {
  const ShapesPainterWidget({super.key, required this.startPoints, required this.endPoints, required this.isFilled});
  final List<Offset> startPoints;
  final List<Offset> endPoints;
  final bool isFilled;

  @override
  State<ShapesPainterWidget> createState() => _ShapesPainterWidgetState();
}

class _ShapesPainterWidgetState extends State<ShapesPainterWidget> {
  ui.Image? customIcon;

  @override
  void initState() {
    _loadImage();
    super.initState();
  }

  @override
  void dispose() {
    customIcon?.dispose();
    super.dispose();
  }

  Future<void> _loadImage() async {
    final ByteData data = await rootBundle.load('assets/icons/cursor.png');
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo fi = await codec.getNextFrame();
    setState(() {
      customIcon = fi.image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return customIcon == null
        ? const Center(child: CircularProgressIndicator())
        : CustomPaint(
            painter: ShapesPainter(
              startPoints: widget.startPoints,
              endPoints: widget.endPoints,
              shouldFill: widget.isFilled,
              customIcon: customIcon!,
            ),
            child: const SizedBox.expand(),
          );
  }
}

class ShapesPainter extends CustomPainter {
  ShapesPainter({
    required this.startPoints,
    required this.endPoints,
    required this.shouldFill,
    required this.customIcon,
  });
  final List<Offset> startPoints;
  final List<Offset> endPoints;
  final bool shouldFill;
  final ui.Image customIcon;

  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = ui.TextStyle(
      color: Colors.black,
      fontSize: 14,
    );
    // Offset center = calculateCenter(startPoints);
    if (shouldFill) {
      for (int i = 0; i < startPoints.length; i++) {
        double length = (startPoints[i] - endPoints[i]).distance;
        Offset midPoint = startPoints[i] + (endPoints[i] - startPoints[i]) / 2;
        double angle = (endPoints[i] - startPoints[i]).direction;

        // Вычисляем вектор, перпендикулярный линии
        Offset perpVector = getPerpendicularVector(endPoints[i] - startPoints[i], 30.0);

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
        path.moveTo(startPoints.first.dx, startPoints.first.dy);
        for (int i = 1; i < startPoints.length; i++) {
          path.lineTo(startPoints[i].dx, startPoints[i].dy);
        }
        path.close();

        canvas.drawPath(path, fillPaint);
      }
    }
    if (!shouldFill && endPoints.isNotEmpty) {
      // Рисуем кастомную иконку в последней точке
      final Offset lastPoint = endPoints.last;
      canvas.drawImage(customIcon, lastPoint - Offset(customIcon.width / 2, customIcon.height / 2), Paint());
    }

    for (int i = 0; i < startPoints.length; i++) {
      // Рисуем линию
      canvas.drawLine(startPoints[i], endPoints[i], linePaint);

      // Рисуем начальную и конечную точку
      if (!shouldFill) {
        canvas.drawCircle(startPoints[i], 8.0, pointBorder);
        canvas.drawCircle(startPoints[i], 6.0, pointPaint);
        canvas.drawCircle(endPoints[i], 4.0, pointBorder);
      } else {
        canvas.drawCircle(startPoints[i], 8.0, filledPointBorder);
        canvas.drawCircle(startPoints[i], 6.0, filledPointPaint);
        canvas.drawCircle(endPoints[i], 8.0, filledPointBorder);
        canvas.drawCircle(endPoints[i], 6.0, filledPointPaint);
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
