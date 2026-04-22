import 'package:duty_selector/design.dart';
import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  final Color color;

  final Icon icon;
  final void Function()? tapCallback;
  final void Function()? longPressCallback;
  final String? text;
  final String? descriptionText;
  const ActionCard({
    super.key,
    required this.color,
    required this.icon,
    this.text,
    this.descriptionText,
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
            color: color,
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          child: Padding(
            padding: const EdgeInsetsGeometry.all(AppSpacing.medium),
            child: _generateCard(),
          ),
        ),
      ),
    );
  }

  Widget _generateCard() {
    Widget widget = Center(child: Icon(icon.icon, color: icon.color, size: 80));

    if (text != null) {
      widget = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(text!, style: AppTextStyles.regularBold),
              icon,
            ],
          ),
        ],
      );

      // because it doesnt make sence to leave the description without the name
      if (descriptionText != null) {
        (widget as Column).children.add(
          Text(descriptionText!, style: AppTextStyles.smallAccent),
        );
      }
    }

    return widget;
  }
}
