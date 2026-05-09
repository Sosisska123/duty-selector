import 'package:duty_selector/design.dart';
import 'package:duty_selector/features/presentation/widgets/texts/regular_text.dart';
import 'package:flutter/material.dart';

class GroupButton extends StatelessWidget {
  final IconData? icon;
  final String text;
  final double height;
  final void Function() tapCallback;
  final void Function()? longPressCallback;

  const GroupButton({
    super.key,
    this.icon,
    this.height = AppSpacing.small,
    required this.text,
    required this.tapCallback,
    this.longPressCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: tapCallback.call,
        onLongPress: longPressCallback?.call,
        child: Ink(
          decoration: const BoxDecoration(color: AppColors.secondary),
          child: Padding(
            padding: .symmetric(
              vertical: height,
              horizontal: AppSpacing.xsmall,
            ),
            child: Row(
              children: [
                if (icon != null) Icon(icon, color: AppColors.accent),
                if (icon != null && text.isNotEmpty) const SizedBox(width: 8),
                if (text.isNotEmpty) RegularText(text: text),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
