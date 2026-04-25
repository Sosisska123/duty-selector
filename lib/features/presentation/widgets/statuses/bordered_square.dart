import 'package:flutter/material.dart';

class BorderedSquare extends StatelessWidget {
  final String text;
  final Color color;
  final double size;

  const BorderedSquare({
    super.key,
    required this.text,
    this.color = Colors.greenAccent,
    this.size = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          text[0],
          style: TextStyle(
            color: color,
            fontSize: size * 0.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
