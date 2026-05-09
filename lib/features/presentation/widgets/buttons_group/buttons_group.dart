import 'package:duty_selector/design.dart';
import 'package:flutter/material.dart';
import 'group_button.dart';

class ButtonsGroup extends StatelessWidget {
  final List<GroupButton> children;

  const ButtonsGroup({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: .circular(16),
      ),
      padding: const .all(AppRadius.small),
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) => Padding(
          padding: const .symmetric(vertical: AppRadius.medium),
          child: children[index],
        ),
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          thickness: 1,
          color: AppColors.accent,
          radius: .all(Radius.circular(8)),
        ),
        itemCount: children.length,
      ),
    );
  }
}
