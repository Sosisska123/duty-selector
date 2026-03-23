import 'package:duty_selector/components/action_selection_card.dart';
import 'package:duty_selector/components/title_text.dart';
import 'package:duty_selector/design.dart';
import 'package:flutter/material.dart';

class SelectDuty extends StatelessWidget {
  const SelectDuty({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.medium,
      children: [
        TitleText(text: 'Выбрать дежурных'),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisSpacing: AppSpacing.small,
          mainAxisSpacing: AppRadius.medium,
          padding: EdgeInsets.all(AppSpacing.xsmall),
          children: [
            ActionSelectionCard(text: "Вручную"),
            ActionSelectionCard(text: "Рандом"),
            ActionSelectionCard(text: "По списку"),
          ],
        ),
      ],
    );
  }
}
