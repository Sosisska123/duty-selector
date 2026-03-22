import 'package:duty_selector/design.dart';
import 'package:flutter/material.dart';

class ActionSelectionCard extends StatelessWidget {
  const ActionSelectionCard({super.key});

  static const double boxSize = 30;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        color: AppColors.secondary,
      ),
    );
  }
}
