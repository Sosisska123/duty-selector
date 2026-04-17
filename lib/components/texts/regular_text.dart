import 'package:duty_selector/design.dart';
import 'package:flutter/material.dart';

class RegularText extends StatelessWidget {
  final String text;

  const RegularText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.regular);
  }
}
