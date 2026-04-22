import 'package:duty_selector/design.dart';
import 'package:flutter/material.dart';

class AccentText extends StatelessWidget {
  final String text;

  const AccentText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.accent);
  }
}
