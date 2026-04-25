import 'package:duty_selector/design.dart';
import 'package:flutter/material.dart';

class InactiveText extends StatelessWidget {
  final String text;
  const InactiveText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.inactive);
  }
}
