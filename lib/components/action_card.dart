import 'package:duty_selector/design.dart';
import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.color,
    required this.icon,
    this.text,
    this.tapCallback,
    this.longPressCallback,
  });

  final Color color;
  final Icon icon;
  final void Function()? tapCallback;
  final void Function()? longPressCallback;
  final String? text;

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
            color: color,
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          child: Padding(
            padding: const EdgeInsetsGeometry.all(AppSpacing.medium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [_generateCard()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _generateCard() {
    Widget widget = Center(child: icon);

    if (text != null) {
      widget = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(text!, style: AppTextStyles.regularBold),
          icon,
        ],
      );
    }

    return widget;
  }
}
