import 'package:flutter/material.dart';

class CoordinatePoint extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {
      Paint paint = Paint();
      Path path = Path();
  

      // Path number 1
  

      paint.color = const Color.fromARGB(255, 56, 55, 52);
      path = Path();
      path.lineTo(size.width * 1.43, size.height * 0.45);
      path.cubicTo(size.width * 1.43, size.height * 0.62, size.width * 0.96, size.height * 1.1, size.width * 0.96, size.height * 1.1);
      path.cubicTo(size.width * 0.96, size.height * 1.1, size.width * 0.48, size.height * 0.62, size.width * 0.48, size.height * 0.45);
      path.cubicTo(size.width * 0.48, size.height * 0.28, size.width * 0.7, size.height * 0.14, size.width * 0.96, size.height * 0.14);
      path.cubicTo(size.width * 1.22, size.height * 0.14, size.width * 1.43, size.height * 0.28, size.width * 1.43, size.height * 0.45);
      path.cubicTo(size.width * 1.43, size.height * 0.45, size.width * 1.43, size.height * 0.45, size.width * 1.43, size.height * 0.45);
      canvas.drawPath(path, paint);
  
  

      // Path number 3
  

      paint.color = const Color.fromARGB(255, 56, 55, 52);
      path = Path();
      path.lineTo(size.width * 1.43, size.height * 0.45);
      path.cubicTo(size.width * 1.43, size.height * 0.62, size.width * 0.96, size.height * 1.1, size.width * 0.96, size.height * 1.1);
      path.cubicTo(size.width * 0.96, size.height * 1.1, size.width * 0.48, size.height * 0.62, size.width * 0.48, size.height * 0.45);
      path.cubicTo(size.width * 0.48, size.height * 0.28, size.width * 0.7, size.height * 0.14, size.width * 0.96, size.height * 0.14);
      path.cubicTo(size.width * 1.22, size.height * 0.14, size.width * 1.43, size.height * 0.28, size.width * 1.43, size.height * 0.45);
      path.cubicTo(size.width * 1.43, size.height * 0.45, size.width * 1.43, size.height * 0.45, size.width * 1.43, size.height * 0.45);
      canvas.drawPath(path, paint);
  

      // Path number 5
  

      paint.color = const Color(0xffE24F32);
      path = Path();
      path.lineTo(size.width * 0.79, size.height * 0.45);
      path.cubicTo(size.width * 0.79, size.height * 0.59, size.width * 0.85, size.height * 0.62, size.width * 1.04, size.height * 0.54);
      path.cubicTo(size.width * 1.09, size.height * 0.52, size.width * 1.12, size.height * 0.49, size.width * 1.12, size.height * 0.45);
      path.cubicTo(size.width * 1.12, size.height * 0.3, size.width * 1.07, size.height * 0.28, size.width * 0.87, size.height * 0.35);
      path.cubicTo(size.width * 0.82, size.height * 0.37, size.width * 0.79, size.height * 0.41, size.width * 0.79, size.height * 0.45);
      path.cubicTo(size.width * 0.79, size.height * 0.45, size.width * 0.79, size.height * 0.45, size.width * 0.79, size.height * 0.45);
      canvas.drawPath(path, paint);
  

    }
    @override
    bool shouldRepaint(CustomPainter oldDelegate) {
      return true;
    }
  }
