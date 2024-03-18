import 'package:flutter/material.dart';
import '../utilities/curved_shape.dart';

class TopBar extends StatelessWidget {
  final MaterialColor? color;

  const TopBar({super.key, this.color});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(
        height: 120.0,
      ),
      painter: CurvePainter(color: color ?? Colors.cyan),
    );
  }
}
