import 'package:duty_selector/design.dart';
import 'package:flutter/material.dart';

class SelectionModal extends StatelessWidget {
  const SelectionModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.medium),
        ),
      ),
      child: Placeholder(),
    );
  }
}
