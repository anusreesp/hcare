import 'package:flutter/material.dart';

class DashedLine extends StatelessWidget {
  final double width;
  final double dashedWidth;
  final double dashedSpace;
  final Color dashColor;
  final double strokeWidth;
  const DashedLine(
      {Key? key,
      required this.width,
      this.dashedSpace = 4.0,
      this.dashedWidth = 4.0,
      this.dashColor = Colors.grey,
      this.strokeWidth = 2})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: CustomPaint(
        painter: DashedLinePainterVertical(
            width, dashedWidth, dashedSpace, dashColor, strokeWidth),
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final double width;
  final double dashedWidth;
  final double dashedSpace;
  final Color dashColor;
  final double strokeWidth;
  DashedLinePainter(this.width, this.dashedWidth, this.dashedSpace,
      this.dashColor, this.strokeWidth);
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = dashColor
      ..strokeWidth = strokeWidth;
    _drawDashedLine(canvas, size, paint, dashedWidth, dashedSpace);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void _drawDashedLine(Canvas canvas, Size size, Paint paint,
      double dashedWidth, double dashedSpace) {
    double startX = 0;
    double y = 10;
    //Repeat dash
    while (startX < size.width) {
      canvas.drawLine(
          Offset(startX, y), Offset(startX + dashedWidth, y), paint);
      //update starting string
      startX += dashedWidth + dashedSpace;
    }
  }
}

class DashedLinePainterVertical extends CustomPainter {
  final double width;
  final double dashedWidth;
  final double dashedSpace;
  final Color dashColor;
  final double strokeWidth;
  DashedLinePainterVertical(this.width, this.dashedWidth, this.dashedSpace,
      this.dashColor, this.strokeWidth);
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = dashColor
      ..strokeWidth = strokeWidth;
    _drawDashedLine(canvas, size, paint, dashedWidth, dashedSpace);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void _drawDashedLine(Canvas canvas, Size size, Paint paint,
      double dashedWidth, double dashedSpace) {
    double startX = 0;
    double y = 10;
    //Repeat dash
    while (startX < size.width) {
      canvas.drawLine(
          Offset(0, startX), Offset(0, startX + dashedWidth), paint);
      //update starting string
      startX += dashedWidth + dashedSpace;
    }
  }
}
