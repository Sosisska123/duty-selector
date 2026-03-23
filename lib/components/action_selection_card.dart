import 'package:duty_selector/design.dart';
import 'package:flutter/material.dart';

class ActionSelectionCard extends StatelessWidget {
  const ActionSelectionCard({
    super.key,
    required this.text,
    required this.icon,
  });

  static const double boxSize = 30;
  final String text;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        color: AppColors.secondary,
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.all(AppSpacing.medium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(text, style: AppTextStyles.regularBold),
                icon,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
