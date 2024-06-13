import 'package:flutter/material.dart';

class Arrow extends StatelessWidget {
  const Arrow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 20 * (MediaQuery.of(context).size.width / 360),
        height: 10 * (MediaQuery.of(context).size.height / 360),
      child: Container(
        margin: EdgeInsets.fromLTRB(
          0 * (MediaQuery.of(context).size.width / 360),
          0 * (MediaQuery.of(context).size.height / 360),
          0 * (MediaQuery.of(context).size.width / 360),
          3 * (MediaQuery.of(context).size.height / 360),
        ),
        child: CustomPaint(painter: _ArrowPainter()),
      )
    );
  }
}

class _ArrowPainter extends CustomPainter {
  final _paint = Paint()
    ..color = Colors.amber
    ..style = PaintingStyle.fill;


  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..lineTo(0, 0)
      ..relativeLineTo(size.width / 2, size.height)
      ..relativeLineTo(size.width / 2, -size.height)
      ..close();
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}