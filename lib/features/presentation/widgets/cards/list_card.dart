import 'package:flutter/material.dart';
import 'package:duty_selector/design.dart';

class ListCard extends StatelessWidget {
  final Icon icon;
  final String text;
  final void Function()? tapCallback;
  final void Function()? longPressCallback;

  const ListCard({
    super.key,
    required this.icon,
    required this.text,
    this.tapCallback,
    this.longPressCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: tapCallback?.call,
        onLongPress: longPressCallback?.call,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          child: Padding(
            padding: const EdgeInsetsGeometry.all(AppSpacing.medium),
            child: SizedBox(
              height: AppSpacing.xlarge,
              child: Row(
                spacing: AppSpacing.small,
                children: [
                  icon,
                  Text(text, style: AppTextStyles.regularBold),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
