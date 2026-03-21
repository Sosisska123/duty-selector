import 'package:flutter/material.dart';

import 'package:duty_selector/design.dart';

class TitleText extends StatelessWidget {
  final String text;

  const TitleText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.title);
  }
}
