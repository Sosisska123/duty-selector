import 'package:duty_selector/design.dart';
import 'package:flutter/material.dart';

class RoundedBackgroundText extends StatelessWidget {
  final String text;
  final Color backgroundColor;

  const RoundedBackgroundText({
    super.key,
    required this.text,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.medium)),
      ),
      padding: EdgeInsets.all(AppSpacing.small),
      alignment: AlignmentGeometry.center,
      child: Text(text, style: AppTextStyles.regular),
    );
  }
}
